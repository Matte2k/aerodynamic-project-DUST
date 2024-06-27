clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;


%% DUST data

% Reference value of the run to postprocess
[reference] = runReferenceValue(161.12,0.7708,2.65,26.56);

% Data parser for the different component of the geometry
load("data/box/aeroLoads_box.mat",'-mat');     
dataDUST.aeroLoads    = aeroLoads_box;      clear('aeroLoads_box');
load("data/box/analysisData_box.mat",'-mat');  
dataDUST.rawRunData   = analysisData_box;   clear('analysisData_box');
load("data/box/structLoads_box.mat",'-mat');   
dataDUST.structLoads  = structLoads_box;    clear('structLoads_box');


%% Plot

% Plot variable initializaition
boxLength     = cell2mat(dataDUST.rawRunData(:,5));
variableName = 'Box length [m]';
legendCell   = cell(length(boxLength),1);
%cmap = jet(numel(boxLength));      % discrete color map                     % TO BE SET
cmap = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250; 0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840];
cmap = cmap(1:length(boxLength),:);
    cbTicksCount = 1:length(boxLength);
    cbTicksPos = [0.5, cbTicksCount, (cbTicksCount(end)+0.5)];

% Figure init
boxPlot = figure(Name='box senstivity');
tiledlayout(2,3) 
    

%%% CPU-time
% timePlot = figure(Name='Cpu time');
nexttile(1,[2 1])
hold on;    grid minor;     axis padded;    box on;
plot(boxLength,cell2mat(dataDUST.rawRunData(:,6)),'-o')
xlabel('$Domain$ $length$ [m]')
ylabel('CPU $time$ [sec]')
% set(timePlot,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(timePlot,'figure\box_timecost.png','Resolution',500);
    
    
%%% Convergence
% convergencePlot = figure(Name='convergence');
% tiledlayout(2,1);  
nexttile(3);    % Fz
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(boxLength)
        plot(dataDUST.rawRunData{i,1}.time , dataDUST.rawRunData{i,1}.Fz,'Color',cmap(i,:));
        legendCell{i} = sprintf('%s = %.4f',variableName,boxLength(i));
    end
    xlabel('$time$ [sec]');       ylabel('$F_{z}$ [N]');
    ylim([1.3e4,1.6e4])

nexttile(6);    % My
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(boxLength)
        plot(dataDUST.rawRunData{i,1}.time , dataDUST.rawRunData{i,1}.My,'Color',cmap(i,:));
        legendCell{i} = sprintf('%s = %.4f',variableName,boxLength(i));
    end
    xlabel('$time$ [sec]');      ylabel('$M_{y}$ [N]');
    ylim([-8.25e4,-6.75e4])
    
colormap(cmap)                              % apply colormap
caxis([cbTicksPos(1),cbTicksPos(end)])      % to be changed in clim since Matlab R2022a
    cb = colorbar;                          % apply colorbar
    cb.Label.Interpreter = 'latex';
    cb.Label.String = variableName;
    cb.Ticks = cbTicksPos;
    cb.TickLabels = {'',num2str(boxLength),''};
    cb.Layout.Tile = 'east';
set(cb,'TickLabelInterpreter','latex')
% set(convergencePlot,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(convergencePlot,'figure\box_convergence.png','Resolution',500);


%%% Loads
% adimensionalLoad = figure(Name='loads');
% tiledlayout(2,1);
nexttile(2)    % Cz
    hold on;    grid minor;     axis padded;    box on;
    plot(boxLength,dataDUST.structLoads.Cfz,'-o')
    xlabel('$Domain$ $length$ [m]')
    ylabel('$C_z$')

nexttile(5)    %Cm
    hold on;    grid minor;     axis padded;    box on;
    plot(boxLength,dataDUST.structLoads.Cmy,'-o')
    xlabel('$Domain$ $length$ [m]')
    ylabel('$C_m$')
% set(adimensionalLoad,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(adimensionalLoad,'figure\box_loads.png','Resolution',500);


set(boxPlot,'units','centimeters','position',[0,0,30,10]);                 
exportgraphics(boxPlot,'figure\box_sensitivity.png','Resolution',1000);
