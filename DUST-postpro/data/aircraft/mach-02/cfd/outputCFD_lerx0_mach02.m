function [data] = outputCFD_lerx0_mach02()
%OUTPUT CFD with LERX 0 at MACH 0.2000
%
%   Syntax:
%       [data] = outputCFD_lerx0_mach02()
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
%               > ./data/aircraft/mach-02/cfd/aoa2/lerx0_forces_breakdown.dat
%               > ./data/aircraft/mach-02/cfd/aoa5/lerx0_forces_breakdown.dat
%               > ./data/aircraft/mach-02/cfd/aoa10/lerx0_forces_breakdown.dat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%
       
    % wing loads
    data.wing.Cl  = [ 0.067533,     0.169897,     0.310936];
    data.wing.Cd  = [-0.000083,     0.001359,     0.010084];
    data.wing.Cm  = [-0.008005,    -0.014227,    -0.021572];
    
    % tail loads
    data.tail.Cl  = [ 0.018708,     0.026453,     0.034118];
    data.tail.Cd  = [-0.000637,     0.000056,     0.002276];
    data.tail.Cm  = [-0.029362,    -0.041833,    -0.055195];

    % aircraft loads
    data.total.Cl  = [ 0.138024,     0.314857,     0.575878];
    data.total.Cd  = [ 0.008464,     0.017246,     0.051987];
    data.total.Cm  = [-0.048451,    -0.026988,     0.031444];

    % fuselage loads
    data.fuselage.Cl  = data.total.Cl - (data.wing.Cl + data.tail.Cl);
    data.fuselage.Cd  = data.total.Cd - (data.wing.Cd + data.tail.Cd);
    data.fuselage.Cm  = data.total.Cm - (data.wing.Cm + data.tail.Cm);

    % data at 5 and 10 deg is computed with the free-stream condition not
    % at 0 altitude

end