%  
%       -- MAIN for DUST simulation --
% 
%   Script built to execute and/or delete data of the different MATLAB and
%   DUST analysis scripts present in the current project.
%   
%   In order to change different input parameters open the target script
%   and edit directly the INPUT section. Then save the file and by
%   executing the analysis from this script the new input parameters will
%   be used.
%
%   In order to execute only some analysis of the complete set present in
%   the project run the different section of this script.
%   Remember always to run this first section when opens this script in
%   order to add to path the project function folder ("/src").
%
%   WARNING:    Since all the variables are cleared when the script of the
%               single analysis runs... the order of execution is: 
%                   1) data delete if set active
%                   2) analysis execution if set active
%               This means that to delete current output file in memory
%               this script must be executed with the flags:
%                   - 'runScript = false'
%                   - 'dataDelete = true'
%               Otherwise the current file will be deleted but soon after
%               the new output file will be saved in memory
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

clearvars;  close all;  clc
addpath(genpath("./src"));


%% ONERA VALIDATION

% INPUT Flag
dataDelete = true;
runScript  = false;


% delete aircraft design output data loaded in memory
if dataDelete == true
    mainPath = pwd;
    oneraValidationPath = sprintf('%s/validation-onera',mainPath);
    resetDustData(oneraValidationPath);
end

% exectue the aircraft design
if runScript == true
    run oneraValidation_DUST.m;
end


%% GAP sensitivity ANALYSIS

% INPUT Flag
dataDelete = true;
runScript  = false;


% delete gap sensitivity analysis output data loaded in memory
if dataDelete == true
    mainPath = pwd; 
    gapAnalysisPath = sprintf('%s/sensitivity-gap',mainPath);
    resetDustData(gapAnalysisPath);
end

% exectue the gap sensitivity analysis
if runScript == true
    run gapAnalysis_DUST.m;
end


%% MESH sensitivity ANALYSIS

% INPUT Flag
dataDelete = true;
runScript  = false;


% delete mesh sensitivity analysis output data loaded in memory
if dataDelete == true
    mainPath = pwd;
    meshAnalysisPath = sprintf('%s/sensitivity-mesh',mainPath);
    resetDustData(meshAnalysisPath);
end

% exectue the mesh sensitivity analysis
if runScript == true
    run meshAnalysis_DUST.m;
end


%% BOX sensitivity ANALYSIS

% INPUT Flag
dataDelete = true;
runScript  = false;


% delete box sensitivity analysis output data loaded in memory
if dataDelete == true
    mainPath = pwd;
    boxAnalysisPath = sprintf('%s/sensitivity-box',mainPath);
    resetDustData(boxAnalysisPath);
end

% exectue the box sensitivity analysis
if runScript == true
    run boxAnalysis_DUST.m;
end


%% TIME-STEP sensitivity ANALYSIS

% INPUT Flag
dataDelete = true;
runScript  = false;


% delete box sensitivity analysis output data loaded in memory
if dataDelete == true
    mainPath = pwd;
    timestepAnalysisPath = sprintf('%s/sensitivity-timestep',mainPath);
    resetDustData(timestepAnalysisPath);
end

% exectue the box sensitivity analysis
if runScript == true
    run timestepAnalysis_DUST.m;
end


%% AIRCRAFT DESIGN

% INPUT Flag
dataDelete = true;
runScript  = false;


% delete aircraft design output data loaded in memory
if dataDelete == true
    mainPath = pwd;
    aircraftDesignPath = sprintf('%s/design-aircraft',mainPath);
    resetDustData(aircraftDesignPath);
end

% exectue the aircraft design
if runScript == true
    run aircraftDesign_DUST.m;
end

