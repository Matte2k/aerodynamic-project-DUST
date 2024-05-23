% PENETRATION COMPARE

clearvars;  close all;  clc
addpath(genpath('./'));


%% Load data

off.aeroLoads   = load("data/off_aeroLoads.mat");
off.designData  = load("data/off_designData.mat");
off.structLoads = load("data/off_structLoads.mat");
off.timeCostVec = load("data/off_timeCost.mat");

on.aeroLoads   = load("data/on_aeroLoads.mat");
on.designData  = load("data/on_designData.mat");
on.structLoads = load("data/on_structLoads.mat");
on.timeCostVec = load("data/on_timeCost.mat");

%% Plot 

figure()
hold on;    grid on;    axis padded;
plot(off.designData.designData{1}.time, off.designData.designData{1}.Fx,'r');
plot(on.designData.designData{1}.time, on.designData.designData{1}.Fx,'b');
title('convergence Fx')
legend('penetration off','penetration on')

figure()
title('convergence Fz')
hold on;    grid on;    axis padded;
plot(off.designData.designData{1}.time, off.designData.designData{1}.Fz,'r');
plot(on.designData.designData{1}.time, on.designData.designData{1}.Fz,'b');
legend('penetration off','penetration on');

figure()
title('convergence My')
hold on;    grid on;    axis padded;
plot(off.designData.designData{1}.time, off.designData.designData{1}.My,'r');
plot(on.designData.designData{1}.time, on.designData.designData{1}.My,'b');
legend('penetration off','penetration on');