function [timeElapsed] = exec_DUST(preFilePath,dustFilePath,ppFilePath)
%EXECUTE DUST - Execute in sequence dust_pre,dust and dust_post and measure cpu time to do it
%
%   Syntax:
%       [timeElapsed] = exec_DUST(preFilePath,dustFilePath,ppFilePath)
%
%   Input:
%       preFilePath,    path:  path of the dust_pre.in file
%       dustFilePath,   path:  path of the dust.in file     
%       ppFilePath,     path:  path of the dust_post.in file
%
%   Output:
%       timeElapsed,    double:  cpu time spent to execute the entire run
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    timeStart = tic;                % timer start

    dustPreCall = sprintf('dust_pre %s',preFilePath);
    system(dustPreCall);

    dustCall = sprintf('dust %s',dustFilePath);
    system(dustCall);

    dustPostCall = sprintf('dust_post %s',ppFilePath);
    system(dustPostCall);

    timeElapsed = toc(timeStart);   % timer end

end