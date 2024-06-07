%  
%       -- MESH SENSITIVITY ANALYSIS for DUST simulation --
% 
%   Script built to compute in MATLAB a sensitiviy analysis on the mesh of
%   wing + fuselage configuration using DUST code.
%   The analysis parameters can be modified using the INPUT section of this file.
%   Only some particular DUST settings can be edited from this script...
%   
%   In order to change different parameters (not present here)
%   it's possible to operate directly on the Dust preset file:
%       > "./input-DUST/preset/...
%       > "./input-DUST/geometry-data/...
%       > "./input-DUST/geometry-data/fuselage/...
%
%   WARNING:    change always wisely the input parameters and double check
%               results obtained... remember that there aren't much checks
%               on the input parameters, so the results can easily leads to 
%               unphysical output values or errors.
%
%   WARNING:  fuselage gap is NOT a variable and must be manually definied
%             in: rightWing.in, leftWing.in and inDustRef.in files
%             ... remember that gap in mirror origin must be equal to "-gap"
%                               
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./sensitivity-mesh"));
currentPath = pwd;


%% INPUT

% Parametric analysis input:
%resolutionFactor = [1 2 3]';
resolutionFactor = 1;
analysisName = 'mesh';                  

% Wing geometry settings:               # possible input for different preset: #                                
wingOrigin   = [-0.5, 1.0, 0.0];
wingSymPoint = [0 -wingOrigin(2) 0];
wingSymNorm  = [0 1 0];
wingDesign   = 'sym';                   %  _____    |   'right'  |   'left'  |   'sym'

% Fuselage geometry settings:
fuselageOrigin   = [0.0, 0.0, 0.0];
fuselageSymPoint = [0 -fuselageOrigin(2) 0];
fuselageSymNorm  = [0 1 0];
fuselageDesign   = 'right';               % 'none'    |   'right'  |   'left'  |   'sym'
%fuselageOrientation = [0.0,-1.0,0.0; 1.0,0.0,0.0; 0.0,0.0,1.0];     % rotate correctly the mesh

% Reference values:
Sref = 26.56;           % symmetric wing = 26.56    |   half wing = 13.28
Cref = 5;               % TBD
rhoInf = 1.225;
alphaDeg = 5;
betaDeg  = 0;
absVelocity = 5;

% DUST settings:
runDUST   = true;       % 'true' = run dust  |  'false' = use data already in memory
clearData = true;       % 'true' = clear current data  |  'false' = leaves old run data in memory
nelem_chord = 5;        % set nelem_chord for the top and nelem_chord for the bottom
xBoxStart = -5;
xBoxEnd   = 10;
yBoxLimit = 10;
zBoxLimit = 10;

%DUST_post settings:    % see list of available analysis at: "./input-DUST/preset/postAnalysis"
ppAnalysisList = {'load_wingF','visual_wingF','visual_fuselageR'};   

% Postprocessing settings:
saveOutput = true;
plotFlag = initGraphic();
    plotFlag.text = false;          % print some results in command window
    plotFlag.convergence = false;    % plot convergence over time for previous selected plot
    plotFlag.aero = false;          % plot aero loads data over different angle of attack
    plotFlag.struct = false;         % plot structural loads data over different parametric input


%% MESH SENSITIVITY ANALYSIS

% Preprocessing of some input values
[~,u_inf] = computeVelVec(alphaDeg,betaDeg,absVelocity,plotFlag.text);
[wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,xBoxEnd],yBoxLimit,zBoxLimit);
runNameCell = cell(size(resolutionFactor,1),1);
timeCostVec = zeros(size(resolutionFactor,1),1);
startingPath = cd;                  cd("./sensitivity-mesh");

% Delete old run data in memory
meshAnalysisPath = cd;
if runDUST == true && clearData == true
    resetMeshAnalysisData(meshAnalysisPath);
end

