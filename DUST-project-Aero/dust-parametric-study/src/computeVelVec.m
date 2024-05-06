function [velVec,u_inf] = computeVelVec(alphaDeg,betaDeg,absVelocity,printFlag)
%COMPUTE VELOCITY VECTOR
%
%   Syntax:
%       [velVec,u_inf] = computeVelVec(alphaDeg,betaDeg,absVelocity,printFlag)
%
%   Input:
%       alphaDeg,     double:  angle of attack [deg]
%       betaDeg,      double:  angle of sideslip [deg]
%       absVelocity,  double:  velocity vector norm [m/s]
%       printFlag(*),   bool:  set graphic output
%   
%   Output:
%       velVec,  double[1,3]:  x,y,z component of velocity vector
%       u_inf,        string:  string to insert in dust.in
%
%   Default settings for optional input (*):
%       printFlag:  set to print the result in the command window
%
%   TO DEBUG SIDESLIP


    if nargin < 4
        printFlag = true;
    end
    
    alphaRad = deg2rad(alphaDeg);
    betaRad = deg2rad(betaDeg);
    
    u = cos(alphaRad) *  cos(betaRad) * absVelocity;
    v = cos(alphaRad) * -sin(betaRad) * absVelocity;
    w = sin(alphaRad) *                 absVelocity;
    
    velVec = [u v w];
    u_inf = sprintf('(/%.4f, %.4f, %.4f/)',u,v,w);
    
    if printFlag == true
        fprintf('INPUT:\n \t alpha = %.2f° \n \t beta = %.2f° \n \t absU = %.2f m/s\n\n',alphaDeg,betaDeg,absVelocity);
        fprintf('OUTPUT:\n\t u_inf = %s \n\n',u_inf);
    end

end
