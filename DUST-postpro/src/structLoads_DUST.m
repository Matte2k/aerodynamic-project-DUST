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
%       plotFlag(*)     bool:  flag to visualize or not Cfz,Cfx,Cmy plots
%
%   Output:
%       aeroLoads,  struct:  contains all the structural loads computed. fields:
%                               - variable, coefficient that changes in the different runs
%                               - Fi, force on i-body frame
%                               - Mi, moment around i-body frame
%                               - Cfi, adimensionalize i-force
%                               - Cmi, adimensionalize i-moment
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
        structLoads.Fx(i)  = paramRunData{i,1}.Fx(end);
        structLoads.Fy(i)  = paramRunData{i,1}.Fy(end);
        structLoads.Fz(i)  = paramRunData{i,1}.Fz(end);
        structLoads.Mx(i)  = paramRunData{i,1}.Mx(end);
        structLoads.My(i)  = paramRunData{i,1}.My(end);
        structLoads.Mz(i)  = paramRunData{i,1}.Mz(end);
    end

    structLoads.Cfx = structLoads.Fx ./ (0.5* absVelocity^2 * rhoInf * Sref);
    structLoads.Cfy = structLoads.Fy ./ (0.5* absVelocity^2 * rhoInf * Sref);
    structLoads.Cfz = structLoads.Fz ./ (0.5* absVelocity^2 * rhoInf * Sref);
    structLoads.Cmx = structLoads.Mx ./ (0.5* absVelocity^2 * rhoInf * Sref * Cref);
    structLoads.Cmy = structLoads.My ./ (0.5* absVelocity^2 * rhoInf * Sref * Cref);
    structLoads.Cmz = structLoads.Mz ./ (0.5* absVelocity^2 * rhoInf * Sref * Cref);


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
        plot(structLoads.variable , structLoads.Cfz);
        xlabel(xString);      ylabel('$C_z$');

        figure("Name",'Cx vs variable')
        titleString = sprintf('$C_x$ vs %s',varName);
        title(titleString);
        hold on;    grid on;    axis padded;
        plot(structLoads.variable , structLoads.Cfx);
        xlabel(xString);      ylabel('$C_x$');

        figure("Name",'C_m vs variable')
        titleString = sprintf('$C_m$ vs %s',varName);
        title(titleString);
        hold on;    grid on;    axis padded;
        plot(structLoads.variable , structLoads.Cmy);
        xlabel(xString);      ylabel('$C_m$');  

    end

end