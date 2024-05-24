clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./validation-onera"));
currentPath = pwd;

%% INPUT

% Parametric analysis input:
analysisName = 'aoa';
%alphaDegVec  = [0 3.06 5]';
alphaDegVec  = [3.06]';

% Geometry settings  
wingConfig = 'right';               % 'right'  |  'left'  | 'sym'
wingOrigin = [0.0, 0.0, 0.0];

% Reference values:
Sref = 0.75320;  
Cref = 0.64607;
rhoInf = 1.225;
betaDeg  = 0;
absVelocity = 5;

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
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


%% ONERA VALIDATION

% Preprocessing of some input values
u_inf =  cell(size(alphaDegVec,1),1);   % velocity cell initialization
for i = 1:size(alphaDegVec,1)           % loop computing velocity from aoa
    [~,u_inf{i}] = computeVelVec(alphaDegVec(i),betaDeg,absVelocity,plotFlag.text);
end
[wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,xBoxEnd],yBoxLimit,zBoxLimit);
runNameCell =  cell(size(alphaDegVec,1),1);         % run name cell initialization
timeCostVec = zeros(size(alphaDegVec,1),1);         % time cost vector initialization
startingPath = cd;      cd("./validation-onera");   % move to aircraft design path

% Geometry preset path selection (based on the user input)
oneraValidationPath = cd;
wingRightFilePath  = sprintf('%s/input-DUST/geometry-data/rightWing.in', oneraValidationPath);       
wingLeftFilePath   = sprintf('%s/input-DUST/geometry-data/leftWing.in',  oneraValidationPath);
postPresetPath     = sprintf('%s/input-DUST/preset/preset_inDustPost.in',oneraValidationPath);

% Geometry initialization
wingDesign = 'oneraM6';
configurationName = sprintf('%s_%s',wingDesign,wingConfig);
if runDUST == true
    % Delete old run data in memory
    resetOneraValidationData(oneraValidationPath)

    % References.in generation
    [inWingRefVars] = inRefInit('Wing',wingOrigin);
    [refFilePath] = refFileMaker_DUST(inWingRefVars,configurationName);                
    
    % Dust_pre.in generation
    switch wingConfig
        case 'right'
            comp_nameR = sprintf('comp_name = wing_right');
            geo_fileR  = sprintf('geo_file = %s',wingRightFilePath);
            ref_tagR   = sprintf('ref_tag = Wing');
            inPreVars  = {comp_nameR, geo_fileR, ref_tagR};
            
        case 'left'
            comp_nameL = sprintf('comp_name = wing_left');
            geo_fileL  = sprintf('geo_file = %s',wingLeftFilePath);
            ref_tagL   = sprintf('ref_tag = Wing');
            inPreVars  = {comp_nameL, geo_fileL, ref_tagL};
        
        case 'sym'
            comp_nameR = sprintf('comp_name = wing_right');
            geo_fileR  = sprintf('geo_file = %s',wingRightFilePath);
            ref_tagR   = sprintf('ref_tag = Wing');
            comp_nameL = sprintf('comp_name = wing_left');
            geo_fileL  = sprintf('geo_file = %s',wingLeftFilePath);
            ref_tagL   = sprintf('ref_tag = Wing');
            inPreVars  = {comp_nameR, geo_fileR, ref_tagR, ...
                          comp_nameL, geo_fileL, ref_tagL};
        otherwise
            error('insert a valid configuration between: left, right or sym');
    end
    [preFilePath,modelFilePath] = preFileMaker_DUST(inPreVars,configurationName); 
end


% Aircraft design main loop
for i = 1:size(alphaDegVec,1)
    runNameCell{i} = sprintf('%s_%s%.0f',configurationName,analysisName,alphaDegVec(i));    % parametric run name definition
    if runDUST == true
        % Dust.in generation
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustVars  = {u_inf{i}, wakeBox_min, wakeBox_max, geometry_file, reference_file};
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},postPresetPath);
        
        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(oneraValidationPath);
    end
end

% Postprocessing of the dust output
[designData]   = organizeData_DUST(runNameCell, alphaDegVec, alphaDegVec, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads]    = aeroLoads_DUST   (designData, absVelocity, rhoInf, Sref, plotFlag.aero);
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