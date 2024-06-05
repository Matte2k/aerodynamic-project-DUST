clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;

fullPlane = load("data/wing1_lerx1_vortex0_aeroLoads",'-mat','aeroLoads');

Clalpha =   (fullPlane.aeroLoads.Cl(3)     - fullPlane.aeroLoads.Cl(2)) / ...
            (fullPlane.aeroLoads.aoaDeg(3) - fullPlane.aeroLoads.aoaDeg(2));

Cmalpha =   (fullPlane.aeroLoads.My(3)     - fullPlane.aeroLoads.My(2)) / ...
            (fullPlane.aeroLoads.aoaDeg(3) - fullPlane.aeroLoads.aoaDeg(2));
