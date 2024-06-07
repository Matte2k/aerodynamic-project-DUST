function [inSymPartVars] = inSymPartInit(nelem_chord,mirrorPoint,mirrorNormal,partSide)
%INPUT SYMMETRIC PART INITIALIZATOR - Write strings to set a symmetric geometric part for dust
%
%   Syntax:
%       [inSymPartVars] = inSymPartInit(nelem_chord,mirrorPoint,mirrorNormal,partSide)
%
%   Input:
%       nelem_chord,       double: number of panel chordwise
%       mirrorPoint,  double(1,3): xyz-axis distance between wing and fuselage in local reference
%       mirrorNormal, double(1,3): xyz-axis normal vector of the plane of symmetry in local reference
%       partSide,            char: 'R' for right wing preset or 'L' for left wing preset
%
%   Output:
%       inSymPartVars,  cell:  contains all the strings that have to be printed in the
%                              component file (ex. rightWing.in)
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    if isempty(nelem_chord)
        nelem_chord = sprintf('! nelem_chord already set');
    else
        nelem_chord   = sprintf('nelem_chord = %.0f',nelem_chord);
    end

    switch partSide
        case 'R'
            inSymPartVars = nelem_chord;
        case 'L'
            mesh_mirror   = sprintf('mesh_mirror = T');
            mirror_point  = sprintf('mirror_point = (/%f,%f,%f/)',mirrorPoint(1),mirrorPoint(2),mirrorPoint(3));
            mirror_normal = sprintf('mirror_normal = (/%f,%f,%f/)',mirrorNormal(1),mirrorNormal(2),mirrorNormal(3));
            inSymPartVars = {mesh_mirror, mirror_point, mirror_normal, nelem_chord};
        otherwise
            error('insert a valid wing side: Left (L) or Right(R)')
    end

end