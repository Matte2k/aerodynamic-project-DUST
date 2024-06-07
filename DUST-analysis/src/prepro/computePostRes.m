function [start_res,end_res] = computePostRes(stepName,timestep,tlimit,printFlag)
%COMPUTE POST RESOLUTION - compute time settings of dust_post.in
%
%   Syntax:
%       [start_res,end_res] = computePostRes(stepName,timestep,tlimit,printFlag)
%
%   Input:
%       stepName,    dobule:  symbolic name given to the DUST run with 'timestep' parameter
%       timestep,    double:  value of dt and dt_out of the DUST run
%       tlimit, double[2,1]:  limit time value of the simulation
%                                   tlimit(1) = time start
%                                   tlimit(2) = time end
%       printFlag(*),   bool:  set graphic output
%   
%   Output:
%       start_res,  double:  start_res value in dust_post.in
%       end_res,    double:  end_res value in dust_post.in
%
%   Default settings for optional input (*):
%       printFlag:  set to print the result in the command window
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 4
        printFlag = true;
    end
    
    
    end_res   = (tlimit(2) - tlimit(1) ) / timestep + 1;
    start_res = tlimit(1);
    if printFlag == true
        fprintf('for time step %.2f set "preset_inDustPost_%.0f.in" with:\n',timestep,stepName);
        fprintf('\t start_res = %.2f \n',   tlimit(1));
        fprintf('\t end_res = %.2f \n\n',   end_res);
    end

end