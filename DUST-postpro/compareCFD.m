clearvars;  %close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% Data import

alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'validation/wing-m02';
variableName = 'aoa';
lerxPart = false;
avgLoadIdx = 80;

%%% DUST
[reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,lerxPart);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);
[dust.tail] = meanAeroLoadsCorrector(dust.tail,reference,avgLoadIdx);
[dust.fuselage] = meanAeroLoadsCorrector(dust.fuselage,reference,avgLoadIdx);

%%% CFD
[cfd] = outputCFD_lerx0_mach05();

%%% Debug DUST
load('lerxDesign0_STAD_yesTip_aeroLoads.mat');


%% Wing Plots

%%% Cl
cl_dust = dust.wing.aeroLoads.Cl + dust.tail.aeroLoads.Cl;
cl_cfd = cfd.wing.Cl + cfd.tail.Cl;

figure(Name='Cl vs aoa')
hold on;    grid minor;    axis padded;    box on;
%plot(alphaDegVec(2:3), dust.wing.aeroLoads.Cl(1:2),'-o');
plot(alphaDegVec, cl_dust,'-o');
plot(alphaDegVec, cl_cfd,'-o');
%plot(alphaDegVec, cfd.wing.Cl,'-o');
plot(aeroLoads.aoaDeg, aeroLoads.Cl,'-o');
legend('DUST','SU2','old Dust',location='northwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')


%%% Cd
cd_dust = dust.wing.aeroLoads.Cd + dust.tail.aeroLoads.Cd;
cd_cfd = cfd.wing.Cd + cfd.tail.Cd;

figure(Name='Cd vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, cd_dust,'-o');
plot(alphaDegVec, cd_cfd,'-o');
legend('DUST','SU2',location='northwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_d$$',interpreter='latex')


%%% Cm
cm_dust = dust.wing.aeroLoads.Cm + dust.tail.aeroLoads.Cm;
cm_cfd = cfd.wing.Cm + cfd.tail.Cm;

figure(Name='Cm vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, cm_dust,'-o');
plot(alphaDegVec, cm_cfd,'-o');
legend('DUST','SU2',location='southwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_m$$',interpreter='latex')