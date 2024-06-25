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
%               > ./data/lerx/cfd/aoa2/lerx0_forces_breakdown.dat
%               > ./data/lerx/cfd/aoa5/lerx0_forces_breakdown.dat
%               > ./data/lerx/cfd/aoa10/lerx0_forces_breakdown.dat
%           The current reference system directions are:
%                   CURRENT REFERENCE: x-backward, y-right, z-up
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%
       
    % wing loads
    data.wing.Cl  = [ 0.000000,     0.000000,     0.000000];
    data.wing.Cd  = [ 0.000000,     0.000000,     0.000000];
    data.wing.Cm  = [ 0.000000,     0.000000,     0.000000];
    

end