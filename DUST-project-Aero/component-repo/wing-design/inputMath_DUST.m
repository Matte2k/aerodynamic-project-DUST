%   
%       -- INPUT MATH for DUST simulation --
%   
%   Script built to retrive in MATLAB some datas usefull to setup some
%   DUST simulation. The output of this script must be used to write "dust.ini"
%   In this specific case the scrit compute:
%       - "u_inf" input given "AoA" and "sideslip"
%
%   Matteo Baio 
%

clearvars;  close all;  clc
addpath(genpath("src/"));
addpath(genpath("data-repo/"));

%% u_inf vector

alphaDeg = 20;
betaDeg  = 0;
absU = 50;

[speedVector,u_inf] = computeVelVec(alphaDeg,betaDeg,absU);


%% distance vector
%vector to change distance between two bodies


%% 

%%% input stlmesh
obj0 = stlread('untitled.stl');
mplot1 = trimesh(obj0);
mplot1.FaceColor = 'k';
mplot1.EdgeColor = 'b';
%mplot1.LineStyle = 'none';
hold on


