function [Rtot] = rotationTensor(eulerAngleDeg)
%ROTATION TENSOR - compute rotation tensor from Euler angle
%
%   Syntax:
%       [Rtot] = rotationTensor(eulerAngleDeg)
%
%   Input:
%       eulerAngleDeg,   double[1,3]: angle for the Tait-Bryan sequence
%           eulerAngleDeg(1,1) --> rotation around z-axis
%           eulerAngleDeg(1,2) --> rotation around y-axis
%           eulerAngleDeg(1,3) --> rotation around x-axis
%   
%   Output:
%       Rtot,  double[3,3]:  rotation tensor for vector 3D rotations
%
%   Warning:    Remeber that in order to define the change of reference
%               system equivalent to the given Euler angle the 'Rtot'
%               tensor must be transpose!
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    %%% Euler Rot matrix
    % z cost, alpha ang
    alpha = deg2rad(eulerAngleDeg(1));
    R_alpha = [ cos(alpha)      -sin(alpha)    0 ; ...
                sin(alpha)      cos(alpha)     0 ; ...
                0               0              1 ];

    % y cost, beta ang
    beta = deg2rad(eulerAngleDeg(2));
    R_beta = [  cos(beta)       0      sin(beta) ; ...
                0               1      0 ; ...
                -sin(beta)      0      cos(beta) ];

    % x cost, gam ang
    gam = deg2rad(eulerAngleDeg(3));
    R_gam = [   1       0              0         ; ...
                0       cos(gam)       -sin(gam) ; ...
                0       sin(gam)       cos(gam) ];

    % rotation tensor merge
    Rtot = R_alpha * R_beta * R_gam;   % notation R_(0->c)

end