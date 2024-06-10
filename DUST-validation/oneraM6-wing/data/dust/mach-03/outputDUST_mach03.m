function [mach03] = outputDUST_mach03(dataPath)
%OUTPUT DUST at MACH 0.3000
%
%   Syntax:
%       [mach03] = outputDUST_mach03(dataPath)
%
%   Input:
%       dataPath(*),  path: path of the file containing designData of the DUST run
%
%   Output:
%       mach03, struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE:   the reference and flow values can be edited while, all the
%           data in this function has been reported automatic from:
%               > ./data/cfd/mach-03/onerM6_mach03.mat
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    if nargin < 1
        dataPath = './data/dust/mach-03/oneraM6_mach03.mat';
    end

    % reference values
    mach03.ref.S   = 0.758602;
    mach03.ref.C   = 1;
    mach03.ref.rho = 1.22498;
    mach03.ref.P   = 12767;
    mach03.ref.v   = 102.089;

    data = load(dataPath);
    [aeroLoads]    = aeroLoads_DUST   (data.designData, mach03.ref.v , mach03.ref.rho, mach03.ref.S, mach03.ref.C, false);
    [structLoads]  = structLoads_DUST (data.designData, mach03.ref.v , mach03.ref.rho, mach03.ref.S, mach03.ref.C, 'aoa', false);
    
    % flow data
    mach03.flow.mach   = 0.3000;
    mach03.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];

    % aerodynamic loads
    mach03.aero.Cl   = aeroLoads.Cl;
    mach03.aero.Cd   = aeroLoads.Cd;
    mach03.aero.Cm   = aeroLoads.Cm;
    
    % structural loads
    mach03.struct.Cfx  = structLoads.Cfx;
    mach03.struct.Cfy  = structLoads.Cfy;
    mach03.struct.Cfz  = structLoads.Cfz;
    mach03.struct.Cmx  = structLoads.Cmx;
    mach03.struct.Cmy  = structLoads.Cmy;
    mach03.struct.Cmz  = structLoads.Cmz;

end

