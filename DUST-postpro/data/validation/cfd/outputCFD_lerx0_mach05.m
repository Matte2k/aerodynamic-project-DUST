function [data] = outputCFD_lerx0_mach05()
%OUTPUT CFD with LERX 0 at MACH 0.5000
%
%   Syntax:
%       [data] = outputCFD_lerx0_mach05()
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
%               > ./data/lerx/cfd/aoa2/lerx0_forces_breakdown.dat
%               > ./data/lerx/cfd/aoa5/lerx0_forces_breakdown.dat
%               > ./data/lerx/cfd/aoa10/lerx0_forces_breakdown.dat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%
       
    % wing loads
    data.wing.Cl  = [ 0.000000,     0.179898,     0.282631];
    data.wing.Cd  = [ 0.000000,     0.001790,     0.031391];
    data.wing.Cm  = [ 0.000000,    -0.015473,    -0.009213];
    
    % tail loads
    data.tail.Cl  = [ 0.000000,     0.021264,     0.027360];
    data.tail.Cd  = [ 0.000000,    -0.000027,     0.002028];
    data.tail.Cm  = [ 0.000000,    -0.033363,    -0.043526];

    % aircraft loads
    data.total.Cl  = [ 0.000000,     0.319120,     0.542844];
    data.total.Cd  = [ 0.000000,     0.060039,     0.112898];
    data.total.Cm  = [ 0.000000,    -0.004596,     0.074728];

    % fuselage loads
    data.fuselage.Cl  = data.total.Cl - (data.wing.Cl + data.tail.Cl);
    data.fuselage.Cd  = data.total.Cd - (data.wing.Cd + data.tail.Cd);
    data.fuselage.Cm  = data.total.Cm - (data.wing.Cm + data.tail.Cm);

end