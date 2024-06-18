function [data] = outputCFD_mach08()
%OUTPUT CFD at MACH 0.8395
%
%   Syntax:
%       [data] = outputCFD_mach03()
%
%   Input:
%       []
%
%   Output:
%       data, struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE:   all the data in this function has been reported manually from:
%               > ./data/cfd/mach-08/aoa0/forces_breakdown.dat
%               > ./data/cfd/mach-08/aoa3/forces_breakdown.dat
%               > ./data/cfd/mach-08/aoa6/forces_breakdown.dat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % reference values
    data.ref.S   = 0.758602;
    data.ref.C   = 1;
    data.ref.rho = 1.22498;
    data.ref.P   = 99973.8;
    data.ref.v   = 285.679;
    
    % flow data
    data.flow.mach   = 0.8395;
    data.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
       
    % structural loads
    data.struct.Cfx  = [ 0.001287,    -0.003164,    -0.006635];
    data.struct.Cfy  = [ 0.007988,     0.015081,     0.027429];
    data.struct.Cfz  = [-0.000173,     0.286407,     0.592404];
    data.struct.Cmx  = [-0.000142,     0.150505,     0.313784];
    data.struct.Cmy  = [ 0.000056,    -0.063465,    -0.144624];
    data.struct.Cmz  = [ 0.007600,     0.014071,     0.022321];

    % aerodynamic loads
    data.aero.Cl   = [-0.000173,     0.286167,    0.589735];
    data.aero.Cd   = [ 0.001287,     0.012130,    0.056560];
    data.aero.Cm   = data.struct.Cmy;

end