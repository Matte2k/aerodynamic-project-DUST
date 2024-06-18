clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;

%% DUST data

% Reference value of the run to postprocess
[reference] = runReferenceValue(161.12,0.7708,2.65,26.56);

% Data parser for the different component of the geometry
load("data/box/aeroLoads_box.mat",'-mat');     
dataDUST.aeroLoads    = aeroLoads_box;      clear('aeroLoads_box');
load("data/box/analysisData_box.mat",'-mat');  
dataDUST.rawRunData   = analysisData_box;   clear('analysisData_box');
load("data/box/structLoads_box.mat",'-mat');   
dataDUST.structLoads  = structLoads_box;    clear('structLoads_box');

