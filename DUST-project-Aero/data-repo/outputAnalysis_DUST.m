%   
%       -- OUTPUT ANALYSIS for DUST simulation --
%   
%   Script built to import in MATLAB and analyse results obtained from
%   DUST simulation. In this specific case integral_loads.dat file obtained
%   from dust_post will be studied by plotting some meaningful results
%
%   Matteo Baio 
%

clearvars;  close all;  clc

% Path with all DUST output data
%addpath("src/");
%addpath(genpath("data-repo/"));
addpath(genpath("./"));

% Set default interpreter for text
set(0,'defaulttextinterpreter','latex');  
set(0,'defaultAxesTickLabelInterpreter','latex');  
set(0,'defaultLegendInterpreter','latex');


%% INPUT

plotFlag = struct;
    plotFlag.wing = true;           % plot wing only data
    plotFlag.wingFuselage = false;   % plot wing-fuselage interaction data
    plotFlag.wingTank = false;       % plot wing-tank interaction data
    
    plotFlag.convergence = false;    % plot convergence over time for previous selected plot
    plotFlag.compare = false;        % plot compare between different cases


%% DATA IMPORT

% fuselage force
[fuselage.a0 ] = readDataDUST('fuselage/fuselage_a0.dat' ,'integral_loads');
[fuselage.a5 ] = readDataDUST('fuselage/fuselage_a5.dat' ,'integral_loads');
[fuselage.a10] = readDataDUST('fuselage/fuselage_a10.dat','integral_loads');
[fuselage.am5] = readDataDUST('fuselage/fuselage_a-5.dat','integral_loads');

% wing force
[wing.a0 ] = readDataDUST('wing/wing_a0.dat' ,'integral_loads');
[wing.a5 ] = readDataDUST('wing/wing_a5.dat' ,'integral_loads');
[wing.a10] = readDataDUST('wing/wing_a10.dat','integral_loads');
[wing.am5] = readDataDUST('wing/wing_a-5.dat','integral_loads');

[wing.ka0 ] = readDataDUST('wing/wing_ka0.dat' ,'integral_loads');
[wing.ka5 ] = readDataDUST('wing/wing_ka5.dat' ,'integral_loads');
[wing.ka10] = readDataDUST('wing/wing_ka10.dat','integral_loads');
[wing.kam5] = readDataDUST('wing/wing_ka-5.dat','integral_loads');

% wing+fuselage influence on wing force
[wingFuselage.wing.d175] = readDataDUST('wing-fuselage/wing_a5d175.dat','integral_loads');
[wingFuselage.wing.d200] = readDataDUST('wing-fuselage/wing_a5d200.dat','integral_loads');
[wingFuselage.wing.d225] = readDataDUST('wing-fuselage/wing_a5d225.dat','integral_loads');
[wingFuselage.wing.d250] = readDataDUST('wing-fuselage/wing_a5d250.dat','integral_loads');
[wingFuselage.wing.d300] = readDataDUST('wing-fuselage/wing_a5d300.dat','integral_loads');

% wink+fuselage force data suppressed for the moment
% [wingFuselage.couple.d175] = readDataDUST('wing-fuselage/couple_a5d175.dat','integral_loads');
% [wingFuselage.couple.d200] = readDataDUST('wing-fuselage/couple_a5d200.dat','integral_loads');
% [wingFuselage.couple.d225] = readDataDUST('wing-fuselage/couple_a5d225.dat','integral_loads');
% [wingFuselage.couple.d250] = readDataDUST('wing-fuselage/couple_a5d250.dat','integral_loads');
% [wingFuselage.couple.d300] = readDataDUST('wing-fuselage/couple_a5d300.dat','integral_loads');

% wing+tank influence on wing force
[wingTank.wing.default.d25 ] = readDataDUST('wing-tank/default/wing_a5d25.dat','integral_loads');
[wingTank.wing.default.d50 ] = readDataDUST('wing-tank/default/wing_a5d50.dat','integral_loads');
[wingTank.wing.default.d75 ] = readDataDUST('wing-tank/default/wing_a5d75.dat','integral_loads');
[wingTank.wing.default.d100] = readDataDUST('wing-tank/default/wing_a5d100.dat','integral_loads');
[wingTank.wing.default.d200] = readDataDUST('wing-tank/default/wing_a5d200.dat','integral_loads');

