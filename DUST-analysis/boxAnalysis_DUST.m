%  
%       -- BOX SENSITIVITY ANALYSIS for DUST simulation --
% 
%   Script built to compute in MATLAB a sensitiviy analysis on the wake box
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
addpath(genpath("./sensitivity-gap"));
currentPath = pwd;


%% INPUT

% Parametric analysis input:
boxLenghtVector  = [10 15 20]';
boxRunName = [1 2 3]';                          % must have same dimension as 'boxLenghtVector'
analysisName = 'box';

% Wing geometry settings:                       # possible input for different preset: #                                
wingOrigin   = [-0.5, 1.0, 0.0];
wingSymPoint = [0 -wingOrigin(2) 0];
wingSymNorm  = [0 1 0];
wingConfig   = 'sym';                           %  none'    |   'right'  |   'left'  |   'sym'
wingChordRes = 5;

% Fuselage geometry settings:
fuselageOrigin   = [0.0, 0.0, 0.0];
fuselageSymPoint = [0 -fuselageOrigin(2) 0];
fuselageSymNorm  = [0 1 0];
fuselageConfig   = 'none';                      % 'none'    |   'right'  |   'left'  |   'sym'
%fuselageOrientation = [0.0, -1.0,  0.0;...
%                       1.0,  0.0,  0.0;...
%                       0.0,  0.0,  1.0];       % rotate correctly the mesh of the fuselage

% Reference values:
Sref = 26.56;           % symmetric wing = 26.56    |   half wing = 13.28
Cref = 5;               % TBD
rhoInf = 1.225;
alphaDeg = 5;
betaDeg  = 0;
absVelocity = 5;

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
clearData = true;                   % 'true' = clear current data  |  'false' = leaves old run data in memory
xBoxStart = -5;
yBoxLimit = 10;
zBoxLimit = 10;
gapWingFuselage = 1;                % set distance between wing and fuselage

%DUST_post settings:
ppAnalysisList = {'load_wingF','visual_wingF'}; 

% Postprocessing settings:
saveOutput = true;
plotFlag = initGraphic();
    plotFlag.text = false;          % print some results in command window
    plotFlag.convergence = true;    % plot convergence over time for previous selected plot
    plotFlag.aero = false;          % plot aero loads data over different angle of attack
    plotFlag.struct = true;         % plot structural loads data over different parametric input


%% BOX SENSITIVITY ANALYSIS

% Preprocessing of some input values
[~,u_inf] = computeVelVec(alphaDeg,betaDeg,absVelocity,plotFlag.text);
runNameCell = cell(size(boxLenghtVector,1),1);
runDataPath = cell(size(alphaDegVec,1),1);         
timeCostVec = zeros(size(boxLenghtVector,1),1);
startingPath = cd;      cd("./sensitivity-box");    % Move to mesh sensitivity analysis path

% Delete old run data in memory
boxAnalysisPath = cd;
if runDUST == true && clearData == true
    resetDustData(boxAnalysisPath);
end

% Geometry and Reference configuration build for DUST
if runDUST == true
    %%% WING
    if ~isequal(wingConfig,'none')
        % Wing preset and reference definition
        wingPresetPath = sprintf('%s/input-DUST/preset/preset_inWing_%s.in',boxAnalysisPath,analysisName);
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
    else
        % No wing reference notification
        inWingRefVars = '! no wing reference created';
        inWingPreVars = '! no wing geometry created';
    
    end
    
    
    %%% FUSELAGE
    if ~isequal(fuselageConfig,'none')
        % Fuselage preset and reference definition
        fuselagePresetPath = sprintf('%s/input-DUST/preset/preset_inFuselage_%s.in',boxAnalysisPath,analysisName);
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

% Box analysis loop
for i = 1:size(boxLenghtVector,1)
    runNameCell{i} = sprintf('%s%.0f',analysisName,boxRunName(i));
    runDataPath{i} = sprintf('pp-DUST/%s/pp_loads.dat',runNameCell{i});
    if runDUST == true
        % Dust.in generation
        [wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,boxLenghtVector(i)],yBoxLimit,zBoxLimit);        
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustVars  = {u_inf, wakeBox_min, wakeBox_max, geometry_file, reference_file};
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},ppAnalysisList);

        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(boxAnalysisPath);
    end
end

% Postprocessing of the dust output
aoaDegVec = alphaDeg * ones(1,length(boxLenghtVector));
[analysisData_box] = organizeData_DUST(runDataPath, aoaDegVec, boxLenghtVector, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads_box]    = aeroLoads_DUST   (analysisData_box, absVelocity, rhoInf, Sref, Cref, plotFlag.aero);
[structLoads_box]  = structLoads_DUST (analysisData_box, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

if saveOutput == true
    save("analysisData_box.mat","analysisData_box");
    save("aeroLoads_box.mat","aeroLoads_box");
    save("structLoads_box.mat","structLoads_box");
end    

cd(startingPath);