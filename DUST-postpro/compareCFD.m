clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% Data import

alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'lerx';
variableName = 'lerx0_aoa';
lerxPart = false;

%%% DUST
[reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,lerxPart);

%%% CFD
[cfd] = outputCFD_lerx0_mach05();


%% Wing Plots

figure(Name='Cl vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, dust.wing.Cl,'-o');
plot(alphaDegVec, cfd. wing.Cl,'-o');
legend('DUST','SU2',location='northwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')

figure(Name='Cd vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, dust.wing.Cd,'-o');
plot(alphaDegVec, cfd. wing.Cd,'-o');
legend('DUST','SU2',location='northwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_d$$',interpreter='latex')

figure(Name='Cm vs aoa')
hold on;    grid minor;    axis padded;    box on;
plot(alphaDegVec, dust.wing.Cm,'-o');
plot(alphaDegVec, cfd. wing.Cm,'-o');
legend('DUST','SU2',location='southwest')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_m$$',interpreter='latex')