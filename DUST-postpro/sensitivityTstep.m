clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;

%% DUST data

% Reference value of the run to postprocess
[reference] = runReferenceValue(161.12,0.7708,2.65,26.56);

% Data parser for the different component of the geometry
load("data/tstep/aeroLoads_tstep.mat",'-mat');     
dataDUST.aeroLoads    = aeroLoads_tstep;      clear('aeroLoads_tstep');
load("data/tstep/analysisData_tstep.mat",'-mat');  
dataDUST.rawRunData   = analysisData_tstep;   clear('analysisData_tstep');
load("data/tstep/structLoads_tstep.mat",'-mat');   
dataDUST.structLoads  = structLoads_tstep;    clear('structLoads_tstep');
