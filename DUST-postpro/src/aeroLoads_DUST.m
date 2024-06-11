function [aeroLoads] = aeroLoads_DUST(paramRunData,absVelocity,rhoInf,Sref,Cref,plotFlag)
%AERO LOADS DUST - Compute loads in aero frame from a dust run
%
%   Syntax:
%       [aeroLoads] = aeroLoads_DUST(paramRunData,absVelocity,rhoInf,Sref,plotFlag)
%
%   Input:
%       paramRunData,   cell:  output of organizeData_DUST.m
%       absVelocity,  double:  absolute value of wind velocity 
%       rhoInf,       double:  reference air density used to adimensionalize
%       Sref,         double:  reference surface used to adimensionalize 
%       plotFlag(*)     bool:  flag to visualize or not polar,Cl,Cd plots
%
%   Output:
%       aeroLoads,  struct:  contains all the aerodynamic loads computed. fields:
%                               - variable, coefficient that changes in the different runs
%                               - aoaDeg, angle of attack in deg
%                               - aoaRad, angle of attack in rag
%                               - Fz, force on z-body frame
%                               - Fx, force on x-body frame
%                               - L, force on z-wind frame => lift
%                               - D, force on x-wind frame => drag
%                               - Cl, adimensionalize lift
%                               - Cd, adimensionalize drag
%
%   Default settings for optional input (*):
%       plotFlag:  set as true by default
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 5
        plotFlag = true;
    end

    % aerodynamic force computation
    aeroLoads = struct;
    for i = 1:size(paramRunData,1)      % loads data from paramRunData
        aeroLoads.variable(i) = paramRunData{i,5};
        aeroLoads.aoaDeg(i) = paramRunData{i,2};
        aeroLoads.Fz(i)  = paramRunData{i,1}.Fz(end);
        aeroLoads.Fx(i)  = paramRunData{i,1}.Fx(end);
        aeroLoads.My(i)  = paramRunData{i,1}.My(end);
    end
    aeroLoads.aoaRad = deg2rad(aeroLoads.aoaDeg);

    aeroLoads.L  = - aeroLoads.Fx.*sin(aeroLoads.aoaRad) + aeroLoads.Fz.*cos(aeroLoads.aoaRad);
    aeroLoads.D  =   aeroLoads.Fx.*cos(aeroLoads.aoaRad) + aeroLoads.Fz.*sin(aeroLoads.aoaRad);
    aeroLoads.Cl = aeroLoads.L ./ (0.5* absVelocity^2 * Sref * rhoInf);
    aeroLoads.Cd = aeroLoads.D ./ (0.5* absVelocity^2 * Sref * rhoInf);
    aeroLoads.Cm = aeroLoads.My./ (0.5* absVelocity^2 * Sref * Cref * rhoInf);

    % aerodynamic force plot
    if plotFlag == true
        figure("Name",'lift vs alpha')
        title('wing L vs $\alpha$')
        hold on;    grid on;    axis padded;
        plot(aeroLoads.aoaDeg , aeroLoads.Cl);
        xlabel('$\alpha$');      ylabel('$C_L$');

        figure("Name",'drag vs alpha')
        title('wing D vs $\alpha$')
        hold on;    grid on;    axis padded;
        plot(aeroLoads.aoaDeg , aeroLoads.Cd);
        xlabel('$\alpha$');      ylabel('$C_D$');

        figure("Name",'lift vs drag')
        title('wing polar')
        hold on;    grid on;    axis padded;
        plot(aeroLoads.Cd , aeroLoads.Cl);
        xlabel('$C_D$');      ylabel('$C_L$');  
    end

end