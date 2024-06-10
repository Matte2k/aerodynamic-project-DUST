function [data] = outputAVL_mach03()
%OUTPUT AVL at MACH 0.3000
%
%   Syntax:
%       [data] = outputAVL_mach03()
%
%   Input:
%       []
%
%   Output:
%       data,   struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE: all the data in this function has been reported manually from:
%           > ./data/cfd/mach-03/aoa0/forces_breakdown.dat
%           > ./data/cfd/mach-03/aoa3/forces_breakdown.dat
%           > ./data/cfd/mach-03/aoa6/forces_breakdown.dat
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % reference values
    data.ref.S   = 0.7586;
    data.ref.C   = 1;
    data.ref.rho = 1.22498;
    data.ref.P   = [];
    data.ref.v   = 102.089;
    
    % flow data
    data.flow.mach   = 0.3000;
    data.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
    
    % aerodynamic loads
    data.aero.Cl   = [-0.000000,     0.204073,    0.408614];
    data.aero.Cd   = [ 0.000000,     0.004439,    0.015526];
    data.aero.Cm   = [];     % to be calculated 
    
    
end