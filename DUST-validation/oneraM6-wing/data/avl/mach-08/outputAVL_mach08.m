function [data] = outputAVL_mach08()
%OUTPUT AVL at MACH 0.8395
%
%   Syntax:
%       [data] = outputAVL_mach08()
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
%               > ./data/avl/mach-08/aoa0/load_vlm.dat
%               > ./data/avl/mach-08/aoa3/load_vlm.dat
%               > ./data/avl/mach-08/aoa6/load_vlm.dat
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
    data.ref.v   = 285.679;

    % vlm method data
    data.mesh.chordElem = 20;
    data.mesh.spanElem  = 50;
    
    % flow data
    data.flow.mach   = 0.8395;
    data.flow.aoaDeg = [ 0.000000,     3.060000,    6.120000];
       
    % structural loads
    data.struct.Cfx  = [ 0.000000,    -0.016000,    -0.063840] ./ 2;
    data.struct.Cfy  = [ 0.000000,     0.000000,     0.000000] ./ 2;
    data.struct.Cfz  = [ 0.000000,     0.476620,     0.947810] ./ 2;
    data.struct.Cmx  = [];  % AVL data consider both semi-wing so is zero
    data.struct.Cmy  = [ 0.000000,    -0.219840,    -0.437180] ./ 2;
    data.struct.Cmz  = [];  % AVL data consider both semi-wing so is zero

    % aerodynamic loads
    data.aero.Cl   = [ 0.000000,     0.476800,    0.949210] ./ 2;
    data.aero.Cd   = [ 0.000000,     0.009460,    0.037580] ./ 2;
    data.aero.Cm   = data.struct.Cmy;

end