% wing+tank influence on wing force no penetration
[wingTank.wing.NP.d25 ] = readDataDUST('wing-tank/NP/wing_a5d25.dat','integral_loads');
[wingTank.wing.NP.d50 ] = readDataDUST('wing-tank/NP/wing_a5d50.dat','integral_loads');
[wingTank.wing.NP.d75 ] = readDataDUST('wing-tank/NP/wing_a5d75.dat','integral_loads');
[wingTank.wing.NP.d100] = readDataDUST('wing-tank/NP/wing_a5d100.dat','integral_loads');
[wingTank.wing.NP.d200] = readDataDUST('wing-tank/NP/wing_a5d200.dat','integral_loads');

% wing+tank influence on wing force no penetration, vortex strech and diffusion
[wingTank.wing.SDP.d25 ] = readDataDUST('wing-tank/SDP/wing_a5d25.dat','integral_loads');
[wingTank.wing.SDP.d50 ] = readDataDUST('wing-tank/SDP/wing_a5d50.dat','integral_loads');
[wingTank.wing.SDP.d75 ] = readDataDUST('wing-tank/SDP/wing_a5d75.dat','integral_loads');
[wingTank.wing.SDP.d100] = readDataDUST('wing-tank/SDP/wing_a5d100.dat','integral_loads');
[wingTank.wing.SDP.d200] = readDataDUST('wing-tank/SDP/wing_a5d200.dat','integral_loads');

% wink+tank force data suppressed for the moment
% [wingTank.couple.d25 ] = readDataDUST('wing-tank/couple_a5d25.dat','integral_loads');
% [wingTank.couple.d50 ] = readDataDUST('wing-tank/couple_a5d50.dat','integral_loads');
% [wingTank.couple.d75 ] = readDataDUST('wing-tank/couple_a5d75.dat','integral_loads');
% [wingTank.couple.d100] = readDataDUST('wing-tank/couple_a5d100.dat','integral_loads');

% Angle considered
alphaDeg = [-5, 0, 5, 10];
alphaRad = deg2rad(alphaDeg);

% Distance considered
fuselageGap = [175 200 225 250 300];
tankGap = [25 50 75 100 200];
compareGap = [1 2 3 4 5];   % could be done bettere by adimentionalize
                            % the gaps over a meaningful reference value

%% WING

%%% Aerodynamic force computation
wing.FzVec = [wing.am5.Fz(end), wing.a0.Fz(end), wing.a5.Fz(end), wing.a10.Fz(end)];
wing.FxVec = [wing.am5.Fx(end), wing.a0.Fx(end), wing.a5.Fx(end), wing.a10.Fx(end)];
wing.liftVec = - wing.FxVec.*sin(alphaRad) + wing.FzVec.*cos(alphaRad);
wing.dragVec =   wing.FxVec.*cos(alphaRad) + wing.FzVec.*sin(alphaRad);

wing.FzVecKutta = [wing.kam5.Fz(end), wing.ka0.Fz(end), wing.ka5.Fz(end), wing.ka10.Fz(end)];
wing.FxVecKutta = [wing.kam5.Fx(end), wing.ka0.Fx(end), wing.ka5.Fx(end), wing.ka10.Fx(end)];
wing.liftVecKutta = - wing.FxVecKutta.*sin(alphaRad) + wing.FzVecKutta.*cos(alphaRad);
wing.dragVecKutta =   wing.FxVecKutta.*cos(alphaRad) + wing.FzVecKutta.*sin(alphaRad);


%%% Aerodynamic force plot
if plotFlag.wing == true
    figure("Name",'lift vs alpha')
    title('wing L vs $\alpha$')
    hold on;    grid on;    axis padded;
    plot(alphaDeg , wing.liftVec);
    plot(alphaDeg , wing.liftVecKutta);
    legend('no kutta','kutta')
    xlabel('$\alpha$');      ylabel('$L$');

    figure("Name",'drag vs alpha')
    title('wing D vs $\alpha$')
    hold on;    grid on;    axis padded;
    plot(alphaDeg , wing.dragVec);
    plot(alphaDeg , wing.dragVecKutta);
    legend('no kutta','kutta')
    xlabel('$\alpha$');      ylabel('$D$');

    figure("Name",'lift vs drag')
    title('wing polar')
    hold on;    grid on;    axis padded;
    plot(wing.dragVec , wing.liftVec);
    plot(wing.dragVecKutta , wing.liftVecKutta);
    legend('no kutta','kutta')
    xlabel('$D$');      ylabel('$L$');
    
    % Convergence plots
    if plotFlag.convergence == true
        figure("Name",'Fz vs time')
        title('wing $F_{z}$ convergence')
        hold on;    grid on;    axis padded;
        plot(wing.a0.time , wing.a0.Fz );
        plot(wing.a5.time , wing.a5.Fz );
        plot(wing.a10.time, wing.a10.Fz);
        plot(wing.am5.time, wing.am5.Fz);
        xlabel('$time$');      ylabel('$F_{z}$');
        legend('$\alpha = 0^{\circ}$','$\alpha = 5^{\circ}$','$\alpha = 10^{\circ}$','$\alpha = -5^{\circ}$')

        figure("Name",'Fx vs time')
        title('wing $F_{x}$ convergence')
        hold on;    grid on;    axis padded;
        plot(wing.a0.time , wing.a0.Fx );
        plot(wing.a5.time , wing.a5.Fx );
        plot(wing.a10.time, wing.a10.Fx);
        plot(wing.am5.time, wing.am5.Fx);
        xlabel('$time$');      ylabel('$F_{x}$');
        legend('$\alpha = 0^{\circ}$','$\alpha = 5^{\circ}$','$\alpha =10^{\circ}$','$\alpha = -5^{\circ}$')
    end
