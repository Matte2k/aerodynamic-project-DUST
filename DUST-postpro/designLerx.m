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


% configuration without lerx
[lerx0.wing,lerx0.tail,lerx0.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx0_aoa',reference);
% [lerx0.wing] = meanAeroLoadsCorrector(lerx0.wing,reference,avgLoadIdx);
% [lerx0.tail] = meanAeroLoadsCorrector(lerx0.tail,reference,avgLoadIdx);
% [lerx0.lerx] = meanAeroLoadsCorrector(lerx0.lerx,reference,avgLoadIdx);
% [lerx0.fuselage] = meanAeroLoadsCorrector(lerx0.fuselage,reference,avgLoadIdx);

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

%% Plot



lerx0_lift = lerx0.wing.aeroLoads.Cl + lerx0.tail.aeroLoads.Cl;
lerx1_lift = lerx1.wing.aeroLoads.Cl + lerx1.tail.aeroLoads.Cl + lerx1.lerx.aeroLoads.Cl;
lerx2_lift = lerx2.wing.aeroLoads.Cl + lerx2.tail.aeroLoads.Cl + lerx2.lerx.aeroLoads.Cl;
lerx3_lift = lerx3.wing.aeroLoads.Cl + lerx3.tail.aeroLoads.Cl + lerx3.lerx.aeroLoads.Cl;

figure
grid minor; hold on; axis padded; box on;
plot(lerx0.wing.aeroLoads.aoaDeg,lerx0_lift)
plot(lerx1.wing.aeroLoads.aoaDeg,lerx1_lift)
plot(lerx2.wing.aeroLoads.aoaDeg,lerx2_lift)
plot(lerx3.wing.aeroLoads.aoaDeg,lerx3_lift)
legend('0','1','2','3')


% loads aero della convergenza è dato da tail+wing+lerx


%%

cmap = jet(numel(alphaDegVec));      % discrete color map                     % TO BE SET
    cbTicksCount = 1:length(alphaDegVec);
    cbTicksPos = [0.5, cbTicksCount, (cbTicksCount(end)+0.5)];

figure
%%% Convergence
% convergencePlot = figure(Name='convergence');
% tiledlayout(2,1);  
%nexttile(3);    % Fz
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(alphaDegVec)
        plot(lerx3.tail.designData{i,1}.time , lerx3.tail.designData{i,1}.Fz,'Color',cmap(i,:));
        
    end
    yline(lerx3.tail.aeroLoads.Fz)
    xlabel('$time$ [sec]');       ylabel('$F_{z}$ [N]');
    %ylim([6e4,8e4])

    figure
%nexttile(6);    % My
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(alphaDegVec)
        plot(lerx3.tail.designData{i,1}.time , lerx3.tail.designData{i,1}.My,'Color',cmap(i,:));
        
    end
    yline(lerx3.tail.aeroLoads.My)
    xlabel('$time$ [sec]');      ylabel('$M_{y}$ [N]');
    %ylim([-5e5,-3e5])
    
colormap(cmap)                              % apply colormap
caxis([cbTicksPos(1),cbTicksPos(end)])      % to be changed in clim since Matlab R2022a
    cb = colorbar;                          % apply colorbar
    cb.Label.Interpreter = 'latex';
    %cb.Label.String = variableName;
    cb.Ticks = cbTicksPos;
    cb.TickLabels = {'',num2str(alphaDegVec),''};
    cb.Layout.Tile = 'east';
set(cb,'TickLabelInterpreter','latex')
% set(convergencePlot,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(convergencePlot,'figure\box_convergence.png','Resolution',500);
    
