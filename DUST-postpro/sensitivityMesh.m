clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;

%% DUST data

% Reference value of the run to postprocess
[reference] = runReferenceValue(161.12,0.7708,2.65,26.56);

% Data parser for the different component of the geometry
load("data/mesh/aeroLoads_mesh.mat",'-mat');     
dataDUST.aeroLoads    = aeroLoads_mesh;      clear('aeroLoads_mesh');
load("data/mesh/analysisData_mesh.mat",'-mat');  
dataDUST.rawRunData   = analysisData_mesh;   clear('analysisData_mesh');
load("data/mesh/structLoads_mesh.mat",'-mat');   
dataDUST.structLoads  = structLoads_mesh;    clear('structLoads_mesh');
