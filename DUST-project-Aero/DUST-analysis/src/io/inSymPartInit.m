function [inSymPartVars] = inSymPartInit(nelem_chord,yMirrorPoint,partSide)
%INPUT SYMMETRIC PART INITIALIZATOR - Write strings to set a symmetric geometric part for dust
%
%   Syntax:
%       [inSymPartVars] = inSymPartInit(nelem_chord,yMirrorPoint,partSide)
%
%   Input:
%       nelem_chord,  double: number of panel chordwise
%       yMirrorPoint, double: y-axis distance between wing and fuselage
%       partSide,       char: 'R' for right wing preset or 'L' for left wing preset
%
%   Output:
%       inSymPartVars,  cell:  contains all the strings that have to be printed in the
%                              component file (ex. rightWing.in)
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    nelem_chord   = sprintf('nelem_chord = %.0f',nelem_chord);
    
    switch partSide
        case 'R'
            inSymPartVars = nelem_chord;
        case 'L'
            mesh_mirror   = sprintf('mesh_mirror = T');
            mirror_point  = sprintf('mirror_point = (/0.0,-%f,0.0/)',yMirrorPoint);
            mirror_normal = sprintf('mirror_normal = (/0.0,1.0,0.0/)');
            inSymPartVars = {mesh_mirror, mirror_point, mirror_normal, nelem_chord};
        otherwise
            error('insert a valid wing side: Left (L) or Right(R)')
    end

end