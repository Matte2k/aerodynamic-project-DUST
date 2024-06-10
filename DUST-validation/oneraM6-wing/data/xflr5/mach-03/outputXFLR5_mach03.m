function [data] = outputXFLR5_mach03()
%OUTPUT AVL at MACH 0.3000
%
%   Syntax:
%       [data] = outputXFLR5_mach03()
%
%   Input:
%       []
%
%   Output:
%       data, struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - mesh:   meshing data of the model
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE:   all the data in this function has been reported manually from:
%               > ./data/xflr5/mach-03/load_panel.dat
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % reference values
    data.ref.S   = 0.758602;
    data.ref.C   = 1;       % or 0.645... To be verified
    data.ref.rho = 1.22498;
    data.ref.P   = [];
    data.ref.v   = 102.089;

    % vlm method data
    data.mesh.chordElem = 20;
    data.mesh.spanElem  = 50;
    
    % flow data
    data.flow.mach   = 0.3000;
    data.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
       
    % structural loads
    data.struct.Cfx  = [];
    data.struct.Cfy  = [];
    data.struct.Cfz  = [];
    data.struct.Cmx  = [];
    data.struct.Cmy  = [];
    data.struct.Cmz  = [];

    % aerodynamic loads
    data.aero.Cl   = [ 0.000000,     0.388616,    0.774090] ./ 2;
    data.aero.Cd   = [ 0.000000,     0.006374,    0.025315] ./ 2;
    data.aero.Cm   = [ 0.000000,    -0.281032,   -0.557845] ./ 2;

end