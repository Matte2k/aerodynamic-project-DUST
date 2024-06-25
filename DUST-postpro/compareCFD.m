clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% Data import

alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'validation';
variableName = 'aoa';
lerxPart = false;

%%% DUST
[reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,lerxPart);

%%% CFD
[cfd] = outputCFD_lerx0_mach05();

%%% Debug DUST
load('lerxDesign0_STAD_yesTip_aeroLoads.mat');


%% Wing Plots

cl_dust = dust.wing.aeroLoads.Cl(1:2) + dust.tail.aeroLoads.Cl(1:2);
cl_cfd = cfd.wing.Cl + cfd.tail.Cl;

figure(Name='Cl vs aoa')
hold on;    grid minor;    axis padded;    box on;

%plot(alphaDegVec(2:3), dust.wing.aeroLoads.Cl(1:2),'-o');

plot(alphaDegVec(2:3), cl_dust,'-o');
plot(alphaDegVec, cl_cfd,'-o');

%plot(alphaDegVec, cfd.wing.Cl,'-o');
plot(aeroLoads.aoaDeg, aeroLoads.Cl,'-o');
legend('DUST','SU2','old Dust',location='northwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')

% figure(Name='Cd vs aoa')
% hold on;    grid minor;    axis padded;    box on;
% plot(alphaDegVec(2:3), dust.wing.aeroLoads.Cd(1:2),'-o');
% plot(alphaDegVec, cfd.wing.Cd,'-o');
% legend('DUST','SU2',location='northwest')
% xlabel('$${\alpha}$$',interpreter='latex')
% ylabel('$$C_d$$',interpreter='latex')
% 
% figure(Name='Cm vs aoa')
% hold on;    grid minor;    axis padded;    box on;
% plot(alphaDegVec(2:3), dust.wing.aeroLoads.Cm(1:2),'-o');
% plot(alphaDegVec, cfd. wing.Cm,'-o');
% legend('DUST','SU2',location='southwest')
% xlabel('$${\alpha}$$',interpreter='latex')
% ylabel('$$C_m$$',interpreter='latex')