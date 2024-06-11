%  
%       -- ONERA M6 WING VALIDATION for DUST simulation --
% 
%   Script built to compute in MATLAB a validation of DUST code by running the 
%   well known test case of the ONERA-M6 wing.
%   The geometry can be built in different ways using 'wingConfig' and 
%   'fuselageConfig' input variable.
%   The analysis parameters can be modified using the INPUT section of this file.
%   Only some particular DUST settings can be edited from this script...
%   
%   In order to change different parameters (not present here)
%   it's possible to operate directly on the Dust preset file:
%       > "./input-DUST/preset/...
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
addpath(genpath("./validation-onera"));
currentPath = pwd;

%% INPUT

% Parametric analysis input:
analysisName = 'aoa';
alphaDegVec  = [0 3.06 6.12]';
configurationName = 'validationONERA';

% Geometry settings  
wingOrigin   = [0.0, 0.0, 0.0];
wingSymPoint = [0 -wingOrigin(2) 0];
wingSymNorm  = [0 1 0];
wingConfig   = 'sym';               % 'right'     |   'left'    |   'sym'

% Reference values:                 % Ma 0.3000   |   Ma 0.8395
Sref   = 0.7586;      
Cref   = 1;         
PInf   = 12767;                     % 12767       |   99973.8
rhoInf = 1.22498;  
aInf   = 340.2966;                  % 340.2966    |   ___
muInf  = [];
betaDeg  = 0;
absVelocity = 102.089;              % 102.089     |  285.679

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
clearData = true;                   % 'true' = clear current data  |  'false' = leaves old run data in memory
xBoxStart = -5;
xBoxEnd   = 20;
yBoxLimit = 10;
zBoxLimit = 10;

%DUST_post settings:
ppAnalysisList = {'load_wingL','visual_wingL','chord_wingL'};  

% Postprocessing settings:
saveOutput = true;
plotFlag = initGraphic();
    plotFlag.text = false;          % print some results in command window
    plotFlag.convergence = true;    % plot convergence over time for previous selected plot
    plotFlag.aero = false;          % plot aero loads data over different angle of attack
    plotFlag.struct = false;        % plot structural loads data over different parametric input


%% ONERA VALIDATION

% Preprocessing of some input values
u_inf =  cell(size(alphaDegVec,1),1);   % velocity cell initialization
for i = 1:size(alphaDegVec,1)           % loop computing velocity from aoa
    [~,u_inf{i}] = computeVelVec(alphaDegVec(i),betaDeg,absVelocity,plotFlag.text);
end
[wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,xBoxEnd],yBoxLimit,zBoxLimit);
runNameCell  = cell(size(alphaDegVec,1),1);         % run name cell initialization
runDataPath  = cell(size(alphaDegVec,1),1);         % run data path cell initialization
timeCostVec  = zeros(size(alphaDegVec,1),1);        % time cost vector initialization
startingPath = cd;      cd("./validation-onera");   % move to aircraft design path

% Geometry preset path selection (based on the user input)
oneraValidationPath = cd;
if runDUST == true && clearData == true
    resetDustData(oneraValidationPath);
end

% Geometry initialization
wingDesign = 'oneraM6';
if runDUST == true
    % Wing preset and reference definition
    wingPresetPath = sprintf('%s/input-DUST/preset/preset_inWing_%s.in',oneraValidationPath,wingDesign);
    [inWingRefVars] = inRefInit('Wing',wingOrigin);  

    % WingR.in generation
    if isequal(wingConfig,'right') || isequal(wingConfig,'sym')
    [inWingRightVars]   = inSymPartInit([],wingSymPoint,wingSymNorm,'R');
    [wingRightFilePath] = wingFileMaker_DUST(inWingRightVars,wingDesign,'R',wingPresetPath);
        if isequal(wingConfig,'right')
            [inWingPreVars] = inPreWingInit(wingRightFilePath); % wing pre variables for only right wing
        end
    end

    % WingL.in generation
    if isequal(wingConfig,'left') || isequal(wingConfig,'sym')
    [inWingLeftVars]   = inSymPartInit([],wingSymPoint,wingSymNorm,'L');
    [wingLeftFilePath] = wingFileMaker_DUST(inWingLeftVars,wingDesign,'L',wingPresetPath);
        if isequal(wingConfig,'right')
            [inWingPreVars] = inPreWingInit(wingLeftFilePath);  % wing pre variables for only left wing
        end
    end

    % Write wing pre variables for symmetric configuration
    if isequal(wingConfig,'sym')
        [inWingPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath);
    end

    % References.in generation
    [refFilePath] = refFileMaker_DUST(inWingRefVars,wingDesign);

    % Dust_pre.in generation
    [preFilePath,modelFilePath] = preFileMaker_DUST(inWingPreVars,wingDesign);
end

% Aircraft design main loop
for i = 1:size(alphaDegVec,1)
    runNameCell{i} = sprintf('%s_%s%.0f',configurationName,analysisName,alphaDegVec(i));    % parametric run name definition
    runDataPath{i} = sprintf('pp-DUST/%s/pp_loads.dat',runNameCell{i});
    if runDUST == true
        % Dust.in generation
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustRefVars  = inDustRefInit(PInf,rhoInf,aInf,muInf);
        inDustWakeVars = {wakeBox_min, wakeBox_max};
        inDustGeomVars = {geometry_file, reference_file};
        inDustVars = [u_inf{i},inDustRefVars,inDustWakeVars,inDustGeomVars];
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},ppAnalysisList);
        
        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(oneraValidationPath);       
    end
end

% Postprocessing of the dust output
[designData]   = organizeData_DUST(runDataPath, alphaDegVec, alphaDegVec, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads]    = aeroLoads_DUST   (designData, absVelocity, rhoInf, Sref, Cref, plotFlag.aero);
[structLoads]  = structLoads_DUST (designData, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

% Save poostprocessing result in design folder
if saveOutput == true
    dataName = sprintf('%s_designData.mat',configurationName);
    save(dataName,"designData");
    aeroName = sprintf('%s_aeroLoads.mat',configurationName);
    save(aeroName,"aeroLoads");
    structName = sprintf('%s_structLoads.mat',configurationName);
    save(structName,"structLoads");
end

cd(startingPath);