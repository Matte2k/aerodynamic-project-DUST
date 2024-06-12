%  
%       -- TIME STEP SENSITIVITY ANALYSIS for DUST simulation --
% 
%   Script built to compute in MATLAB a sensitiviy analysis on the time step
%   of a wing + fuselage configuration using DUST code.
%   The geometry can be built in different ways using 'wingConfig' and 
%   'fuselageConfig' input variable.
%   The analysis parameters can be modified using the INPUT section of this file.
%   Only some particular DUST settings can be edited from this script...
%   
%   In order to change different parameters (not present here)
%   it's possible to operate directly on the Dust preset file:
%       > "./input-DUST/preset/...
%       > "./input-DUST/geometry-data/fuselage/...
%
%   The list of possible post processing analysis can be edited to add some
%   desired analysis as ".in" file in the folder: 
%       > "./input-DUST/preset/postAnalysis/.."
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
tstepVector  = [0.05 0.1 0.5 1]';       %
tstepRunName = [1    2   3   4]';       %
tlimit = [1 1.3]';                      %
analysisName = 'tstep';

% Wing geometry settings:                       # possible input for different preset: #                                
wingOrigin   = [0.0, 0.0, 0.0];
wingSymPoint = [0 -wingOrigin(2) 0];
wingSymNorm  = [0 1 0];
wingConfig   = 'sym';                           %  _____    |   'right'  |   'left'  |   'sym'
wingChordRes = 5;

% Fuselage geometry settings:
fuselageOrigin   = [0.0, 0.0, 0.0];
fuselageSymPoint = [0 -fuselageOrigin(2) 0];
fuselageSymNorm  = [0 1 0];
fuselageConfig   = 'none';                      % 'none'    |   'right'  |   'left'  |   'sym'

% Reference values:
Sref = 26.56;           % symmetric wing = 26.56    |   half wing = 13.28
Cref = 2.65;            % in the old sym was 5
PInf = 57181.965;       
rhoInf = 0.7708;        % in the old sym was 1.225 
alphaDeg = 5;
betaDeg  = 0;
absVelocity = 161.12;   % in the old sym was 50
aInf  = 322.239;
muInf = 3.43e-7;

% DUST settings:
runDUST    = true;                  % 'true' = run dust  |  'false' = use data already in memory
clearData  = true;                  % 'true' = clear current data  |  'false' = leaves old run data in memory
xBoxStart  = -5;
xBoxEnd    = 10;
yBoxLimit  = 10;
zBoxLimit  = 10;

%DUST_post settings:
ppAnalysisList = {'load_wingF','visual_wingL'};

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
%return     % use 'return' here to run until here and set the preset according to input parameters


%% TIME STEP SENSITIVITY ANALYSIS

% Preprocessing of some input values
[~,u_inf] = computeVelVec(alphaDeg,betaDeg,absVelocity,plotFlag.text);
[wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,xBoxEnd],yBoxLimit,zBoxLimit);
ppAnalysisCell = ppAnalysisTimestep(ppAnalysisList,tstepRunName);
runNameCell = cell(size(tstepVector,1),1);
runDataPath = cell(size(tstepVector,1),1); 
timeCostVec = zeros(size(tstepVector,1),1);
startingPath = cd;      cd("./sensitivity-timestep");           % move to mesh sensitivity analysis path

% Delete old run data in memory
tstepAnalysisPath = cd;
if runDUST == true && clearData == true
    resetDustData(tstepAnalysisPath);
end

