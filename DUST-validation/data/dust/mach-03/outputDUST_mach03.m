function [data] = outputDUST_mach03(dataPath)
%OUTPUT DUST at MACH 0.3000
%
%   Syntax:
%       [data] = outputDUST_mach03(dataPath)
%
%   Input:
%       dataPath(*),  path: path of the file containing designData of the DUST run
%
%   Output:
%       data, struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE:   the reference and flow values can be edited while, all the
%           data in this function has been reported automatic from:
%               > ./data/cfd/mach-03/oneraM6_mach03.mat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    if nargin < 1
        dataPath = './data/dust/mach-03/oneraM6_mach03.mat';
    end

    % reference values
    data.ref.S   = 0.758602;
    data.ref.C   = 1;
    data.ref.rho = 1.22498;
    data.ref.P   = 12767;
    data.ref.v   = 102.089;

    % panel method data
    data.mesh.chordElem = 20;
    data.mesh.spanElem  = 50;

    dustOutput = load(dataPath);
    [aeroLoads]    = aeroLoads_DUST   (dustOutput.designData, data.ref.v , data.ref.rho, data.ref.S, data.ref.C, false);
    [structLoads]  = structLoads_DUST (dustOutput.designData, data.ref.v , data.ref.rho, data.ref.S, data.ref.C, 'aoa', false);
    
    % flow data
    data.flow.mach   = 0.3000;
    data.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
   
    % structural loads
    data.struct.Cfx  = structLoads.Cfx;
    data.struct.Cfy  = structLoads.Cfy;
    data.struct.Cfz  = structLoads.Cfz;
    data.struct.Cmx  = structLoads.Cmx;
    data.struct.Cmy  = structLoads.Cmy;
    data.struct.Cmz  = structLoads.Cmz;
    
    % aerodynamic loads
    data.aero.Cl   = aeroLoads.Cl;
    data.aero.Cd   = aeroLoads.Cd;
    data.aero.Cm   = aeroLoads.Cm;

end

