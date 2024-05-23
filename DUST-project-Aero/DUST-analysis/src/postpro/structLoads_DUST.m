function [structLoads] = structLoads_DUST(paramRunData,absVelocity,rhoInf,Sref,Cref,varName,plotFlag)
%STRUCTURAL LOADS DUST - Compute loads in body frame from a dust run
%
%   Syntax:
%       [structLoads] = structLoads_DUST(paramRunData,absVelocity,rhoInf,Sref,Cref,varName,plotFlag)
%
%   Input:
%       paramRunData,   cell:  output of organizeData_DUST.m
%       absVelocity,  double:  absolute value of wind velocity
%       rhoInf,       double:  reference air density used to adimensionalize 
%       Sref,         double:  reference surface used to adimensionalize 
%       Cref,         double:  reference chord used to adimensionalize
%       varName,      string:  name of the parametric variable that is changing
%       plotFlag(*)     bool:  flag to visualize or not Cz,Cx,Cm plots
%
%   Output:
%       aeroLoads,  struct:  contains all the structural loads computed. fields:
%                               - variable, coefficient that changes in the different runs
%                               - Fz, force on z-body frame
%                               - Fx, force on x-body frame
%                               - My, moment around y-body frame
%                               - Cz, adimensionalize z-force
%                               - Cx, adimensionalize x-force
%                               - Cm, adimensionalize y-moment
%
%   Default settings for optional input (*):
%       plotFlag:  set as true by default
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % Aerodynamic force computation
    structLoads = struct;
    for i = 1:size(paramRunData,1)
        structLoads.variable(i) = paramRunData{i,5};
        structLoads.Fz(i)  = paramRunData{i,1}.Fz(end);
        structLoads.Fx(i)  = paramRunData{i,1}.Fx(end);
        structLoads.My(i)  = paramRunData{i,1}.My(end);
    end

    structLoads.Cz = structLoads.Fz ./ (0.5* absVelocity^2 * rhoInf * Sref);
    structLoads.Cx = structLoads.Fx ./ (0.5* absVelocity^2 * rhoInf * Sref);
    structLoads.Cm = structLoads.My ./ (0.5* absVelocity^2 * rhoInf * Sref * Cref);


    % Aerodynamic force plot
    if plotFlag == true
        if isequal(varName,'aoa')   % write alpha pretty for aoa analysis
            varName = '$\alpha$';
        end
        xString = sprintf('$%s$',varName);

        figure("Name",'Cz vs variable')
        titleString = sprintf('$C_z$ vs %s',varName);
        title(titleString);
        hold on;    grid on;    axis padded;
        plot(structLoads.variable , structLoads.Cz);
        xlabel(xString);      ylabel('$C_z$');

        figure("Name",'Cx vs variable')
        titleString = sprintf('$C_x$ vs %s',varName);
        title(titleString);
        hold on;    grid on;    axis padded;
        plot(structLoads.variable , structLoads.Cx);
        xlabel(xString);      ylabel('$C_x$');

        figure("Name",'C_m vs variable')
        titleString = sprintf('$C_m$ vs %s',varName);
        title(titleString);
        hold on;    grid on;    axis padded;
        plot(structLoads.variable , structLoads.Cm);
        xlabel(xString);      ylabel('$C_m$');  

    end

end