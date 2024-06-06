function [inRefVars] = inRefInit(tag,origin,orientation)
%INPUT REFERENCE INITIALIZATOR - Write strings to set a static reference file for dust
%
%   Syntax:
%       [inRefVars] = inRefInit(tag,origin,orientation)
%
%   Input:
%       tag,               string: name of the reference tag to create
%       origin,       double[3,1]: origin coordinates with respect 0 reference
%       orientation,  double[3,3]: roation matrix for the reference
%
%   Output:
%       inRefVars,  cell:  contains all the strings that have to be printed in the
%                          reference file to build wing frame
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    if nargin < 3
        if nargin < 2
            origin = zeros(3,1);
        end
        orientation = eye(3);
    end

    reference_tag = sprintf('reference_tag = %s',tag);
    parent_tag =    sprintf('parent_tag = 0');
    origin =        sprintf('origin = (/%f, %f, %f/)',origin(1),origin(2),origin(3));
    orientation =   sprintf('orientation = (/%f,%f,%f, %f,%f,%f, %f,%f,%f/)', ...
                            orientation(1,1), orientation(1,2), orientation(1,3),   ... 
                            orientation(2,1), orientation(2,2), orientation(2,3),   ...
                            orientation(3,1), orientation(3,2), orientation(3,3)   );
    multiple =      sprintf('multiple = F');
    moving =        sprintf('moving = F');
    inRefVars = {reference_tag, parent_tag, origin, orientation, multiple, moving};

end