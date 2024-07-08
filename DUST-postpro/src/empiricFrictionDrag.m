function [Cd0] = empiricFrictionDrag(mach,sweep,Swet,Sref,Cref)
%EMPIRIC FRICTION DRAG - estimate friction drag of a Lerx with a
%semiempiric formula
%
%   Syntax:
%       [Cd0] = empiricFrictionDrag(mach,sweep,Swet,Sref,Cref)
%

    Qc = 1;
    k = 0.5e-5;
    tc = 0.05;
    xc = 1;
    
    if mach < 0.6 && mach > 0
        R = 38.21 * (Cref/k)^(1.053);
    elseif mach > 0.6
        R = 44.62 * (Cref/k)^(1.053) * mach^(1.16);
    else
        error('insert a valid mach number');
    end

    Cf = 0.455 / ( log10(R)^(2.58) * (1 + 0.144 * mach^2)^(0.65) );

    FF = ( 1 + (0.6/xc)*tc + 100*tc^4 ) * ( 1.34 * mach^(0.18) * cos(deg2rad(sweep))^(0.28) );

    Cd0 = (Cf * FF * Qc * Swet) / Sref;

end