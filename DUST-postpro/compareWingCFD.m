close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;
% -------------------------------------------

%% Wing loads @MACH 02
clearvars;    

%%% Input data
alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'wing/mach-02';
avgLoadIdx = 80;
variableName = 'aoa';
components = struct;
    components.wing = true;
    components.tail = false;
    components.lerx = false;
    components.fuselage = false;


%%% DUST data import
[reference] = runReferenceValue(68, 1.225, 2.65, 26.56);
[dust.wing] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);


% %%% DUST data import with auto TE scaling off
% variableName = 'TEoff_aoa';
% [reference] = runReferenceValue(68, 1.225, 2.65, 26.56);
% [dust_off.wing] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
% [dust_off.wing] = meanAeroLoadsCorrector(dust_off.wing,reference,avgLoadIdx);


%%% CFD
[cfd] = outputCFD_wing_mach02();


%%% Aircraft loads plot
wingLoads = figure(Name='isolated wing loads mach 0.2000');
tiledlayout(1,3)

nexttile    % Cl
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cl,'-o');
    plot(alphaDegVec, cfd.wing.Cl,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_L$$',interpreter='latex')

nexttile    % Cd
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cd,'-o');
    plot(alphaDegVec, cfd.wing.Cd,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_D$$',interpreter='latex')

nexttile    % Cm
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cm,'-o');
    plot(alphaDegVec, cfd.wing.Cm,'-o');
    legend('DUST','SU2',location='southwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_M$$',interpreter='latex')

set(wingLoads,'units','centimeters','position',[0,0,30,9]);
exportgraphics(wingLoads,'figure\mach02_wingLoads.png','Resolution',1000);
% -------------------------------------------

%% Wing loads @MACH 03
clearvars;

%%% Input data
alphaDegVec  = [0 5 10 15]'; 
dataSubfolderName = 'wing/mach-03';
avgLoadIdx = 90;
variableName = 'aoa';
components = struct;
    components.wing = true;
    components.tail = false;
    components.lerx = false;
    components.fuselage = false;


%%% DUST data import
[reference] = runReferenceValue(96.672, 0.7708, 2.65, 26.56);
[dust.wing] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);


%%% CFD
[cfd] = outputCFD_wing_mach03();


%%% Aircraft loads plot
wingLoads = figure(Name='isolated wing loads mach 0.3000');
tiledlayout(1,3)

nexttile    % Cl
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cl,'-o');
    plot(alphaDegVec, cfd.wing.Cl,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_L$$',interpreter='latex')

nexttile    % Cd
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cd,'-o');
    plot(alphaDegVec, cfd.wing.Cd,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_D$$',interpreter='latex')

nexttile    % Cm
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cm,'-o');
    plot(alphaDegVec, cfd.wing.Cm,'-o');
    legend('DUST','SU2',location='southwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_M$$',interpreter='latex')

set(wingLoads,'units','centimeters','position',[0,0,30,9]);
exportgraphics(wingLoads,'figure\mach03_wingLoads.png','Resolution',1000);
% -------------------------------------------


%% Wing loads @MACH 05
clearvars;

%%% Input data
alphaDegVec  = [2 5 10]'; 
dataSubfolderName = 'wing/mach-05';
avgLoadIdx = 80;
variableName = 'aoa';
components = struct;
    components.wing = true;
    components.tail = false;
    components.lerx = false;
    components.fuselage = false;


%%% DUST data import
[reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
[dust.wing] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
[dust.wing] = meanAeroLoadsCorrector(dust.wing,reference,avgLoadIdx);


% %%% DUST data import with auto TE scaling off
% variableName = 'TEoff_aoa';
% [reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
% [dust_off.wing] = dataParser_DUST(alphaDegVec,dataSubfolderName,variableName,reference,components);
% [dust_off.wing] = meanAeroLoadsCorrector(dust_off.wing,reference,avgLoadIdx);


%%% CFD data import
[cfd] = outputCFD_wing_mach05();


%%% Aircraft loads plot
wingLoads = figure(Name='isolated wing loads mach 0.5000');
tiledlayout(1,3)

nexttile    % Cl
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cl,'-o');
    plot(alphaDegVec, cfd.wing.Cl,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_L$$',interpreter='latex')

nexttile    % Cd
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cd,'-o');
    plot(alphaDegVec, cfd.wing.Cd,'-o');
    legend('DUST','SU2',location='northwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_D$$',interpreter='latex')

nexttile    % Cm
    hold on;    grid minor;    axis padded;    box on;
    plot(alphaDegVec, dust.wing.aeroLoads.Cm,'-o');
    plot(alphaDegVec, cfd.wing.Cm,'-o');
    legend('DUST','SU2',location='southwest')
    xlabel('$${\alpha}$$',interpreter='latex')
    ylabel('$$C_M$$',interpreter='latex')

set(wingLoads,'units','centimeters','position',[0,0,30,9]);
exportgraphics(wingLoads,'figure\mach05_wingLoads.png','Resolution',1000);

