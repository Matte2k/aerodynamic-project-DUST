clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"))
currentPath = pwd;
[~] = initGraphic;

% CFD loads data
CFD.mach03 = outputCFD_mach03;
CFD.mach08 = outputCFD_mach08;

% DUST loads data
DUST.mach03 = outputDUST_mach03;
DUST.mach08 = outputDUST_mach08;


