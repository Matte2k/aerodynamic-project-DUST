function [data] = outputCFD_wing_mach03()
%OUTPUT CFD only WING at MACH 0.3000
%
%   Syntax:
%       [data] = outputCFD_wing_mach03()
%
%   Input:
%       []
%
%   Output:
%       data, struct: contains the following fields:
%                   - wing:     wing aerodynamic force and moment coefficient
%
%   NOTE:   all the data in this function has been reported manually from:
%               > ./data/wing/mach-03/cfd/aoa0/forces_breakdown.dat
%               > ./data/wing/mach-03/cfd/aoa5/forces_breakdown.dat
%               > ./data/wing/mach-03/cfd/aoa10/forces_breakdown.dat
%               > ./data/wing/mach-03/cfd/aoa10/forces_breakdown.dat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%
       
    % wing loads
    data.wing.Cl  = [ 0.000000,     0.000000,     0.000000,     0.00000];
    data.wing.Cd  = [ 0.000000,     0.000000,     0.000000,     0.00000];
    data.wing.Cm  = [-0.000000,    -0.000000,    -0.000000,     0.00000];
    

end