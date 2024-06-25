function [data] = outputCFD_wing_mach02()
%OUTPUT CFD only WING at MACH 0.2000
%
%   Syntax:
%       [data] = outputCFD_wing_mach02()
%
%   Input:
%       []
%
%   Output:
%       data, struct: contains the following fields:
%                   - wing:     wing aerodynamic force and moment coefficient
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
    data.wing.Cl  = [ 0.061462,     0.000000,     0.264426];
    data.wing.Cd  = [ 0.000764,     0.000000,     0.015777];
    data.wing.Cm  = [-0.021703,     0.000000,    -0.075450];
    

end