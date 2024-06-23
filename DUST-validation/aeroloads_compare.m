clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"))
currentPath = pwd;
[~] = initGraphic;

%% Data import

% CFD loads data
CFD.mach03 = outputCFD_mach03;
CFD.mach08 = outputCFD_mach08;

% DUST loads data
DUST.mach03 = outputDUST_mach03;
DUST.mach08 = outputDUST_mach08;

% AVL loads data
AVL.mach03 = outputAVL_mach03;
AVL.mach08 = outputAVL_mach08;

% XFLR5 loads data
XFLR5.mach03 = outputXFLR5_mach03;
XFLR5.mach08 = outputXFLR5_mach08;


%% Polars plot - mach 0.3000
m3 = figure(Name='aero loads mach 0.3000');
tiledlayout(1,3)

nexttile
    % figure("Name",'lift vs alpha')
    % title('wing L vs $\alpha$ at $$Ma=0.3000$$')
    hold on;    grid minor;    axis padded;    box on;
    plot(CFD.mach03.flow.aoaDeg ,   CFD.mach03.aero.Cl,  '-o');
    plot(DUST.mach03.flow.aoaDeg ,  DUST.mach03.aero.Cl, '-o');
    plot(AVL.mach03.flow.aoaDeg ,   AVL.mach03.aero.Cl,  '-o');
    plot(XFLR5.mach03.flow.aoaDeg , XFLR5.mach03.aero.Cl,'-o');
    legend('CFD','DUST','AVL','XFLR5',location='southeast')
    xlabel('$\alpha$ [deg]');      ylabel('$C_l$');

nexttile
    % figure("Name",'drag vs alpha')
    % title('wing D vs $\alpha$ at $$Ma=0.3000$$')
    hold on;    grid minor;    axis padded;    box on;
    plot(CFD.mach03.flow.aoaDeg ,   CFD.mach03.aero.Cd,  '-o');
    plot(DUST.mach03.flow.aoaDeg ,  DUST.mach03.aero.Cd, '-o');
    plot(AVL.mach03.flow.aoaDeg ,   AVL.mach03.aero.Cd,  '-o');
    plot(XFLR5.mach03.flow.aoaDeg , XFLR5.mach03.aero.Cd,'-o');
    legend('CFD','DUST','AVL','XFLR5',location='northwest')
    xlabel('$\alpha$ [deg]');      ylabel('$C_d$');

nexttile
    % figure("Name",'moment vs alpha')
    % title('pitching moment vs $\alpha$ at $$Ma=0.3000$$')
    hold on;    grid minor;    axis padded;    box on;
    plot(CFD.mach03.flow.aoaDeg ,   CFD.mach03.aero.Cm,  '-o');
    plot(DUST.mach03.flow.aoaDeg ,  DUST.mach03.aero.Cm, '-o');
    plot(AVL.mach03.flow.aoaDeg ,   AVL.mach03.aero.Cm,  '-o');
    plot(XFLR5.mach03.flow.aoaDeg , XFLR5.mach03.aero.Cm,'-o');
    legend('CFD','DUST','AVL','XFLR5',location='southwest')
    xlabel('$\alpha$');      ylabel('$C_m$');
    
set(m3,'units','centimeters','position',[0,0,30,9]);                 % TO BE SET
exportgraphics(m3,'figure\mach03_aeroloads.png','Resolution',1000);

% figure("Name",'lift vs drag')
% title('wing polar at $$Ma=0.3000$$')
% hold on;    grid minor;    axis padded;
% plot(CFD.mach03.aero.Cd ,   CFD.mach03.aero.Cl,  '-o');
% plot(DUST.mach03.aero.Cd ,  DUST.mach03.aero.Cl, '-o');
% plot(AVL.mach03.aero.Cd ,   AVL.mach03.aero.Cl,  '-o');
% plot(XFLR5.mach03.aero.Cd , XFLR5.mach03.aero.Cl,'-o');
% legend('CFD','DUST','AVL','XFLR5',location='southeast')
% xlabel('$C_D$');      ylabel('$C_L$');


%% Polars plot - mach 0.8395
m8 = figure(Name='aero loads mach 0.8395');
tiledlayout(1,3)