end


%% WING + FUSELAGE  (only wing contribute)

%%% Aerodynamic force computation
wingFuselage.FzVec = [wingFuselage.wing.d175.Fz(end), wingFuselage.wing.d200.Fz(end), ...
                      wingFuselage.wing.d225.Fz(end), wingFuselage.wing.d250.Fz(end), wingFuselage.wing.d300.Fz(end)];
wingFuselage.FxVec = [wingFuselage.wing.d175.Fx(end), wingFuselage.wing.d200.Fx(end), ...
                      wingFuselage.wing.d225.Fx(end), wingFuselage.wing.d250.Fx(end), wingFuselage.wing.d300.Fx(end)];

wingFuselage.liftVec = - wingFuselage.FxVec.*sin(alphaRad(3)) + wingFuselage.FzVec.*cos(alphaRad(3));
wingFuselage.dragVec =   wingFuselage.FxVec.*cos(alphaRad(3)) + wingFuselage.FzVec.*sin(alphaRad(3));


%%% Aerodynamic force plot
if plotFlag.wingFuselage == true
    figure("Name",'lift vs gap')
    title('wing-fuselage lift')
    hold on;    grid on;    axis padded;
    plot(fuselageGap , wingFuselage.liftVec);
    yline(wing.liftVec(3),'r--')
    xlabel('gap');      ylabel('L');
    legend('L(gap)','L(inf)',Location='best')

    figure("Name",'drag vs gap')
    title('wing-fuselage drag')
    hold on;    grid on;    axis padded;
    plot(fuselageGap , wingFuselage.dragVec);
    yline(wing.dragVec(3),'r--')
    xlabel('gap');      ylabel('D');
    legend('D(gap)','D(inf)',Location='best')

    % Convergence plots    
    if plotFlag.convergence == true
        figure("Name",'Fz vs time')
        title('wing+fuselage $F_{z}$ convergence')
        hold on;    grid on;    axis padded;
        plot(wingFuselage.wing.d175.time, wingFuselage.wing.d175.Fz);
        plot(wingFuselage.wing.d200.time, wingFuselage.wing.d200.Fz);
        plot(wingFuselage.wing.d225.time, wingFuselage.wing.d225.Fz);
        plot(wingFuselage.wing.d250.time, wingFuselage.wing.d250.Fz);
        plot(wingFuselage.wing.d300.time, wingFuselage.wing.d300.Fz);
        xlabel('$time$');      ylabel('$F_{z}$');
        legend('d=1.75','d=2.0','d=2.25','d=2.50','d=3.0')

        figure("Name",'Fx vs time')
        title('wing+fuselage $F_{x}$ convergence')
        hold on;    grid on;    axis padded;
        plot(wingFuselage.wing.d175.time, wingFuselage.wing.d175.Fx);
        plot(wingFuselage.wing.d200.time, wingFuselage.wing.d200.Fx);
        plot(wingFuselage.wing.d225.time, wingFuselage.wing.d225.Fx);
        plot(wingFuselage.wing.d250.time, wingFuselage.wing.d250.Fx);
        plot(wingFuselage.wing.d300.time, wingFuselage.wing.d300.Fx);
        xlabel('$time$');      ylabel('$F_{x}$');
        legend('d=1.75','d=2.0','d=2.25','d=2.50','d=3.0')
    end
end


%% WING + TANKS  (only wing contribute)

%%% Aerodynamic force computation
wingTank.default.FzVec = [wingTank.wing.default.d25.Fz(end), wingTank.wing.default.d50.Fz(end), ...
                          wingTank.wing.default.d75.Fz(end), wingTank.wing.default.d100.Fz(end) , wingTank.wing.default.d200.Fz(end)];
