close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;
% -------------------------------------------

%% Aircraft loads @MACH 02
clearvars;

%%% Input data
alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'aircraft/mach-02';
variableName = 'aoa';
avgLoadIdx = 80;
components = struct;
    components.wing = true;
    components.tail = true;
    components.lerx = false;
    components.fuselage = true;


%%% DUST data import
[reference] = runReferenceValue(68, 1.225, 2.65, 26.56);
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);
[dust.tail] = meanAeroLoadsCorrector(dust.tail,reference,avgLoadIdx);
[dust.fuselage] = meanAeroLoadsCorrector(dust.fuselage,reference,avgLoadIdx);


%%% CFD data import
[cfd] = outputCFD_lerx0_mach02();


%%% Aerodynamic surface loads computation
dust.aero.Cl = dust.wing.aeroLoads.Cl + dust.tail.aeroLoads.Cl;
dust.aero.Cm = dust.wing.aeroLoads.Cm + dust.tail.aeroLoads.Cm;
dust.aero.Cd = dust.wing.aeroLoads.Cd + dust.tail.aeroLoads.Cd;
cfd.aero.Cl  = cfd.wing.Cl + cfd.tail.Cl;
cfd.aero.Cd  = cfd.wing.Cd + cfd.tail.Cd;
cfd.aero.Cm  = cfd.wing.Cm + cfd.tail.Cm;


%%% Aerodynamic surface loads plot
aircraftLoads = figure(Name='aircraft loads mach 0.2000');
tiledlayout(1,3)

nexttile    % Cl
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cl,'-o');
    plot(alphaDegVec, cfd.aero.Cl,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_L$$',interpreter='latex')

nexttile    % Cd
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cd,'-o');
    plot(alphaDegVec, cfd.aero.Cd,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_D$$',interpreter='latex')

nexttile    % Cm
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cm,'-o');
    plot(alphaDegVec, cfd.aero.Cm,'-o');
    legend('DUST','SU2',location='southwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_M$$',interpreter='latex')

set(aircraftLoads,'units','centimeters','position',[0,0,30,9]);
exportgraphics(aircraftLoads,'figure\mach02_aircraftLoads.png','Resolution',1000);
% -------------------------------------------


%% Aircraft loads @MACH 03
clearvars;

%%% Input data
alphaDegVec  = [0 5 10 15]'; 
dataSubfolderName = 'aircraft/mach-03';
variableName = 'aoa';
avgLoadIdx = 90;
components = struct;
    components.wing = true;
    components.tail = true;
    components.lerx = false;
    components.fuselage = true;


%%% DUST data import
[reference] = runReferenceValue(96.672, 0.7708, 2.65, 26.56);
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);
[dust.tail] = meanAeroLoadsCorrector(dust.tail,reference,avgLoadIdx);
[dust.fuselage] = meanAeroLoadsCorrector(dust.fuselage,reference,avgLoadIdx);


%%% CFD data import
[cfd] = outputCFD_lerx0_mach03();


%%% Aerodynamic surface loads computation
dust.aero.Cl = dust.wing.aeroLoads.Cl + dust.tail.aeroLoads.Cl;
dust.aero.Cm = dust.wing.aeroLoads.Cm + dust.tail.aeroLoads.Cm;
dust.aero.Cd = dust.wing.aeroLoads.Cd + dust.tail.aeroLoads.Cd;
cfd.aero.Cl  = cfd.wing.Cl + cfd.tail.Cl;
cfd.aero.Cd  = cfd.wing.Cd + cfd.tail.Cd;
cfd.aero.Cm  = cfd.wing.Cm + cfd.tail.Cm;


%%% Aerodynamic surface loads plot
aircraftLoads = figure(Name='aircraft loads mach 0.3000');
tiledlayout(1,3)

nexttile    % Cl
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cl,'-o');
    plot(alphaDegVec, cfd.aero.Cl,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_L$$',interpreter='latex')

nexttile    % Cd
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cd,'-o');
    plot(alphaDegVec, cfd.aero.Cd,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_D$$',interpreter='latex')

nexttile    % Cm
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cm,'-o');
    plot(alphaDegVec, cfd.aero.Cm,'-o');
    legend('DUST','SU2',location='southwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_M$$',interpreter='latex')

set(aircraftLoads,'units','centimeters','position',[0,0,30,9]);
exportgraphics(aircraftLoads,'figure\mach03_aircraftLoads.png','Resolution',1000);
% -------------------------------------------


%% Aircraft loads @MACH 05
clearvars;

%%% Input data
alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'aircraft/mach-05';
variableName = 'aoa';
avgLoadIdx = 80;
components = struct;
    components.wing = true;
    components.tail = true;
    components.lerx = false;
    components.fuselage = true;


%%% DUST data import
[reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
[dust.wing,dust.tail,dust.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);
[dust.tail] = meanAeroLoadsCorrector(dust.tail,reference,avgLoadIdx);
[dust.fuselage] = meanAeroLoadsCorrector(dust.fuselage,reference,avgLoadIdx);


%%% CFD data import
[cfd] = outputCFD_lerx0_mach05();


%%% Aerodynamic surface loads computation
dust.aero.Cl = dust.wing.aeroLoads.Cl + dust.tail.aeroLoads.Cl;
dust.aero.Cm = dust.wing.aeroLoads.Cm + dust.tail.aeroLoads.Cm;
dust.aero.Cd = dust.wing.aeroLoads.Cd + dust.tail.aeroLoads.Cd;
cfd.aero.Cl  = cfd.wing.Cl + cfd.tail.Cl;
cfd.aero.Cd  = cfd.wing.Cd + cfd.tail.Cd;
cfd.aero.Cm  = cfd.wing.Cm + cfd.tail.Cm;


%%% Wing loads plots
aircraftLoads = figure(Name='aircraft loads mach 0.5000');
tiledlayout(1,3)

nexttile    % Cl
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cl,'-o');
    plot(alphaDegVec, cfd.aero.Cl,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_L$$',interpreter='latex')

nexttile    % Cd
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cd,'-o');
    plot(alphaDegVec, cfd.aero.Cd,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_D$$',interpreter='latex')

nexttile    % Cm
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.aero.Cm,'-o');
    plot(alphaDegVec, cfd.aero.Cm,'-o');
    legend('DUST','SU2',location='southwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_M$$',interpreter='latex')

set(aircraftLoads,'units','centimeters','position',[0,0,30,9]);
exportgraphics(aircraftLoads,'figure\mach05_aircraftLoads.png','Resolution',1000);
