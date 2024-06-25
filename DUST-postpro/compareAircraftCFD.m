clearvars;  %close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% Data import - MACH 05

alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'aircraft/mach-05';
% dataSubfolderName = 'aircraft/mach-02';
variableName = 'aoa';
avgLoadIdx = 80;

components = struct;
    components.wing = true;
    components.tail = true;
    components.lerx = false;
    components.fuselage = true;

%%% DUST
[reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);
[dust.tail] = meanAeroLoadsCorrector(dust.tail,reference,avgLoadIdx);
[dust.fuselage] = meanAeroLoadsCorrector(dust.fuselage,reference,avgLoadIdx);
% [reference] = runReferenceValue(68, 1.225, 2.65, 26.56);
% [dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
% [dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);
% [dust.tail] = meanAeroLoadsCorrector(dust.tail,reference,avgLoadIdx);
% [dust.fuselage] = meanAeroLoadsCorrector(dust.fuselage,reference,avgLoadIdx);

%%% CFD
[cfd] = outputCFD_lerx0_mach05();
% [cfd] = outputCFD_lerx0_mach02();


%% Wing Plots

%%% Cl
cl_dust = dust.wing.aeroLoads.Cl + dust.tail.aeroLoads.Cl;
cl_cfd = cfd.wing.Cl + cfd.tail.Cl;

figure(Name='Cl vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, cl_dust,'-o');
plot(alphaDegVec, cl_cfd,'-o');
legend('DUST','SU2',location='northwest')
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
