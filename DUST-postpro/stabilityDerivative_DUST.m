clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;


load("data/dust/stabilitySTAD_aeroLoads",'-mat','aeroLoads');
dust.polar = aeroLoads;                           clear('aeroLoads');

load("data/openVSP/Lambda_PolarM050_tailed",'-mat');
openVSP.polar = Lambda_PolarM050_tailed;    clear('Lambda_PolarM050_tailed');
openVSP.stabilty = readtable("data/openVSP/stabilityDerivative_OpenVSP.dat");

%% Polar plots

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

% forward diff
endstab = (length(dust.polar.aoaDeg)-1);
dust.stability.ClalphaFD = zeros(endstab,1);
dust.stability.CmalphaFD = zeros(endstab,1);
dust.stability.aoaDeg = dust.polar.aoaDeg(1:endstab);

for i=1:endstab
    dust.stability.ClalphaFD(i) =   (dust.polar.Cl(i+1)     - dust.polar.Cl(i)) / ...
                                    (deg2rad(dust.polar.aoaDeg(i+1)) - deg2rad(dust.polar.aoaDeg(i)));

    dust.stability.CmalphaFD(i) =    (dust.polar.Cm(i+1)     - dust.polar.Cm(i)) / ...
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

