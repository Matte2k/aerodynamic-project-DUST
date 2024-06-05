clear
close all
clc

global init_flag;
init_flag = 0;

%% File loading

load 'Lambda_PolarM05_35'
load 'Lambda_PolarM05_40'
load 'Lambda_PolarM05_45'
load 'Lambda_PolarM05_50'

load 'Trap_PolarM05_35.mat'
load 'Trap_PolarM05_40.mat'

load 'Lambda_PolarM085.mat'
load 'Trap_PolarM085.mat'
load Lambda_PolarM05_40_supercritical

%% Lambda 35° Mach = 0.5

Lambda_PolarM05_35_CD0_correct = 0.01440;
Lambda_PolarM05_35_geom = [16.3, 10.71, 2.81];
Lambda_PolarM05_35_opcond = [2.33e7, 0.5, 0.7708];
Lambda_PolarM05_35_name = "Lambda 35° M = 0.5";
Polar_Plotter(Lambda_PolarM05_35, Lambda_PolarM05_35_CD0_correct, Lambda_PolarM05_35_geom, Lambda_PolarM05_35_opcond, Lambda_PolarM05_35_name)

%% Lambda 40° Mach = 0.5

Lambda_PolarM05_40.CL = Lambda_PolarM05_40.CL * 16.3/26
Lambda_PolarM05_40_CD0_correct = 0.01410;
Lambda_PolarM05_40_geom = [16.3, 10.56, 2.65];
Lambda_PolarM05_40_opcond = [2.45e7, 0.5, 0.7708];
Lambda_PolarM05_40_name = "Lambda 40° M = 0.5";
Polar_Plotter(Lambda_PolarM05_40, Lambda_PolarM05_40_CD0_correct, Lambda_PolarM05_40_geom, Lambda_PolarM05_40_opcond, Lambda_PolarM05_40_name)

%% Lambda 45° Mach = 0.5

Lambda_PolarM05_45_CD0_correct = 0.01407;
Lambda_PolarM05_45_geom = [16.3, 10.03, 2.76];
Lambda_PolarM05_45_opcond = [2.6e7, 0.5, 0.7708];
Lambda_PolarM05_45_name = "Lambda 45° M = 0.5";
Polar_Plotter(Lambda_PolarM05_45, Lambda_PolarM05_45_CD0_correct, Lambda_PolarM05_45_geom, Lambda_PolarM05_45_opcond, Lambda_PolarM05_45_name)

%% Lambda 50° Mach = 0.5

Lambda_PolarM05_50_CD0_correct = 0.01412;
Lambda_PolarM05_50_geom = [16.3, 10.40, 2.949];
Lambda_PolarM05_50_opcond = [2.81e7, 0.5, 0.7708];
Lambda_PolarM05_50_name = "Lambda 50° M = 0.5";
Polar_Plotter(Lambda_PolarM05_50, Lambda_PolarM05_50_CD0_correct, Lambda_PolarM05_50_geom, Lambda_PolarM05_50_opcond, Lambda_PolarM05_50_name)

%% Trapezoidal 35° Mach = 0.5

Trap_PolarM05_35_CD0_correct = 0.01531  ;
Trap_PolarM05_35_geom = [16.3, 9.60, 3.051];
Trap_PolarM05_35_opcond = [2.64e7, 0.5, 0.7708];
Trap_PolarM05_35_name = "Trap 35° M = 0.5";
Polar_Plotter(Trap_PolarM05_35, Trap_PolarM05_35_CD0_correct, Trap_PolarM05_35_geom, Trap_PolarM05_35_opcond, Trap_PolarM05_35_name)

%% Trapezoidal 40° Mach = 0.5

Trap_PolarM05_40_CD0_correct = 0.01530;
Trap_PolarM05_40_geom = [16.3, 9.50, 3.184];
Trap_PolarM05_40_opcond = [2.77e7, 0.5, 0.7708];
Trap_PolarM05_40_name = "Trap 40° M = 0.5";
Polar_Plotter(Trap_PolarM05_40, Trap_PolarM05_40_CD0_correct, Trap_PolarM05_40_geom, Trap_PolarM05_40_opcond, Trap_PolarM05_40_name)

%% Lambda 40°, Mach = 0.5, isolated wing 

load 'Lambda_Isolated_M05_40'

Lambda_Isolated_M05_40_CD0_correct = 0.01410;
Lambda_Isolated_M05_40_geom = [16.3, 10.56, 2.65];
Lambda_Isolated_M05_40_opcond = [2.45e7, 0.5, 0.7708];
Lambda_Isolated_M05_40_name = "Lambda 40° M = 0.5";
Polar_Plotter(Lambda_Isolated_M05_40, Lambda_Isolated_M05_40_CD0_correct, Lambda_Isolated_M05_40_geom, Lambda_Isolated_M05_40_opcond, Lambda_Isolated_M05_40_name)

mean(Lambda_Isolated_M05_40.CMy(1 : 6));