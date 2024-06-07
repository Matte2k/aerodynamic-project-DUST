function [inDustTimeVars] = inDustTimeInit(timestep,tlimit)
%INPUT DUST TIMING INITIALIZATOR - Write strings to set timings in dust.in file
%
%   Syntax:
%       [inDustTimeVars] = inDustTimeInit(timestep,tlimit)
%
%   Input:
%       timestep,    double:  value of the dt and dt_out of the DUST run
%       tlimit, double[2,1]:  limit time value of the simulation
%                                   tlimit(1) = time start
%                                   tlimit(2) = time end
%
%   Output:
%       inDustTimeVars,  cell:  contains all the strings that have to be printed
%                               in the dust.in file to define reference values
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    tstart = sprintf('tstart = %f',tlimit(1));
    tend   = sprintf('tend = %f',tlimit(2));
    dt_out = sprintf('dt_out = %f',timestep);
    dt = sprintf('dt = %f',timestep);
    output_start = sprintf('output_start = T');

    inDustTimeVars = {tstart, tend, dt, dt_out, output_start};

end