nexttile
    % figure("Name",'lift vs alpha')
    % title('wing L vs $\alpha$ at $$Ma=0.8395$$')
    hold on;    grid minor;    axis padded;    box on;
    plot(CFD.mach08.flow.aoaDeg ,   CFD.mach08.aero.Cl,  '-o');
    plot(DUST.mach08.flow.aoaDeg ,  DUST.mach08.aero.Cl, '-o');
    plot(AVL.mach08.flow.aoaDeg ,   AVL.mach08.aero.Cl,  '-o');
    plot(XFLR5.mach08.flow.aoaDeg , XFLR5.mach08.aero.Cl,'-o');
    legend('CFD','DUST','AVL','XFLR5',location='southeast')
    xlabel('$\alpha$');      ylabel('$C_L$');

nexttile
    % figure("Name",'drag vs alpha')
    % title('wing D vs $\alpha$ at $$Ma=0.8395$$')
    hold on;    grid minor;    axis padded;    box on;
    plot(CFD.mach08.flow.aoaDeg ,   CFD.mach08.aero.Cd,  '-o');
    plot(DUST.mach08.flow.aoaDeg ,  DUST.mach08.aero.Cd, '-o');
    plot(AVL.mach08.flow.aoaDeg ,   AVL.mach08.aero.Cd,  '-o');
    plot(XFLR5.mach08.flow.aoaDeg , XFLR5.mach08.aero.Cd,'-o');
    legend('CFD','DUST','AVL','XFLR5',location='northwest')
    xlabel('$\alpha$');      ylabel('$C_D$');

nexttile
    % figure("Name",'moment vs alpha')
    % title('pitching moment vs $\alpha$ at $$Ma=0.8395$$')
    hold on;    grid minor;    axis padded;    box on;
    plot(CFD.mach08.flow.aoaDeg ,   CFD.mach08.aero.Cm,  '-o');
    plot(DUST.mach08.flow.aoaDeg ,  DUST.mach08.aero.Cm, '-o');
    plot(AVL.mach08.flow.aoaDeg ,   AVL.mach08.aero.Cm,  '-o');
    plot(XFLR5.mach08.flow.aoaDeg , XFLR5.mach08.aero.Cm,'-o');
    legend('CFD','DUST','AVL','XFLR5',location='southwest')
    xlabel('$\alpha$');      ylabel('$C_M$');
    
set(m8,'units','centimeters','position',[0,0,30,9]);                 % TO BE SET
exportgraphics(m8,'figure\mach08_aeroloads.png','Resolution',1000);

% figure("Name",'lift vs drag')
% title('wing polar at $$Ma=0.8395$$')
% nexttile
% hold on;    grid minor;    axis padded;
% plot(CFD.mach08.aero.Cd ,   CFD.mach08.aero.Cl,  '-o');
% plot(DUST.mach08.aero.Cd ,  DUST.mach08.aero.Cl, '-o');
% plot(AVL.mach08.aero.Cd ,   AVL.mach08.aero.Cl,  '-o');
% plot(XFLR5.mach08.aero.Cd , XFLR5.mach08.aero.Cl,'-o');
% legend('CFD','DUST','AVL','XFLR5',location='southeast')
% xlabel('$C_D$');      ylabel('$C_L$');


%%  STRUCTURAL LOAD SUBSONIC X and Z

% figure("Name",'x-force vs alpha')
% title('wing Fx vs $\alpha$ at $$Ma=0.3000$$')
% hold on;    grid minor;    axis padded;
% plot(CFD.mach03.flow.aoaDeg ,   CFD.mach03.struct.Cfx,  '-o');
% plot(DUST.mach03.flow.aoaDeg ,  DUST.mach03.struct.Cfx, '-o');
% plot(AVL.mach03.flow.aoaDeg ,   AVL.mach03.struct.Cfx,  '-o');
% legend('CFD','DUST','AVL',location='southwest')
% xlabel('$\alpha$');      ylabel('$C_X$');
% 
% figure("Name",'z-force vs alpha')
% title('wing Fz vs $\alpha$ at $$Ma=0.3000$$')
% hold on;    grid minor;    axis padded;
% plot(CFD.mach03.flow.aoaDeg ,   CFD.mach03.struct.Cfz,  '-o');
% plot(DUST.mach03.flow.aoaDeg ,  DUST.mach03.struct.Cfz, '-o');
% plot(AVL.mach03.flow.aoaDeg ,   AVL.mach03.struct.Cfz,  '-o');
% legend('CFD','DUST','AVL',location='southwest')
% xlabel('$\alpha$');      ylabel('$C_Z$');
