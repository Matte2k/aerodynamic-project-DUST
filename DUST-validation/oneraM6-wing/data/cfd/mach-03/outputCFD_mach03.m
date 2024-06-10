function [mach03] = outputCFD_mach03()
%OUTPUT CFD at MACH 0.3000
%
%   Syntax:
%       [mach03] = outputCFD_mach03()
%
%   Input:
%       []
%
%   Output:
%       mach03, struct: contains the following fields:
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
    mach03.ref.S   = 0.758602;
    mach03.ref.C   = 1;
    mach03.ref.rho = 1.22498;
    mach03.ref.P   = 12767;
    mach03.ref.v   = 102.089;
    
    % flow data
    mach03.flow.mach   = 0.3000;
    mach03.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
    
    % aerodynamic loads
    mach03.aero.Cl   = [-0.000511,     0.204073,    0.408614];
    mach03.aero.Cd   = [ 0.000776,     0.004439,    0.015526];
    mach03.aero.Cm   = [];     % to be calculated 
    
    % structural loads
    mach03.struct.Cfx  = [ 0.000776,    -0.006461,    -0.028125];
    mach03.struct.Cfy  = [ 0.005018,     0.011071,     0.029315];
    mach03.struct.Cfz  = [-0.000511,     0.204019,     0.407940];
    mach03.struct.Cmx  = [-0.000282,     0.108673,     0.217901];
    mach03.struct.Cmy  = [ 0.000189,    -0.045474,    -0.091464];
    mach03.struct.Cmz  = [ 0.003189,     0.009082,     0.026818];

end