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
    data.wing.Cl  = [-0.003152,     0.171823,     0.290477,     0.375101];
    data.wing.Cd  = [-0.000114,     0.001460,     0.014556,     0.074349];
    data.wing.Cm  = [-0.004047,    -0.014340,    -0.011826,    -0.012848];
    
    % tail loads
    data.tail.Cl  = [ 0.010453,     0.025147,     0.033559,     0.021093];
    data.tail.Cd  = [-0.000764,     0.000018,     0.002325,     0.003053];
    data.tail.Cm  = [-0.016228,    -0.039707,    -0.054124,    -0.034999];

    % aircraft loads
    data.total.Cl  = [ 0.009241,     0.314153,     0.554947,    0.751879];
    data.total.Cd  = [ 0.005138,     0.015760,     0.055497,    0.161089];
    data.total.Cm  = [-0.047970,    -0.022706,     0.040015,    NaN     ];

    % fuselage loads
    data.fuselage.Cl  = data.total.Cl - (data.wing.Cl + data.tail.Cl);
    data.fuselage.Cd  = data.total.Cd - (data.wing.Cd + data.tail.Cd);
    data.fuselage.Cm  = data.total.Cm - (data.wing.Cm + data.tail.Cm);


end