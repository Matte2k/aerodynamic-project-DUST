function [wakeBox_min,wakeBox_max] = computeWakeBox(xBoxLimit,yBoxLimit,zBoxLimit)
%COMPUTE WAKE BOX - compute and write the string to set the Dust wake box
%
%   Syntax:
%       [wakeBox_min,wakeBox_max] = computeWakeBox(xBoxLimit,yBoxLimit,zBoxLimit)
%
%   Input:
%       xBoxLimit,  double:  define x-coordinate of the particles box
%                            can be both a scalar or a vector with two elements
%                               - scalar: sets particles box symmetrically
%                               - vector: sets particles box asymmetrically,
%                                           xBoxLimit(1) = particles box min value
%                                           xBoxLimit(2) = particles box max value
%       yBoxLimit,  double:  same as xBoxLimit but operate on y-coordinate
%       zBoxLimit,  double:  same as xBoxLimit but operate on z-coordinate
%
%   Output:
%       wakeBox_min,  string: text to write in Dust.in file for 'particles_box_min'
%       wakeBox_max,  string: text to write in Dust.in file for 'particles_box_max'
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if length(xBoxLimit) == 1
        xBoxLimit = [-xBoxLimit xBoxLimit];
    elseif length(xBoxLimit) > 2
        error('x coordinates input is incorrect... see function help')
    end

    if length(yBoxLimit) == 1
        yBoxLimit = [-yBoxLimit yBoxLimit];
    elseif length(yBoxLimit) > 2
        error('y coordinates input is incorrect... see function help')
    end

    if length(zBoxLimit) == 1
        zBoxLimit = [-zBoxLimit zBoxLimit];
    elseif length(zBoxLimit) > 2
        error('z coordinates input is incorrect... see function help')
    end


    wakeBox_min = sprintf('particles_box_min = (/%f,%f,%f/)',xBoxLimit(1),yBoxLimit(1),zBoxLimit(1));
    wakeBox_max = sprintf('particles_box_max = (/%f,%f,%f/)',xBoxLimit(2),yBoxLimit(2),zBoxLimit(2)); 

end