wingTank.default.FxVec = [wingTank.wing.default.d25.Fx(end), wingTank.wing.default.d50.Fx(end), ...
                          wingTank.wing.default.d75.Fx(end), wingTank.wing.default.d100.Fx(end), wingTank.wing.default.d200.Fx(end)];

wingTank.NP.FzVec = [wingTank.wing.NP.d25.Fz(end), wingTank.wing.NP.d50.Fz(end), ...
                     wingTank.wing.NP.d75.Fz(end), wingTank.wing.NP.d100.Fz(end) , wingTank.wing.NP.d200.Fz(end)];
wingTank.NP.FxVec = [wingTank.wing.NP.d25.Fx(end), wingTank.wing.NP.d50.Fx(end), ...
                     wingTank.wing.NP.d75.Fx(end), wingTank.wing.NP.d100.Fx(end), wingTank.wing.NP.d200.Fx(end)];

wingTank.SDP.FzVec = [wingTank.wing.SDP.d25.Fz(end), wingTank.wing.SDP.d50.Fz(end), ...
                      wingTank.wing.SDP.d75.Fz(end), wingTank.wing.SDP.d100.Fz(end) , wingTank.wing.SDP.d200.Fz(end)];
wingTank.SDP.FxVec = [wingTank.wing.SDP.d25.Fx(end), wingTank.wing.SDP.d50.Fx(end), ...
                      wingTank.wing.SDP.d75.Fx(end), wingTank.wing.SDP.d100.Fx(end), wingTank.wing.SDP.d200.Fx(end)];


wingTank.default.liftVec = - wingTank.default.FxVec.*sin(alphaRad(3)) + wingTank.default.FzVec.*cos(alphaRad(3));
wingTank.default.dragVec =   wingTank.default.FxVec.*cos(alphaRad(3)) + wingTank.default.FzVec.*sin(alphaRad(3));

wingTank.NP.liftVec = - wingTank.NP.FxVec.*sin(alphaRad(3)) + wingTank.NP.FzVec.*cos(alphaRad(3));
wingTank.NP.dragVec =   wingTank.NP.FxVec.*cos(alphaRad(3)) + wingTank.NP.FzVec.*sin(alphaRad(3));

wingTank.SDP.liftVec = - wingTank.SDP.FxVec.*sin(alphaRad(3)) + wingTank.SDP.FzVec.*cos(alphaRad(3));
wingTank.SDP.dragVec =   wingTank.SDP.FxVec.*cos(alphaRad(3)) + wingTank.SDP.FzVec.*sin(alphaRad(3));


