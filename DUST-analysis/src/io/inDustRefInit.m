function [inDustVars] = inDustRefInit(PInf,rhoInf,aInf,muInf)
%INPUT DUST INITIALIZATOR - Write strings to set dust.in file
%
%   Syntax:
%       [inDustVars] = inDustRefInit(PInf,rhoInf,aInf,muInf)
%
%   Input:
%       PInf,   double:  reference value for static pressure [Cp]
%       rhoInf, double:  reference value for flow densitiy   [Re]
%       aInf,   double:  reference value for speed of sound  [Ma]
%       muInf,  double:  reference value for viscosity       [Re]
%
%   Output:
%       inDustVars,  cell:  contains all the strings that have to be printed
%                           in the dust.in file to define reference values
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin < 4 || isempty(muInf)
        mu_inf = sprintf('! use default mu_inf');
    else
        mu_inf = sprintf('mu_inf = %f',muInf);
    end

    if nargin < 3 || isempty(aInf)
        a_inf = sprintf('! use default a_inf');
    else
        a_inf = sprintf('a_inf = %f',aInf);
    end

    if nargin < 2 || isempty(rhoInf)
        rho_inf = sprintf('! use default rho_inf');
    else
        rho_inf = sprintf('rho_inf = %f',rhoInf);
    end

    if nargin < 1 || isempty(PInf)
        P_inf = sprintf('! use default P_inf');
    else
        P_inf = sprintf('P_inf = %f',PInf);
    end


    inDustVars = {P_inf, rho_inf, a_inf, mu_inf};

end