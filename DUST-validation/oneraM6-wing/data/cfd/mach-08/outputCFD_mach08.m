function [mach08] = outputCFD_mach08()
%OUTPUT CFD at MACH 0.8395
%
%   Syntax:
%       [mach08] = outputCFD_mach03()
%
%   Input:
%       []
%
%   Output:
%       mach08, struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE: all the data in this function has been reported manually from:
%           > ./data/cfd/mach-08/aoa0/forces_breakdown.dat
%           > ./data/cfd/mach-08/aoa3/forces_breakdown.dat
%           > ./data/cfd/mach-08/aoa6/forces_breakdown.dat
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % reference values
    mach08.ref.S   = 0.758602;
    mach08.ref.C   = 1;
    mach08.ref.rho = 1.22498;
    mach08.ref.P   = 99973.8;
    mach08.ref.v   = 285.679;
    
    % flow data
    mach08.flow.mach   = 0.8395;
    mach08.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
    
    % aerodynamic loads
    mach08.aero.Cl   = [-0.000173,     0.286167,    0.589735];
    mach08.aero.Cd   = [ 0.001287,     0.012130,    0.056560];
    mach08.aero.Cm   = [];     % to be calculated 
    
    % structural loads
    mach08.struct.Cfx  = [ 0.001287,    -0.003164,    -0.006635];
    mach08.struct.Cfy  = [ 0.007988,     0.015081,     0.027429];
    mach08.struct.Cfz  = [-0.000173,     0.286407,     0.592404];
    mach08.struct.Cmx  = [-0.000142,     0.150505,     0.313784];
    mach08.struct.Cmy  = [ 0.000056,    -0.063465,    -0.144624];
    mach08.struct.Cmz  = [ 0.007600,     0.014071,     0.022321];

end