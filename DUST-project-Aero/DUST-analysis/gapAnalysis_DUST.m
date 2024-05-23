%  
%       -- GAP SENSITIVITY ANALYSIS for DUST simulation --
% 
%   Script built to compute in MATLAB a sensitiviy analysis on the gap between
%   wing + fuselage configuration using DUST code.
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
addpath(genpath("./sensitivity-gap"));
currentPath = pwd;


%% INPUT

% Parametric analysis input:
analysisName = 'gap';
gapVector  = [0 1 2 3 4 5]';
gapRunName = [1 2 3 4 5 6]';        % must have same dimension as 'gapVector'

% Reference values:
Sref = 26.3;  
Cref = 5;
rhoInf = 1.225;
alphaDeg = 5;
betaDeg  = 0;
absVelocity = 5;

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
nelem_chord = 5;                    % set nelem_chord for the top and nelem_chord for the bottom
xBoxStart = -5;
xBoxEnd   = 10;
yBoxLimit = 10;
zBoxLimit = 10;

% Postprocessing settings:
saveOutput = true;
plotFlag = initGraphic();
    plotFlag.text = false;          % print some results in command window
    plotFlag.convergence = true;    % plot convergence over time for previous selected plot
    plotFlag.aero = false;          % plot aero loads data over different angle of attack
    plotFlag.struct = true;         % plot structural loads data over different parametric input


%% GAP SENSITIVITY ANALYSIS

% Preprocessing of some input values
[~,u_inf] = computeVelVec(alphaDeg,betaDeg,absVelocity,plotFlag.text);
[wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,xBoxEnd],yBoxLimit,zBoxLimit);
runNameCell = cell(size(gapVector,1),1);
timeCostVec = zeros(size(gapVector,1),2);
startingPath = cd;      cd("./sensitivity-gap");    % Move to gap sensitivity analysis path

% Delete old run data in memory
gapAnalysisPath = cd;
if runDUST == true
    resetGapAnalysisData(gapAnalysisPath);
end

% Gap analysis main loop
fuselageFilePath = sprintf('%s/input-DUST/geometry-data/fuselage.in',gapAnalysisPath);  % fuselage path definition
for i = 1:size(gapVector,1)
    runNameCell{i} = sprintf('%s%.0f',analysisName,gapRunName(i));                      % parametric run name definition
    if runDUST == true
        % WingR.in generation
        [inWingRightVars] = inSymPartInit(nelem_chord,gapVector(i),'R');
        [wingRightFilePath] = wingFileMaker_DUST(inWingRightVars,runNameCell{i},'R');

        % WingL.in generation
        [inWingLeftVars] = inSymPartInit(nelem_chord,gapVector(i),'L');
        [wingLeftFilePath] = wingFileMaker_DUST(inWingLeftVars,runNameCell{i},'L');

        % References.in generation
        wingOrigin  = [0, gapVector(i), 0];
        [inRefVars] = inRefInit('Wing',wingOrigin);
        [refFilePath] = refFileMaker_DUST(inRefVars,runNameCell{i});

        % Dust_pre.in generation
        [inPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath,fuselageFilePath);
        [preFilePath,modelFilePath] = preFileMaker_DUST(inPreVars,runNameCell{i});

        % Dust.in generation
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustVars  = {u_inf, wakeBox_min, wakeBox_max, geometry_file, reference_file};
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i});

        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(gapAnalysisPath);
    end
end

% Postprocessing of the dust output
aoaDegVec = alphaDeg * ones(1,length(gapVector));
[analysisData_gap] = organizeData_DUST(runNameCell, aoaDegVec, gapVector, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads_gap]    = aeroLoads_DUST   (analysisData_gap, absVelocity, rhoInf, Sref, plotFlag.aero);
[structLoads_gap]  = structLoads_DUST (analysisData_gap, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

if saveOutput == true
    save("analysisData_gap.mat","analysisData_gap");
    save("aeroLoads_gap.mat","aeroLoads_gap");
    save("structLoads_gap.mat","structLoads_gap");
end

cd(startingPath);