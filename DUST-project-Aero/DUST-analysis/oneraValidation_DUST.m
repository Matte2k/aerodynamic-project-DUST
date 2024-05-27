clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./validation-onera"));
currentPath = pwd;

%% INPUT

% Parametric analysis input:
analysisName = 'aoa';
alphaDegVec  = [0 3.06]';

% Geometry settings  
wingConfig = 'sym';                 % 'right'  |  'left'  | 'sym'
wingLoad   = 'left';                % 'right'  |  'left'  | 'sym'           
wingOrigin = [0.0, 0.0, 0.0];

% Reference values:
Sref   = 0.7586;    % 0.75320;  
Cref   = 1;         % 0.64607;
PInf   = 12767;
rhoInf = 1.22498;
aInf   = 340.2966;  % Ma = 0.3
muInf  = [];
betaDeg  = 0;
absVelocity = 102.089;

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
clearData = true;                   % 'true' = clear current data  |  'false' = leaves old run data in memory
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
    plotFlag.struct = false;        % plot structural loads data over different parametric input


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
postPresetPath     = sprintf('%s/input-DUST/preset/preset_inDustPost_%s.in',oneraValidationPath,wingLoad);

% Geometry initialization
wingDesign = 'oneraM6';
configurationName = sprintf('%s_%s_%s',wingDesign,wingConfig,wingLoad);
if runDUST == true
    % Delete old run data in memory
    if clearData == true
        resetOneraValidationData(oneraValidationPath);
    end

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
        inDustRefVars  = inDustRefInit(PInf,rhoInf,aInf,muInf);
        inDustWakeVars = {wakeBox_min, wakeBox_max};
        inDustGeomVars = {geometry_file, reference_file};
        inDustVars = [u_inf{i},inDustRefVars,inDustWakeVars,inDustGeomVars];
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