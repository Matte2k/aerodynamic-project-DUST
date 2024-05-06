clearvars;  close all;  clc
addpath(genpath("./"));
currentPath = pwd;

aoaVector = {  'u_inf = (/0.9962, 0.0000, -0.0872/)'; ...
               'u_inf = (/1.0000, 0.0000,  0.0000/)'; ...
               'u_inf = (/0.9962, 0.0000,  0.0872/)'; ...
               'u_inf = (/0.9848, 0.0000,  0.1736/)'; ...
               'u_inf = (/0.9397, 0.0000,  0.3420/)'};
aoaValues = {'am5','a0','a5','a10','a20'};


%% Dust iteration

% to implement using a parfor maybe
% -> first set all input file, then parfor with all the simulations

for i = 1:size(aoaVector,1)

customVars = aoaVector{i};
runName = aoaValues{i};

%%% Dust.in generation
[inputFilePath,outputPath] = inputFileMaker_DUST(customVars,runName,currentPath);


%%% Dust_post.in generation
[ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runName,currentPath);


%%% Dust run
startingPath = cd;
cd("./DUST");
system('dust_pre');

dustCall = sprintf('dust %s',inputFilePath);
system(dustCall);

ppCall = sprintf('dust_post %s',ppFilePath);
system(ppCall);

cd(startingPath);

end


%% Dust data analysis

%%% Flag and settings
set(0,'defaulttextinterpreter','latex');  
set(0,'defaultAxesTickLabelInterpreter','latex');  
set(0,'defaultLegendInterpreter','latex');

plotFlag = struct;
    plotFlag.wing = true;           % plot wing only data
    %plotFlag.wingFuselage = false;   % plot wing-fuselage interaction data
    %plotFlag.wingTank = false;       % plot wing-tank interaction data
    
    plotFlag.convergence = true;    % plot convergence over time for previous selected plot
    plotFlag.compare = true;        % plot compare between different cases


%%% Data inport
% wing force
[wing.am5] = readDataDUST('pp-DUST/am5/pp_loads.dat','integral_loads');
[wing.a0 ] = readDataDUST('pp-DUST/a0/pp_loads.dat' ,'integral_loads');
[wing.a5 ] = readDataDUST('pp-DUST/a5/pp_loads.dat' ,'integral_loads');
[wing.a10] = readDataDUST('pp-DUST/a10/pp_loads.dat','integral_loads');
[wing.a20] = readDataDUST('pp-DUST/a10/pp_loads.dat','integral_loads');

% Angle considered
alphaDeg = [-5, 0, 5, 10, 20];
alphaRad = deg2rad(alphaDeg);


%%% Aerodynamic force computation
wing.FzVec = [wing.am5.Fz(end), wing.a0.Fz(end), wing.a5.Fz(end), wing.a10.Fz(end), wing.a20.Fz(end)];
wing.FxVec = [wing.am5.Fx(end), wing.a0.Fx(end), wing.a5.Fx(end), wing.a10.Fx(end), wing.a20.Fx(end)];
wing.liftVec = - wing.FxVec.*sin(alphaRad) + wing.FzVec.*cos(alphaRad);
wing.dragVec =   wing.FxVec.*cos(alphaRad) + wing.FzVec.*sin(alphaRad);

% wing.FzVecKutta = [wing.kam5.Fz(end), wing.ka0.Fz(end), wing.ka5.Fz(end), wing.ka10.Fz(end)];
% wing.FxVecKutta = [wing.kam5.Fx(end), wing.ka0.Fx(end), wing.ka5.Fx(end), wing.ka10.Fx(end)];
% wing.liftVecKutta = - wing.FxVecKutta.*sin(alphaRad) + wing.FzVecKutta.*cos(alphaRad);
% wing.dragVecKutta =   wing.FxVecKutta.*cos(alphaRad) + wing.FzVecKutta.*sin(alphaRad);


%%% Aerodynamic force plot
if plotFlag.wing == true
    figure("Name",'lift vs alpha')
    title('wing L vs $\alpha$')
    hold on;    grid on;    axis padded;
    plot(alphaDeg , wing.liftVec);
    %plot(alphaDeg , wing.liftVecKutta);
    %legend('no kutta','kutta')
    xlabel('$\alpha$');      ylabel('$L$');

    figure("Name",'drag vs alpha')
    title('wing D vs $\alpha$')
    hold on;    grid on;    axis padded;
    plot(alphaDeg , wing.dragVec);
    %plot(alphaDeg , wing.dragVecKutta);
    %legend('no kutta','kutta')
    xlabel('$\alpha$');      ylabel('$D$');

    figure("Name",'lift vs drag')
    title('wing polar')
    hold on;    grid on;    axis padded;
    plot(wing.dragVec , wing.liftVec);
    %plot(wing.dragVecKutta , wing.liftVecKutta);
    %legend('no kutta','kutta')
    xlabel('$D$');      ylabel('$L$');
    
    % Convergence plots
    if plotFlag.convergence == true
        figure("Name",'Fz vs time')
        title('wing $F_{z}$ convergence')
        hold on;    grid on;    axis padded;
        plot(wing.a0.time , wing.a0.Fz );
        plot(wing.a5.time , wing.a5.Fz );
        plot(wing.a10.time, wing.a10.Fz);
        plot(wing.a20.time, wing.a20.Fz);
        plot(wing.am5.time, wing.am5.Fz);
        xlabel('$time$');      ylabel('$F_{z}$');
        legend('$\alpha = 0^{\circ}$','$\alpha = 5^{\circ}$','$\alpha = 10^{\circ}$','$\alpha = 20^{\circ}$','$\alpha = -5^{\circ}$')

        figure("Name",'Fx vs time')
        title('wing $F_{x}$ convergence')
        hold on;    grid on;    axis padded;
        plot(wing.a0.time , wing.a0.Fx );
        plot(wing.a5.time , wing.a5.Fx );
        plot(wing.a10.time, wing.a10.Fx);
        plot(wing.a20.time, wing.a20.Fx);
        plot(wing.am5.time, wing.am5.Fx);
        xlabel('$time$');      ylabel('$F_{x}$');
        legend('$\alpha = 0^{\circ}$','$\alpha = 5^{\circ}$','$\alpha =10^{\circ}$','$\alpha =20^{\circ}$','$\alpha = -5^{\circ}$')
    end
end
