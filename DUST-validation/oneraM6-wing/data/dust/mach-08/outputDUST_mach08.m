function [mach08] = outputDUST_mach08(dataPath)
%OUTPUT DUST at MACH 0.3000
%
%   Syntax:
%       [mach03] = outputDUST_mach03(dataPath)
%
%   Input:
%       dataPath(*),  path: path of the file containing designData of the DUST run
%
%   Output:
%       mach08, struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE:   the reference and flow values can be edited while, all the
%           data in this function has been reported automatic from:
%               > ./data/cfd/mach-08/onerM6_mach08.mat
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    if nargin < 1
        dataPath = './data/dust/mach-08/oneraM6_mach08.mat';
    end

    % reference values
    mach08.ref.S   = 0.758602;
    mach08.ref.C   = 1;
    mach08.ref.rho = 1.22498;
    mach08.ref.P   = 99973.8;
    mach08.ref.v   = 285.679;
    
    data = load(dataPath);
    [aeroLoads]    = aeroLoads_DUST   (data.designData, mach08.ref.v , mach08.ref.rho, mach08.ref.S, mach08.ref.C, false);
    [structLoads]  = structLoads_DUST (data.designData, mach08.ref.v , mach08.ref.rho, mach08.ref.S, mach08.ref.C, 'aoa', false);

    % flow data
    mach08.flow.mach   = 0.8395;
    mach08.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];

    % aerodynamic loads
    mach08.aero.Cl   = aeroLoads.Cl;
    mach08.aero.Cd   = aeroLoads.Cd;
    mach08.aero.Cm   = aeroLoads.Cm;
    
    % structural loads
    mach08.struct.Cfx  = structLoads.Cfx;
    mach08.struct.Cfy  = structLoads.Cfy;
    mach08.struct.Cfz  = structLoads.Cfz;
    mach08.struct.Cmx  = structLoads.Cmx;
    mach08.struct.Cmy  = structLoads.Cmy;
    mach08.struct.Cmz  = structLoads.Cmz;

end
