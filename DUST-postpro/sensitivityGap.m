clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;

%% DUST data

% Reference value of the run to postprocess
[reference] = runReferenceValue(161.12,0.7708,2.65,26.56);

% Data parser for the different component of the geometry
load("data/gap/aeroLoads_gap.mat",'-mat');     
dataDUST.aeroLoads    = aeroLoads_gap;      clear('aeroLoads_gap');
load("data/gap/analysisData_gap.mat",'-mat');  
dataDUST.rawRunData   = analysisData_gap;   clear('analysisData_gap');
load("data/gap/structLoads_gap.mat",'-mat');   
dataDUST.structLoads  = structLoads_gap;    clear('structLoads_gap');