%%% Aerodynamic force plot
if plotFlag.wingTank == true
    figure("Name",'lift vs gap')
    title('wing-fuselage lift')
    hold on;    grid on;    axis padded;
    plot(tankGap , wingTank.default.liftVec);
    plot(tankGap , wingTank.NP.liftVec);
    plot(tankGap , wingTank.SDP.liftVec);
    yline(wing.liftVec(3),'r--')
    xlabel('gap');      ylabel('lift');
    legend('default lift(gap)','NP lift(gap)','SDP lift(gap)','lift(inf)',Location='best')
    
    figure("Name",'drag vs gap')
    title('wing-fuselage drag')
    hold on;    grid on;    axis padded;
    plot(tankGap , wingTank.default.dragVec);
    plot(tankGap , wingTank.NP.dragVec);
    plot(tankGap , wingTank.SDP.dragVec);
    yline(wing.dragVec(3),'r--')
    xlabel('gap');      ylabel('drag');
    legend('default drag(gap)','NP drag(gap)','SDP drag(gap)','drag(inf)',Location='best')

    % Convergence plots
    if plotFlag.convergence == true
        figure("Name",'Fz vs time')
        title('wing+fuselage $F_{z}$ default convergence')
        hold on;    grid on;    axis padded;
        plot(wingTank.wing.default.d25.time,  wingTank.wing.default.d25.Fz);
        plot(wingTank.wing.default.d50.time,  wingTank.wing.default.d50.Fz);
        plot(wingTank.wing.default.d75.time,  wingTank.wing.default.d75.Fz);
        plot(wingTank.wing.default.d100.time, wingTank.wing.default.d100.Fz);
        xlabel('$time$');      ylabel('$F_{z}$');
        legend('d=0.25','d=0.50','d=0.75','d=1.00')

        figure("Name",'Fz vs time')
        title('wing+fuselage $F_{z}$ NP convergence')
        hold on;    grid on;    axis padded;
        plot(wingTank.wing.NP.d25.time,  wingTank.wing.NP.d25.Fz);
        plot(wingTank.wing.NP.d50.time,  wingTank.wing.NP.d50.Fz);
        plot(wingTank.wing.NP.d75.time,  wingTank.wing.NP.d75.Fz);
        plot(wingTank.wing.NP.d100.time, wingTank.wing.NP.d100.Fz);
        xlabel('$time$');      ylabel('$F_{z}$');
        legend('d=0.25','d=0.50','d=0.75','d=1.00')

        figure("Name",'Fz vs time')
        title('wing+fuselage $F_{z}$ SDP convergence')
        hold on;    grid on;    axis padded;
        plot(wingTank.wing.SDP.d25.time,  wingTank.wing.SDP.d25.Fz);
        plot(wingTank.wing.SDP.d50.time,  wingTank.wing.SDP.d50.Fz);
        plot(wingTank.wing.SDP.d75.time,  wingTank.wing.SDP.d75.Fz);
        plot(wingTank.wing.SDP.d100.time, wingTank.wing.SDP.d100.Fz);
        xlabel('$time$');      ylabel('$F_{z}$');
        legend('d=0.25','d=0.50','d=0.75','d=1.00')

        figure("Name",'Fx vs time')
        title('wing+fuselage $F_{x}$ default convergence')
        hold on;    grid on;    axis padded;
        plot(wingTank.wing.default.d25.time,  wingTank.wing.default.d25.Fx);
        plot(wingTank.wing.default.d50.time,  wingTank.wing.default.d50.Fx);
        plot(wingTank.wing.default.d75.time,  wingTank.wing.default.d75.Fx);
        plot(wingTank.wing.default.d100.time, wingTank.wing.default.d100.Fx);
        xlabel('$time$');      ylabel('$F_{x}$');
        legend('d=0.25','d=0.50','d=0.75','d=1.00')

        figure("Name",'Fx vs time')
        title('wing+fuselage $F_{x}$ NP convergence')
        hold on;    grid on;    axis padded;
        plot(wingTank.wing.NP.d25.time,  wingTank.wing.NP.d25.Fx);
        plot(wingTank.wing.NP.d50.time,  wingTank.wing.NP.d50.Fx);
        plot(wingTank.wing.NP.d75.time,  wingTank.wing.NP.d75.Fx);
        plot(wingTank.wing.NP.d100.time, wingTank.wing.NP.d100.Fx);
        xlabel('$time$');      ylabel('$F_{x}$');
        legend('d=0.25','d=0.50','d=0.75','d=1.00')

        figure("Name",'Fx vs time')
        title('wing+fuselage $F_{x}$ SDP convergence')
        hold on;    grid on;    axis padded;
        plot(wingTank.wing.SDP.d25.time,  wingTank.wing.SDP.d25.Fx);
        plot(wingTank.wing.SDP.d50.time,  wingTank.wing.SDP.d50.Fx);
        plot(wingTank.wing.SDP.d75.time,  wingTank.wing.SDP.d75.Fx);
        plot(wingTank.wing.SDP.d100.time, wingTank.wing.SDP.d100.Fx);
        xlabel('$time$');      ylabel('$F_{x}$');
        legend('d=0.25','d=0.50','d=0.75','d=1.00')
    end
end


%% COMPARE

%%% Aerodynamic force plot
if plotFlag.compare == true
    figure("Name",'lift vs gap')
    title('wing-fuselage lift')
    hold on;    grid on;    axis padded;
    plot(compareGap(1:5) , wingFuselage.liftVec); 
    plot(compareGap(1:5) , wingTank.default.liftVec);
    plot(compareGap(1:5) , wingTank.NP.liftVec);
    plot(compareGap(1:5) , wingTank.SDP.liftVec);
    yline(wing.liftVec(3),'r--')
    xlabel('gap');      ylabel('L');
    legend('fuselage-wing L(gap)','tanks-wing default L(gap)','tanks-wing NP L(gap)','tanks-wing SDP L(gap)','wing L(inf)',Location='best')
    

    figure("Name",'drag vs gap')
    title('wing-fuselage drag')
    hold on;    grid on;    axis padded;
    plot(compareGap(1:5) , wingFuselage.dragVec); 
    plot(compareGap(1:5) , wingTank.default.dragVec);
    plot(compareGap(1:5) , wingTank.NP.dragVec);
    plot(compareGap(1:5) , wingTank.SDP.dragVec);
    yline(wing.dragVec(3),'r--')
    xlabel('gap');      ylabel('D');
    legend('fuselage-wing D(gap)','tanks-wing default D(gap)','tanks-wing NP D(gap)','tanks-wing SDP D(gap)','wing D(inf)',Location='best')
    
end