% Geometry and Reference configuration build for DUST
if runDUST == true
    %%% WING
    % Wing preset and reference definition
    wingPresetPath = sprintf('%s/input-DUST/preset/preset_inWing_%s.in',tstepAnalysisPath,analysisName);
    [inWingRefVars] = inRefInit('Wing',wingOrigin);  

    % WingR.in generation
    if isequal(wingConfig,'right') || isequal(wingConfig,'sym')
    [inWingRightVars]   = inSymPartInit(wingChordRes,wingSymPoint,wingSymNorm,'R');
    [wingRightFilePath] = wingFileMaker_DUST(inWingRightVars,analysisName,'R',wingPresetPath);
        if isequal(wingConfig,'right')
            [inWingPreVars] = inPreWingInit(wingRightFilePath); % wing pre variables for only right wing
        end
    end
    
    % WingL.in generation
    if isequal(wingConfig,'left') || isequal(wingConfig,'sym')
    [inWingLeftVars]   = inSymPartInit(wingChordRes,wingSymPoint,wingSymNorm,'L');
    [wingLeftFilePath] = wingFileMaker_DUST(inWingLeftVars,analysisName,'L',wingPresetPath);
        if isequal(wingConfig,'right')
            [inWingPreVars] = inPreWingInit(wingLeftFilePath);  % wing pre variables for only left wing
        end
    end

    % Write wing pre variables for symmetric configuration
    if isequal(wingConfig,'sym')
        [inWingPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath);
    end
    
    
    %%% FUSELAGE
    if ~isequal(fuselageConfig,'none')
        % Fuselage preset and reference definition
        fuselagePresetPath = sprintf('%s/input-DUST/preset/preset_inFuselage_%s.in',tstepAnalysisPath,analysisName);
        [inFuselageRefVars] = inRefInit('Body',fuselageOrigin);                 % 'fuselageOrientation' to correct direction

        % FuselageR.in generation
        if isequal(fuselageConfig,'right') || isequal(fuselageConfig,'sym')
            [inFuselageRightVars]   = inSymPartInit([],fuselageSymPoint,fuselageSymNorm,'R');
            [fuselageRightFilePath] = fuselageFileMaker_DUST(inFuselageRightVars,analysisName,'R',fuselagePresetPath);
            if isequal(fuselageConfig,'right')
                [inFuselagePreVars] = inPreFuselageInit(fuselageRightFilePath); % fuselage pre variables for only right config
            end
        end

        % FuselageL.in generation
        if isequal(fuselageConfig,'left') || isequal(fuselageConfig,'sym')
        [inFuselageLeftVars]   = inSymPartInit([],fuselageSymPoint,fuselageSymNorm,'L');
        [fuselageLeftFilePath] = fuselageFileMaker_DUST(inFuselageLeftVars,analysisName,'L',fuselagePresetPath);
            if isequal(fuselageConfig,'left')
                [inFuselagePreVars] = inPreFuselageInit(fuselageLeftFilePath); % fuselage pre variables for only left config
            end
        end

        % Write fuselage pre variables for symmetric configuration
        if isequal(fuselageConfig,'sym')
            [inFuselagePreVars] = inPreFuselageInit(fuselageRightFilePath,fuselageLeftFilePath);
        end
    
    else
        % No fuselage reference notification
        inFuselageRefVars = '! no fuselage reference created';
        inFuselagePreVars = '! no fuselage geometry created';
    
    end
     
    % References.in generation
    inRefVars = [inWingRefVars,inFuselageRefVars];
    [refFilePath] = refFileMaker_DUST(inRefVars,analysisName);

    % Dust_pre.in generation
    inPreVars = [inWingPreVars,inFuselagePreVars];
    [preFilePath,modelFilePath] = preFileMaker_DUST(inPreVars,analysisName);
end

% Tstep analysis loop
for i = 1:size(tstepVector,1)
    runNameCell{i} = sprintf('%s%.0f',analysisName,tstepRunName(i));
    runDataPath{i} = sprintf('pp-DUST/%s/pp_loads.dat',runNameCell{i});
    if runDUST == true
        % Dust.in generation      
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustTimeVars = inDustTimeInit(tstepVector(i),tlimit);
        inDustWakeVars = {wakeBox_min, wakeBox_max};
        inDustGeomVars = {geometry_file, reference_file};
        inDustVars = [inDustTimeVars,u_inf,inDustWakeVars,inDustGeomVars];
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},ppAnalysisCell(i,:));

        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(tstepAnalysisPath);
    end
end

% Postprocessing of the dust output
aoaDegVec = alphaDeg * ones(1,length(tstepVector));
[analysisData_tstep] = organizeData_DUST(runDataPath, aoaDegVec, tstepVector, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads_tstep]    = aeroLoads_DUST   (analysisData_tstep, absVelocity, rhoInf, Sref, Cref, plotFlag.aero);
[structLoads_tstep]  = structLoads_DUST (analysisData_tstep, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

if saveOutput == true
    save("analysisData_tstep.mat","analysisData_tstep");
    save("aeroLoads_tstep.mat","aeroLoads_tstep");
    save("structLoads_tstep.mat","structLoads_tstep");
end    

cd(startingPath);