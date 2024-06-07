clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;

% Data import
load("data/wing1_lerx1_vortex0_aeroLoads",'-mat','aeroLoads');
case1 = aeroLoads;  clear('aeroLoads');

%% Polar plots

figure(Name='Cl vs aoa')
hold on;    grid on;    axis padded;
plot(case1.aoaDeg,case1.Cl);
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')

figure(Name='Cd vs aoa')
hold on;    grid on;    axis padded;
plot(case1.aoaDeg,case1.Cd);
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')

figure(Name='Cm vs aoa')
hold on;    grid on;    axis padded;
plot(case1.aoaDeg,case1.Cm);
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')


%% Stability derivative

Clalpha =   (case1.Cl(3)     - case1.Cl(2)) / ...
            (case1.aoaDeg(3) - case1.aoaDeg(2));
fprintf('Cl_alpha = %f',Clalpha);

Cmalpha =   (case1.Cm(3)     - case1.Cm(2)) / ...
            (case1.aoaDeg(3) - case1.aoaDeg(2));
fprintf('Cm_alpha = %f',Cmalpha);
