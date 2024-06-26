clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% Data import

alphaDegVec  = [5 10 15]'; 
dataSubfolderName = 'lerx';
lerxPart = true;
[reference] = runReferenceValue(161.204, 0.770153, 2.65, 26.56);
avgLoadIdx = 80;

% color map definition
cmap = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250; 0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840];
cmap = cmap(1:length(alphaDegVec),:);
    cbTicksCount = 1:length(alphaDegVec);
    cbTicksPos = [0.5, cbTicksCount, (cbTicksCount(end)+0.5)];

% configuration without lerx
[lerx0.wing,lerx0.tail,lerx0.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx0_aoa',reference);
[lerx0.wing] = meanAeroLoadsCorrector(lerx0.wing,reference,avgLoadIdx);
[lerx0.tail] = meanAeroLoadsCorrector(lerx0.tail,reference,avgLoadIdx);
[lerx0.fuselage] = meanAeroLoadsCorrector(lerx0.fuselage,reference,avgLoadIdx);

% Lerx 1
[lerx1.wing,lerx1.tail,lerx1.fuselage,lerx1.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx1_aoa',reference,lerxPart);
[lerx1.wing] = meanAeroLoadsCorrector(lerx1.wing,reference,avgLoadIdx);
[lerx1.tail] = meanAeroLoadsCorrector(lerx1.tail,reference,avgLoadIdx);
[lerx1.lerx] = meanAeroLoadsCorrector(lerx1.lerx,reference,avgLoadIdx);
[lerx1.fuselage] = meanAeroLoadsCorrector(lerx1.fuselage,reference,avgLoadIdx);

% Lerx 2
[lerx2.wing,lerx2.tail,lerx2.fuselage,lerx2.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx2_aoa',reference,lerxPart);
[lerx2.wing] = meanAeroLoadsCorrector(lerx2.wing,reference,avgLoadIdx);
[lerx2.tail] = meanAeroLoadsCorrector(lerx2.tail,reference,avgLoadIdx);
[lerx2.lerx] = meanAeroLoadsCorrector(lerx2.lerx,reference,avgLoadIdx);
[lerx2.fuselage] = meanAeroLoadsCorrector(lerx2.fuselage,reference,avgLoadIdx);

% Lerx 3
[lerx3.wing,lerx3.tail,lerx3.fuselage,lerx3.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx3_aoa',reference,lerxPart);
[lerx3.wing] = meanAeroLoadsCorrector(lerx3.wing,reference,avgLoadIdx);
[lerx3.tail] = meanAeroLoadsCorrector(lerx3.tail,reference,avgLoadIdx);
[lerx3.lerx] = meanAeroLoadsCorrector(lerx3.lerx,reference,avgLoadIdx);
[lerx3.fuselage] = meanAeroLoadsCorrector(lerx3.fuselage,reference,avgLoadIdx);

% Lerx 4
[lerx4.wing,lerx4.tail,lerx4.fuselage,lerx4.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx4_aoa',reference,lerxPart);
[lerx4.wing] = meanAeroLoadsCorrector(lerx4.wing,reference,avgLoadIdx);
[lerx4.tail] = meanAeroLoadsCorrector(lerx4.tail,reference,avgLoadIdx);
[lerx4.lerx] = meanAeroLoadsCorrector(lerx4.lerx,reference,avgLoadIdx);
[lerx4.fuselage] = meanAeroLoadsCorrector(lerx4.fuselage,reference,avgLoadIdx);

% Lerx 5
[lerx5.wing,lerx5.tail,lerx5.fuselage,lerx5.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx5_aoa',reference,lerxPart);
[lerx5.wing] = meanAeroLoadsCorrector(lerx5.wing,reference,avgLoadIdx);
[lerx5.tail] = meanAeroLoadsCorrector(lerx5.tail,reference,avgLoadIdx);
[lerx5.lerx] = meanAeroLoadsCorrector(lerx5.lerx,reference,avgLoadIdx);
[lerx5.fuselage] = meanAeroLoadsCorrector(lerx5.fuselage,reference,avgLoadIdx);


%% Data post-process

%%% Cl computation
lerx0_lift = lerx0.wing.aeroLoads.Cl + lerx0.tail.aeroLoads.Cl;
lerx1_lift = lerx1.wing.aeroLoads.Cl + lerx1.tail.aeroLoads.Cl + lerx1.lerx.aeroLoads.Cl;
lerx2_lift = lerx2.wing.aeroLoads.Cl + lerx2.tail.aeroLoads.Cl + lerx2.lerx.aeroLoads.Cl;
lerx3_lift = lerx3.wing.aeroLoads.Cl + lerx3.tail.aeroLoads.Cl + lerx3.lerx.aeroLoads.Cl;
lerx4_lift = lerx4.wing.aeroLoads.Cl + lerx4.tail.aeroLoads.Cl + lerx4.lerx.aeroLoads.Cl;
lerx5_lift = lerx5.wing.aeroLoads.Cl + lerx5.tail.aeroLoads.Cl + lerx5.lerx.aeroLoads.Cl;

%%% Cm computation
lerx0_momentum = lerx0.wing.aeroLoads.Cm + lerx0.tail.aeroLoads.Cm;
lerx1_momentum = lerx1.wing.aeroLoads.Cm + lerx1.tail.aeroLoads.Cm + lerx1.lerx.aeroLoads.Cm;
lerx2_momentum = lerx2.wing.aeroLoads.Cm + lerx2.tail.aeroLoads.Cm + lerx2.lerx.aeroLoads.Cm;
lerx3_momentum = lerx3.wing.aeroLoads.Cm + lerx3.tail.aeroLoads.Cm + lerx3.lerx.aeroLoads.Cm;
lerx4_momentum = lerx4.wing.aeroLoads.Cm + lerx4.tail.aeroLoads.Cm + lerx4.lerx.aeroLoads.Cm;
lerx5_momentum = lerx5.wing.aeroLoads.Cm + lerx5.tail.aeroLoads.Cm + lerx5.lerx.aeroLoads.Cm;

%%% Cd computation
%lerx0_drag = lerx0.wing.aeroLoads.Cd + lerx0.tail.aeroLoads.Cd;
lerx1_drag = lerx1.lerx.aeroLoads.Cd; %lerx1.wing.aeroLoads.Cd + lerx1.tail.aeroLoads.Cd + lerx1.lerx.aeroLoads.Cd;
lerx2_drag = lerx2.lerx.aeroLoads.Cd; %lerx2.wing.aeroLoads.Cd + lerx2.tail.aeroLoads.Cd + lerx2.lerx.aeroLoads.Cd;
lerx3_drag = lerx3.lerx.aeroLoads.Cd; %lerx3.wing.aeroLoads.Cd + lerx3.tail.aeroLoads.Cd + lerx3.lerx.aeroLoads.Cd;
lerx4_drag = lerx4.lerx.aeroLoads.Cd; %lerx4.wing.aeroLoads.Cd + lerx4.tail.aeroLoads.Cd + lerx4.lerx.aeroLoads.Cd;
lerx5_drag = lerx5.lerx.aeroLoads.Cd; %lerx5.wing.aeroLoads.Cd + lerx5.tail.aeroLoads.Cd + lerx5.lerx.aeroLoads.Cd;


%% Convergence plot (for lerx1)

figure(Name='Convergence')
tiledlayout(2,1);  
nexttile(1);    % Fz
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(alphaDegVec)
        plot(lerx1.tail.designData{i,1}.time , lerx1.tail.designData{i,1}.Fz,'Color',cmap(i,:));  
    end
    yline(lerx1.tail.aeroLoads.Fz)
    xlabel('$time$ [sec]');       ylabel('$F_{z}$ [N]');
    ylim([0e4,2e4])

nexttile(2);    % My
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(alphaDegVec)
        plot(lerx1.tail.designData{i,1}.time , lerx1.tail.designData{i,1}.My,'Color',cmap(i,:));
    end
    yline(lerx1.tail.aeroLoads.My)
    xlabel('$time$ [sec]');      ylabel('$M_{y}$ [N]');
    ylim([-1e5,0e5])
    
colormap(cmap)                              % apply colormap
caxis([cbTicksPos(1),cbTicksPos(end)])      % to be changed in clim since Matlab R2022a
    cb = colorbar;                          % apply colorbar
    cb.Label.String = '$\alpha$';
    cb.Label.Interpreter = 'latex';
    cb.Ticks = cbTicksPos;
    cb.TickLabels = {'',num2str(alphaDegVec),''};
    cb.Layout.Tile = 'east';
set(cb,'TickLabelInterpreter','latex')
% set(convergencePlot,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(convergencePlot,'figure\box_convergence.png','Resolution',500);


%% Chord iteration - plot

figure(Name='Cl alpha')
grid minor; hold on; axis padded; box on;
plot(lerx0.wing.aeroLoads.aoaDeg,lerx0_lift)
plot(lerx1.wing.aeroLoads.aoaDeg,lerx1_lift)
plot(lerx2.wing.aeroLoads.aoaDeg,lerx2_lift)
plot(lerx3.wing.aeroLoads.aoaDeg,lerx3_lift)
xlabel('$\alpha$ [deg]');       ylabel('$C_l$');
legend('no lerx','chord long','chord mid','chord short',Location='best');

figure(Name='Cm alpha')
grid minor; hold on; axis padded; box on;
plot(lerx0.wing.aeroLoads.aoaDeg,lerx0_momentum)
plot(lerx1.wing.aeroLoads.aoaDeg,lerx1_momentum)
plot(lerx2.wing.aeroLoads.aoaDeg,lerx2_momentum)
plot(lerx3.wing.aeroLoads.aoaDeg,lerx3_momentum)
xlabel('$\alpha$ [deg]');       ylabel('$C_m$');
legend('no lerx','chord long','chord mid','chord short',Location='best');

figure(Name='Cd alpha')
grid minor; hold on; axis padded; box on;
%plot(lerx0.wing.aeroLoads.aoaDeg,lerx0_drag)
plot(lerx1.wing.aeroLoads.aoaDeg,lerx1_drag)
plot(lerx2.wing.aeroLoads.aoaDeg,lerx2_drag)
plot(lerx3.wing.aeroLoads.aoaDeg,lerx3_drag)
xlabel('$\alpha$ [deg]');       ylabel('$C_d$');
%legend('no lerx','chord long','chord mid','chord short',Location='best');
legend('chord long','chord mid','chord short',Location='best');


%% sweep iteration - plot

figure(Name='Cl alpha')
grid minor; hold on; axis padded; box on;
plot(lerx0.wing.aeroLoads.aoaDeg,lerx0_lift)
plot(lerx1.wing.aeroLoads.aoaDeg,lerx1_lift)
plot(lerx4.wing.aeroLoads.aoaDeg,lerx4_lift)
plot(lerx5.wing.aeroLoads.aoaDeg,lerx5_lift)
xlabel('$\alpha$ [deg]');       ylabel('$C_l$');
legend('no lerx','sweep 70','sweep 65','sweep 75',Location='best');

figure(Name='Cm alpha')
grid minor; hold on; axis padded; box on;
plot(lerx0.wing.aeroLoads.aoaDeg,lerx0_momentum)
plot(lerx1.wing.aeroLoads.aoaDeg,lerx1_momentum)
plot(lerx4.wing.aeroLoads.aoaDeg,lerx4_momentum)
plot(lerx5.wing.aeroLoads.aoaDeg,lerx5_momentum)
xlabel('$\alpha$ [deg]');       ylabel('$C_m$');
legend('no lerx','sweep 70','sweep 65','sweep 75',Location='best');

figure(Name='Cd alpha')
grid minor; hold on; axis padded; box on;
%plot(lerx0.wing.aeroLoads.aoaDeg,lerx0_drag)
plot(lerx1.wing.aeroLoads.aoaDeg,lerx1_drag)
plot(lerx4.wing.aeroLoads.aoaDeg,lerx4_drag)
plot(lerx5.wing.aeroLoads.aoaDeg,lerx5_drag)
xlabel('$\alpha$ [deg]');       ylabel('$C_d$');
%legend('no lerx','sweep 70','sweep 65','sweep 75',Location='best');
legend('sweep 70','sweep 65','sweep 75',Location='best');

