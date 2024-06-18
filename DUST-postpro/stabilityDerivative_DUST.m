clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;

%% OpenVSP data

load("data/stability/openVSP/Lambda_PolarM050_tailed",'-mat');
openVSP.polar = Lambda_PolarM050_tailed;    clear('Lambda_PolarM050_tailed');
openVSP.stabilty = readtable("data/stability/openVSP/stabilityDerivative_OpenVSP.dat");


%% DUST data

% Reference value of the run to postprocess
Sref = 26.56;           
Cref = 2.65;
rhoInf = 0.7708;
absVelocity = 161.12;
[reference] = runReferenceValue(absVelocity,rhoInf,Cref,Sref);

% Data parser for the different component of the geometry
alphaDegVec = [4 5]';
analysisName = 'stability';
variableName = 'aoa';
lerxPart = false;
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,analysisName,variableName,reference,lerxPart);


%% Polar plots
dust.polar.Cl = dust.wing.aeroLoads.Cl + dust.tail.aeroLoads.Cl;
dust.polar.Cd = dust.wing.aeroLoads.Cd + dust.tail.aeroLoads.Cd;
dust.polar.Cm = dust.wing.aeroLoads.Cm + dust.tail.aeroLoads.Cm;
dust.polar.aoaDeg = dust.wing.aeroLoads.aoaDeg;

figure(Name='Cl vs aoa')
hold on;    grid on;    axis padded;
plot(dust.polar.aoaDeg,dust.polar.Cl,'-o');
plot(openVSP.polar.AoA,openVSP.polar.CL,'-o');
legend('DUST','OpenVSP')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')

figure(Name='Cd vs aoa')
hold on;    grid on;    axis padded;
plot(dust.polar.aoaDeg,dust.polar.Cd,'-o');
plot(openVSP.polar.AoA,openVSP.polar.CDtot,'-o');
legend('DUST','OpenVSP')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_d$$',interpreter='latex')

figure(Name='Cm vs aoa')
hold on;    grid on;    axis padded;
plot(dust.polar.aoaDeg,dust.polar.Cm,'-o');
plot(openVSP.polar.AoA,openVSP.polar.CMy,'-o');
legend('DUST','OpenVSP')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_m$$',interpreter='latex')


%% Stability derivative 
% old... don't work anymore since the data are organized different in the
% struct

% forward diff
endstab = (length(dust.polar.aoaDeg)-1);
dust.ClalphaFD = zeros(endstab,1);
dust.stability.CmalphaFD = zeros(endstab,1);
dust.stability.aoaDeg = dust.polar.aoaDeg(1:endstab);

for i=1:endstab
    dust.stability.ClalphaFD(i) =   (dust.polar.Cl(i+1) - dust.polar.Cl(i)) / ...
                                    (deg2rad(dust.polar.aoaDeg(i+1)) - deg2rad(dust.polar.aoaDeg(i)));

    dust.stability.CmalphaFD(i) =    (dust.polar.Cm(i+1) - dust.polar.Cm(i)) / ...
                                     (deg2rad(dust.polar.aoaDeg(i+1)) - deg2rad(dust.polar.aoaDeg(i)));
end


figure(Name='Cl alpha forward diff')
hold on;    grid on;    axis padded;
plot(dust.stability.aoaDeg,dust.stability.ClalphaFD,'-o')
plot(openVSP.stabilty.x_Aoa,openVSP.stabilty.cl_alpha,'-o')
legend('DUST','OpenVSP')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_l$$',interpreter='latex')


figure(Name='Cm alpha forward diff')
hold on;    grid on;    axis padded;
plot(dust.stability.aoaDeg,dust.stability.ClalphaFD,'-o')
plot(openVSP.stabilty.x_Aoa,openVSP.stabilty.cm_alpha,'-o')
legend('DUST','OpenVSP')
xlabel('$${\alpha}$$',interpreter='latex')
ylabel('$$C_m$$',interpreter='latex')

