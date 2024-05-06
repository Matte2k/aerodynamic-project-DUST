addpath(genpath("./"));
clearvars;  close all;  clc

[wing.a5 ] = readDataDUST('post_loads_full.dat' ,'integral_loads');
%[wing.a5 ] = readDataDUST('fineMesh_panel.dat' ,'integral_loads');


% Angle considered
alphaDeg = 5;
alphaRad = deg2rad(alphaDeg);

% Force
FzVec = [wing.a5.Fz(end)];
FxVec = [wing.a5.Fx(end)];
liftVec = - FxVec.*sin(alphaRad) + FzVec.*cos(alphaRad);
dragVec =   FxVec.*cos(alphaRad) + FzVec.*sin(alphaRad);

% Aerodynamic coeff.
cl = liftVec / (0.5*1.225*10*10^2);
cd = dragVec / (0.5*1.225*10*10^2);

cz = FzVec / (0.5*1.225*10*10^2);
cx = FxVec / (0.5*1.225*10*10^2);