clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% Data import - MACH 02

alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'wing/mach-02';
lerxPart = false;
avgLoadIdx = 80;

components = struct;
    components.wing = true;
    components.tail = false;
    components.lerx = false;
    components.fuselage = false;

%%% DUST mach 0.2
variableName = 'TEoff_aoa';
[reference] = runReferenceValue(68, 1.225, 2.65, 26.56);
[dust_off.wing] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust_off.wing] = meanAeroLoadsCorrector(dust_off.wing,reference,avgLoadIdx);

%%% DUST mach 0.2
variableName = 'TEon_aoa';
[reference] = runReferenceValue(68, 1.225, 2.65, 26.56);
[dust.wing] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);

%%% CFD
[cfd] = outputCFD_wing_mach02();


%% Wing Plots

%%% Cl
figure(Name='Cl vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, dust.wing.aeroLoads.Cl,'-o');
plot(alphaDegVec, dust_off.wing.aeroLoads.Cl,'-o');
plot(alphaDegVec, cfd.wing.Cl,'-o');
legend('DUST auto TE','DUST manual TE','SU2',location='northwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')


%%% Cd
figure(Name='Cd vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, dust.wing.aeroLoads.Cd,'-o');
plot(alphaDegVec, cfd.wing.Cd,'-o');
legend('DUST','SU2',location='northwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_d$$',interpreter='latex')


%%% Cm
figure(Name='Cm vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, dust.wing.aeroLoads.Cm,'-o');
plot(alphaDegVec, cfd.wing.Cm,'-o');
legend('DUST','SU2',location='southwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_m$$',interpreter='latex')