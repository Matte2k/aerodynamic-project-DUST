%  
%       -- TIME STEP SENSITIVITY ANALYSIS for DUST simulation --
% 
%   Script built to compute in MATLAB a sensitiviy analysis on the time step
%   of a wing + fuselage configuration using DUST code.
%   The analysis parameters can be modified using the INPUT section of this file.
%   Only some particular DUST settings can be edited from this script...
%   
%   In order to change different parameters (not present here)
%   it's possible to operate directly on the Dust preset file:
%       > "./input-DUST/preset/...
%       > "./input-DUST/geometry-data/preset_inWing.in
%       > "./input-DUST/geometry-data/fuselage.in
%       > "./input-DUST/geometry-data/fuselage/...
%
%   WARNING:    change always wisely the input parameters and double check
%               results obtained... remember that there aren't much checks
%               on the input parameters, so the results can easily leads to 
%               unphysical output values or errors.
%
%                               
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./sensitivity-timestep"));
currentPath = pwd;


%% INPUT

% Parametric analysis input:
tstepVector  = [0.05 0.1 0.5 1]';
tstepRunName = [1    2   3   4]';              % must have same dimension as 'boxLenghtVector'
tlimit = [1 4]';
analysisName = 'tstep';

% Reference values:
Sref = 26.3;  
Cref = 5;
rhoInf = 1.225;
alphaDeg = 5;
betaDeg  = 0;
absVelocity = 5;

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
clearData = true;                   % 'true' = clear current data  |  'false' = leaves old run data in memory
nelem_chord = 5;                    % set nelem_chord for the top and nelem_chord for the bottom
xBoxStart = -5;
yBoxLimit = 10;
zBoxLimit = 10;
gapWingFuselage = 1;                % set distance between wing and fuselage

% Postprocessing settings:
saveOutput = true;
plotFlag = initGraphic();
    plotFlag.text = false;          % print some results in command window
    plotFlag.convergence = true;    % plot convergence over time for previous selected plot
    plotFlag.aero = false;          % plot aero loads data over different angle of attack
    plotFlag.struct = true;         % plot structural loads data over different parametric input


% Manual preset writing based on parametric analysis input:
fprintf('<strong>Manual writing of post processing preset file</strong>\n\n');
for i = 1:size(tstepVector,1)
    [start_res,end_res] = computePostRes(tstepRunName(i),tstepVector(i),tlimit,true);
end
fprintf('--------------------------------------------------------------\n\n');


%% TIME STEP SENSITIVITY ANALYSIS

% Preprocessing of some input values
[~,u_inf] = computeVelVec(alphaDeg,betaDeg,absVelocity,plotFlag.text);
runNameCell = cell(size(tstepVector,1),1);
timeCostVec = zeros(size(tstepVector,1),1);
inFixedFileName = sprintf('%s',analysisName);
startingPath = cd;      cd("./sensitivity-timestep");    % Move to mesh sensitivity analysis path

% Time step analysis loop
tstepAnalysisPath = cd;
fuselageFilePath = sprintf('%s/input-DUST/geometry-data/fuselage.in',tstepAnalysisPath);

if runDUST == true
    % Delete old run data in memory
    if clearData == true
        resetTimestepAnalysisData(tstepAnalysisPath);
    end

    % WingR.in generation
    [inWingRightVars] = inSymPartInit(nelem_chord,gapWingFuselage,'R');
    [wingRightFilePath] = wingFileMaker_DUST(inWingRightVars,inFixedFileName,'R');

    % WingL.in generation
    [inWingLeftVars] = inSymPartInit(nelem_chord,gapWingFuselage,'L');
    [wingLeftFilePath] = wingFileMaker_DUST(inWingLeftVars,inFixedFileName,'L');

    % References.in generation
    wingOrigin = [0,gapWingFuselage,0];
    [inRefVars] = inRefInit('Wing',wingOrigin);
    [refFilePath] = refFileMaker_DUST(inRefVars,inFixedFileName);

    % Dust_pre.in generation
    [inPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath,fuselageFilePath);
    [preFilePath,modelFilePath] = preFileMaker_DUST(inPreVars,inFixedFileName);
end

for i = 1:size(tstepVector,1)
    runNameCell{i} = sprintf('%s%.0f',analysisName,tstepRunName(i));
    if runDUST == true
        % Dust.in generation
        [wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,tstepVector(i)],yBoxLimit,zBoxLimit);        
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustTimeVars = inDustTimeInit(tstepVector(i),tlimit);
        inDustWakeVars = {wakeBox_min, wakeBox_max};
        inDustGeomVars = {geometry_file, reference_file};
        inDustVars = [inDustTimeVars,u_inf,inDustWakeVars,inDustGeomVars];
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        postPresetPath   = sprintf('%s/input-DUST/preset/preset_inDustPost_%.0f.in',tstepAnalysisPath,tstepRunName(i));
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},postPresetPath);

        % Dust run
        cd("./input-DUST");
        
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(tstepAnalysisPath);
    end
end

aoaDegVec = alphaDeg * ones(1,length(tstepVector));
[analysisData_tstep] = organizeData_DUST(runNameCell, aoaDegVec, tstepVector, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads_tstep]    = aeroLoads_DUST   (analysisData_tstep, absVelocity, rhoInf, Sref, plotFlag.aero);
[structLoads_tstep]  = structLoads_DUST (analysisData_tstep, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

if saveOutput == true
    save("analysisData_tstep.mat","analysisData_tstep");
    save("aeroLoads_tstep.mat","aeroLoads_tstep");
    save("structLoads_tstep.mat","structLoads_tstep");
end    

cd(startingPath);