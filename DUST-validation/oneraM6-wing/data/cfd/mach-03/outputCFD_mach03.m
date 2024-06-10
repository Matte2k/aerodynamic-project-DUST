function [data] = outputCFD_mach03()
%OUTPUT CFD at MACH 0.3000
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
%               > ./data/cfd/mach-03/aoa0/forces_breakdown.dat
%               > ./data/cfd/mach-03/aoa3/forces_breakdown.dat
%               > ./data/cfd/mach-03/aoa6/forces_breakdown.dat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % reference values
    data.ref.S   = 0.758602;
    data.ref.C   = 1;
    data.ref.rho = 1.22498;
    data.ref.P   = 12767;
    data.ref.v   = 102.089;
    
    % flow data
    data.flow.mach   = 0.3000;
    data.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
       
    % structural loads
    data.struct.Cfx  = [ 0.000776,    -0.006461,    -0.028125];
    data.struct.Cfy  = [ 0.005018,     0.011071,     0.029315];
    data.struct.Cfz  = [-0.000511,     0.204019,     0.407940];
    data.struct.Cmx  = [-0.000282,     0.108673,     0.217901];
    data.struct.Cmy  = [ 0.000189,    -0.045474,    -0.091464];
    data.struct.Cmz  = [ 0.003189,     0.009082,     0.026818];

    % aerodynamic loads
    data.aero.Cl   = [-0.000511,     0.204073,    0.408614];
    data.aero.Cd   = [ 0.000776,     0.004439,    0.015526];
    data.aero.Cm   = data.struct.Cmy;

end