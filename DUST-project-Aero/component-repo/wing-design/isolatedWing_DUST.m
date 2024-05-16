% Isolated wing analysis at different angle of attack
% - TO DO A REFACTOR SPLITTING SECTIONS IN FUNCTION-

%clearvars;  close all;  clc
addpath(genpath("./"));
currentPath = pwd;

%% INPUT

% Angle considered
aoaValueDeg = 0:5:20;
aoaValueRad = deg2rad(aoaValueDeg);

% Analysis name
analysisType = 'integral_loads';    % DUST analysis type
analysisName = 'wing2';             % change DUST output folder 
    % wing1 -> panel method
    % wing2 -> vlm

% Constant
absU   = 5;
rhoInf = 1.225;
Sref   = 16.3;

% Flag and settings
plotFlag = struct;
    plotFlag.wing = true;           % plot wing only data  
    plotFlag.convergence = true;    % plot convergence over time for previous selected plot
    plotFlag.compare = true;        % plot compare between different cases
runDUST = false;                    % set if run DUST or use data already saved

% Graphic settings
set(0,'defaulttextinterpreter','latex');  
set(0,'defaultAxesTickLabelInterpreter','latex');  
set(0,'defaultLegendInterpreter','latex');


%% TO MAKE IT AUTOMATIC USING: computeVelVec.m
aoaVector = {  'u_inf = (/5.0000, 0.0000, 0.0000/)'; ...   % aoa = 0
               'u_inf = (/4.9810, 0.0000, 0.4358/)'; ...   % aoa = 5
               'u_inf = (/4.9240, 0.0000, 0.8682/)'; ...   % aoa = 10
               'u_inf = (/4.8296, 0.0000, 1.2941/)'; ...  % aoa = 15
               'u_inf = (/4.6985, 0.0000, 1.7101/)'};     % aoa = 20


%% Dust iteration

runNameCell = cell(size(aoaVector,1),1);
for i = 1:size(aoaVector,1)

    runNameCell{i} = sprintf('%s_a%.0f',analysisName,aoaValueDeg(i));
    customVars = aoaVector{i};

    if runDUST == true
        %%% Dust.in generation
        [inputFilePath,outputPath] = inputFileMaker_DUST(customVars,runNameCell{i},currentPath);

        %%% Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},currentPath);

        %%% Dust run
        startingPath = cd;
        cd("./DUST");
        dustPreCall = sprintf('dust_pre dust_pre_%s.in',analysisName);
        system(dustPreCall);

        dustCall = sprintf('dust %s',inputFilePath);
        system(dustCall);

        dustPostCall = sprintf('dust_post %s',ppFilePath);
        system(dustPostCall);

        cd(startingPath);
    end

end


%% Dust data analysis

%% function -> data import

%%% Data import
% wing force
paramRunData = cell(size(aoaVector,1),4);
for i = 1:size(aoaVector,1)

    dataPath = sprintf('pp-DUST/%s/pp_loads.dat',runNameCell{i});
    dataType = sprintf('%s',analysisType);
    
    paramRunData{i,1} = readDataDUST(dataPath,dataType);
    paramRunData{i,2} = aoaValueDeg(i);
    paramRunData{i,3} = dataType;
    paramRunData{i,4} = runNameCell{i};

end

    % Convergence plots
    legString = cell(size(aoaVector,1),1);
    if plotFlag.convergence == true
        figure("Name",'Fz vs time')
        title('wing $F_{z}$ convergence')
        hold on;    grid on;    axis padded;
        for i = 1:size(aoaVector,1)
            plot(paramRunData{i,1}.time , paramRunData{i,1}.Fz);
            legString{i} = sprintf('$\\alpha = %.0f^{\\circ}$',aoaValueDeg(i)); 
        end
        xlabel('$time$');       ylabel('$F_{z}$');
        legend(legString)

        figure("Name",'Fx vs time')
        title('wing $F_{x}$ convergence')
        hold on;    grid on;    axis padded;
        for i = 1:size(aoaVector,1)
            plot(paramRunData{i,1}.time , paramRunData{i,1}.Fz);
        end
        xlabel('$time$');      ylabel('$F_{x}$');
        legend(legString)      % same computed before
    end

%%% Output: save 'paramRunData' cell as a .mat file
    

%% function -> force computation (input: paramRunData,absU,Sref,rhoInf)

%%% Aerodynamic force computation
force = struct;
for i = 1:size(aoaVector,1)
    force.aoaDeg(i) = paramRunData{i,2};
    force.Fz(i)  = paramRunData{i,1}.Fz(end);
    force.Fx(i)  = paramRunData{i,1}.Fx(end);
end
force.aoaRad = deg2rad(force.aoaDeg);

force.L = - force.Fx.*sin(force.aoaRad) + force.Fz.*cos(force.aoaRad);
force.D =   force.Fx.*cos(force.aoaRad) + force.Fz.*sin(force.aoaRad);

%force.Cx
%force.Cz
force.Cl = force.L ./ (0.5* absU^2 * Sref * rhoInf);
force.Cd = force.D ./ (0.5* absU^2 * Sref * rhoInf);

% momenti to add

%%% Dust data plot
% Aerodynamic force plot
if plotFlag.wing == true
    figure("Name",'lift vs alpha')
    title('wing L vs $\alpha$')
    hold on;    grid on;    axis padded;
    plot(force.aoaDeg , force.Cl);
    xlabel('$\alpha$');      ylabel('$C_L$');

    figure("Name",'drag vs alpha')
    title('wing D vs $\alpha$')
    hold on;    grid on;    axis padded;
    plot(force.aoaDeg , force.Cd);
    xlabel('$\alpha$');      ylabel('$C_D$');

    figure("Name",'lift vs drag')
    title('wing polar')
    hold on;    grid on;    axis padded;
    plot(force.Cd , force.Cl);
    xlabel('$C_D$');      ylabel('$C_L$');  

end

%%% Output: save 'force' struct as a .mat file
