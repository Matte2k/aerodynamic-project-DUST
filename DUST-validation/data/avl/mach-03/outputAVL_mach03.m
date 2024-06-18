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
%       data, struct: contains the following fields:
%                   - ref:    reference value used to compute loads
%                   - mesh:   meshing data of the model
%                   - flow:   free stream condition
%                   - aero:   aerodynamic force and moment coefficient
%                   - struct: structural force and moment coefficient
%
%   NOTE:   all the data in this function has been reported manually from:
%               > ./data/avl/mach-03/aoa0/load_vlm.dat
%               > ./data/avl/mach-03/aoa3/load_vlm.dat
%               > ./data/avl/mach-03/aoa6/load_vlm.dat
%           The data in these file some force coefficient has the sign
%           flipped due to the different reference system used by AVL:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%                   AVL REFERENCE:     x-forward,  y-right, z-down
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % reference values
    data.ref.S   = 0.758602;
    data.ref.C   = 1;
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
    data.struct.Cfx  = [ 0.000000,    -0.014260,    -0.056880] ./ 2;
    data.struct.Cfy  = [ 0.000000,     0.000000,     0.000000] ./ 2;
    data.struct.Cfz  = [ 0.000000,     0.380210,     0.756080] ./ 2;
    data.struct.Cmx  = [];  % AVL data consider both semi-wing so is zero
    data.struct.Cmy  = [ 0.000000,    -0.175780,    -0.349550] ./ 2;
    data.struct.Cmz  = [];  % AVL data consider both semi-wing so is zero

    % aerodynamic loads
    data.aero.Cl   = [ 0.000000,     0.380430,    0.757830] ./ 2;
    data.aero.Cd   = [ 0.000000,     0.006050,    0.024050] ./ 2;
    data.aero.Cm   = data.struct.Cmy;

end