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
resolutionFactor = [1 2 3]';
analysisName = 'mesh';

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
        % WingR.in must be picked according to mesh density
        wingRightFilePath = sprintf('%s/input-DUST/geometry-data/res%.0f_rightWing.in', ...
                                        meshAnalysisPath,resolutionFactor(i));      % set fuselage gap manually
        
        % WingL.in must be picked according to mesh density
        wingLeftFilePath = sprintf('%s/input-DUST/geometry-data/res%.0f_leftWing.in', ...
                                        meshAnalysisPath,resolutionFactor(i));      % set fuselage gap manually
        
        % Fuselage.in must be picked according to mesh density
        fuselageFilePath = sprintf('%s/input-DUST/geometry-data/res%.0f_fuselage.in', ...
                                        meshAnalysisPath,resolutionFactor(i));
        
        % References.in generation
        refFilePath = sprintf('%s/input-DUST/inDustRef.in',meshAnalysisPath);       % set fuselage gap manually

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
        cd(meshAnalysisPath);
    end
end

% Postprocessing of the dust output
aoaDegVec = alphaDeg * ones(1,length(resolutionFactor));
[analysisData_mesh] = organizeData_DUST(runNameCell, aoaDegVec, resolutionFactor, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads_mesh]    = aeroLoads_DUST   (analysisData_mesh, absVelocity, rhoInf, Sref, plotFlag.aero);
[structLoads_mesh]  = structLoads_DUST (analysisData_mesh, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

if saveOutput == true
    save("analysisData_mesh.mat","analysisData_mesh");
    save("aeroLoads_mesh.mat","aeroLoads_mesh");
    save("structLoads_mesh.mat","structLoads_mesh");
end

cd(startingPath);