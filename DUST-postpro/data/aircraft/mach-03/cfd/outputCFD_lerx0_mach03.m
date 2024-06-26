function [data] = outputCFD_lerx0_mach03()
%OUTPUT CFD with LERX 0 at MACH 0.3000
%
%   Syntax:
%       [data] = outputCFD_lerx0_mach03()
%
%   Input:
%       []
%
%   Output:
%       data, struct: contains the following fields:
%                   - wing:     wing aerodynamic force and moment coefficient
%                   - tail:     tail aerodynamic force and moment coefficient 
%                   - fuselage: fuselage aerodynamic force and moment coefficient
%                   - lerx:     lerx aerodynamic force and moment coefficient
%
%   NOTE:   all the data in this function has been reported manually from:
%               > ./data/aircraft/mach-03/cfd/aoa0/lerx0_forces_breakdown.dat
%               > ./data/aircraft/mach-03/cfd/aoa5/lerx0_forces_breakdown.dat
%               > ./data/aircraft/mach-03/cfd/aoa10/lerx0_forces_breakdown.dat
%               > ./data/aircraft/mach-03/cfd/aoa15/lerx0_forces_breakdown.dat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%
       
    % wing loads
    data.wing.Cl  = [ 0.000000,     0.000000,     0.000000,     0.000000];
    data.wing.Cd  = [-0.000000,     0.000000,     0.000000,     0.000000];
    data.wing.Cm  = [-0.000000,    -0.000000,    -0.000000,     0.000000];
    
    % tail loads
    data.tail.Cl  = [ 0.000000,     0.000000,     0.000000,     0.000000];
    data.tail.Cd  = [-0.000000,     0.000000,     0.000000,     0.000000];
    data.tail.Cm  = [-0.000000,    -0.000000,    -0.000000,     0.000000];

    % aircraft loads
    data.total.Cl  = [ 0.000000,     0.000000,     0.000000,    0.000000];
    data.total.Cd  = [ 0.000000,     0.000000,     0.000000,    0.000000];
    data.total.Cm  = [-0.000000,    -0.000000,     0.000000,    0.000000];

    % fuselage loads
    data.fuselage.Cl  = data.total.Cl - (data.wing.Cl + data.tail.Cl);
    data.fuselage.Cd  = data.total.Cd - (data.wing.Cd + data.tail.Cd);
    data.fuselage.Cm  = data.total.Cm - (data.wing.Cm + data.tail.Cm);


end