% Mesh analysis loop
for i = 1:size(resolutionFactor,1)
    runNameCell{i} = sprintf('%s%.0f',analysisName,resolutionFactor(i));
    if runDUST == true
        resolutionName = sprintf('res%.0f',resolutionFactor(i));

        %%% WING
        % Wing preset and reference definition
        wingPresetPath = sprintf('%s/input-DUST/preset/preset_inWing_%s.in',meshAnalysisPath,resolutionName);
        [inWingRefVars] = inRefInit('Wing',wingOrigin);  

        % WingR.in generation
        if isequal(wingDesign,'right') || isequal(wingDesign,'sym')
        [inWingRightVars]   = inSymPartInit([],wingSymPoint,wingSymNorm,'R');
        [wingRightFilePath] = wingFileMaker_DUST(inWingRightVars,resolutionName,'R',wingPresetPath);
            if isequal(wingDesign,'right')
                [inWingPreVars] = inPreWingInit(wingRightFilePath); % wing pre variables for only left wing
            end
        end
        
        % WingL.in generation
        if isequal(wingDesign,'left') || isequal(wingDesign,'sym')
        [inWingLeftVars]   = inSymPartInit([],wingSymPoint,wingSymNorm,'L');
        [wingLeftFilePath] = wingFileMaker_DUST(inWingLeftVars,resolutionName,'L',wingPresetPath);
            if isequal(wingDesign,'right')
                [inWingPreVars] = inPreWingInit(wingLeftFilePath);  % wing pre variables for only right wing
            end
        end

        % Write wing pre variables for symmetric configuration
        if isequal(wingDesign,'sym')
            [inWingPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath);
        end


        %%% FUSELAGE
        if ~isequal(fuselageDesign,'none')
            % Fuselage preset and reference definition
            fuselagePresetPath = sprintf('%s/input-DUST/preset/preset_inFuselage_%s.in',meshAnalysisPath,resolutionName);
            [inFuselageRefVars] = inRefInit('Body',fuselageOrigin);                 % 'fuselageOrientation' to correct direction

            % FuselageR.in generation
            if isequal(fuselageDesign,'right') || isequal(fuselageDesign,'sym')
                [inFuselageRightVars]   = inSymPartInit([],fuselageSymPoint,fuselageSymNorm,'R');
                [fuselageRightFilePath] = fuselageFileMaker_DUST(inFuselageRightVars,resolutionName,'R',fuselagePresetPath);
                if isequal(fuselageDesign,'right')
                    [inFuselagePreVars] = inPreFuselageInit(fuselageRightFilePath); % fuselage pre variables for only left config
                end
            end

            % FuselageL.in generation
            if isequal(fuselageDesign,'left') || isequal(fuselageDesign,'sym')
            [inFuselageLeftVars]   = inSymPartInit([],fuselageSymPoint,fuselageSymNorm,'L');
            [fuselageLeftFilePath] = fuselageFileMaker_DUST(inFuselageLeftVars,resolutionName,'L',fuselagePresetPath);
                if isequal(fuselageDesign,'left')
                    [inFuselagePreVars] = inPreFuselageInit(fuselageLeftFilePath); % fuselage pre variables for only left config
                end
            end

            % Write fuselage pre variables for symmetric configuration
            if isequal(fuselageDesign,'sym')
                [inFuselagePreVars] = inPreFuselageInit(fuselageRightFilePath,fuselageLeftFilePath);
            end
        
        else
            % No fuselage reference notification
            inFuselageRefVars = '! no fuselage reference created';
            inFuselagePreVars = '! no fuselage geometry created';
        
        end
      
        
        % References.in generation
        inRefVars = [inWingRefVars,inFuselageRefVars];
        [refFilePath] = refFileMaker_DUST(inRefVars,runNameCell{i}); 

        % Dust_pre.in generation
        inPreVars = [inWingPreVars,inFuselagePreVars];
        [preFilePath,modelFilePath] = preFileMaker_DUST(inPreVars,runNameCell{i});

        % Dust.in generation
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustVars  = {u_inf, wakeBox_min, wakeBox_max, geometry_file, reference_file};
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},ppAnalysisList);

        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(meshAnalysisPath);
    end
end

% Postprocessing of the dust output
aoaDegVec = alphaDeg * ones(1,length(resolutionFactor));
[analysisData_mesh] = organizeData_DUST(runNameCell, aoaDegVec, resolutionFactor, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads_mesh]    = aeroLoads_DUST   (analysisData_mesh, absVelocity, rhoInf, Sref, Cref, plotFlag.aero);
[structLoads_mesh]  = structLoads_DUST (analysisData_mesh, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

if saveOutput == true
    save("analysisData_mesh.mat","analysisData_mesh");
    save("aeroLoads_mesh.mat","aeroLoads_mesh");
    save("structLoads_mesh.mat","structLoads_mesh");
end

cd(startingPath);