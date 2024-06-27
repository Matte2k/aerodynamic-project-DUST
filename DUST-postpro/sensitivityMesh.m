clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% DUST data

% Reference value of the run to postprocess
[reference]  = runReferenceValue(161.12,0.7708,2.65,26.56);

% Data parser for the different component of the geometry
load("data/mesh/aeroLoads_mesh.mat",'-mat');     
dataDUST.aeroLoads    = aeroLoads_mesh;      clear('aeroLoads_mesh');
load("data/mesh/analysisData_mesh.mat",'-mat');  
dataDUST.rawRunData   = analysisData_mesh;   clear('analysisData_mesh');
load("data/mesh/structLoads_mesh.mat",'-mat');   
dataDUST.structLoads  = structLoads_mesh;    clear('structLoads_mesh');


%% Plot

% Plot variable initializaition
panelChord   = [5 10 15 20 25 30]';
variableName = 'number of chord panels';
legendCell   = cell(length(panelChord),1);
%cmap = jet(numel(panelChord));      % discrete color map                   % TO BE SET
cmap = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250; 0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840];
cmap = cmap(1:length(panelChord),:);
    cbTicksCount = 1:length(panelChord);
    cbTicksPos = [0.5, cbTicksCount, (cbTicksCount(end)+0.5)];

% Figure init
meshPlot = figure(Name='mesh senstivity');
tiledlayout(2,3)  


%%% CPU-time
% timePlot = figure(Name='Cpu time');
nexttile(1,[2 1])
hold on;    grid minor;     axis padded;    box on;
plot(panelChord,cell2mat(dataDUST.rawRunData(:,6)),'-o')
xlabel('$n^{\circ}$ chord panel')
ylabel('CPU $time$ [sec]')
% set(timePlot,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(timePlot,'figure\mesh_timecost.png','Resolution',500);


%%% Convergence
% convergencePlot = figure(Name='convergence');
% tiledlayout(2,1);
nexttile(3);    % Fz
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(panelChord)
        plot(dataDUST.rawRunData{i,1}.time , dataDUST.rawRunData{i,1}.Fz,'Color',cmap(i,:));
        legendCell{i} = sprintf('%s = %.4f',variableName,panelChord(i));
    end
    xlabel('$time$ [sec]');       ylabel('$F_{z}$ [N]');
    ylim([1.15e4,1.55e4])

nexttile(6);    % My
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(panelChord)
        plot(dataDUST.rawRunData{i,1}.time , dataDUST.rawRunData{i,1}.My,'Color',cmap(i,:));
        legendCell{i} = sprintf('%s = %.4f',variableName,panelChord(i));
    end
    xlabel('$time$ [sec]');      ylabel('$M_{y}$ [N]');
    ylim([4.5e4,6.5e4])
    
colormap(cmap)                              % apply colormap
caxis([cbTicksPos(1),cbTicksPos(end)])      % to be changed in clim since Matlab R2022a
    cb = colorbar;                          % apply colorbar
    cb.Label.Interpreter = 'latex';
    cb.Label.String = variableName;
    cb.Ticks = cbTicksPos;
    cb.TickLabels = {'',num2str(panelChord),''};
    cb.Layout.Tile = 'east';
set(cb,'TickLabelInterpreter','latex')
% set(convergencePlot,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(convergencePlot,'figure\mesh_convergence.png','Resolution',500);


%%% Loads
% adimensionalLoad = figure(Name='loads');
% tiledlayout(2,1);
nexttile(2)    % Cz
    hold on;    grid minor;     axis padded;    box on;
    plot(panelChord,dataDUST.structLoads.Cfz,'-o')
    xlabel('$n^{\circ}$ chord panel')
    ylabel('$C_z$')

nexttile(5)     %Cm
    hold on;    grid minor;     axis padded;    box on;
    plot(panelChord,dataDUST.structLoads.Cmy,'-o')
    xlabel('$n^{\circ}$ chord panel')
    ylabel('$C_m$')
% set(adimensionalLoad,'units','centimeters','position',[0,0,10,9]);
% exportgraphics(adimensionalLoad,'figure\mesh_loads.png','Resolution',500);


set(meshPlot,'units','centimeters','position',[0,0,30,10]);                 
exportgraphics(meshPlot,'figure\mesh_sensitivity.png','Resolution',1000);
