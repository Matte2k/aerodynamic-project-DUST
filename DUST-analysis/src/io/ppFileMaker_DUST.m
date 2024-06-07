function [customInputPath,outputPath] = ppFileMaker_DUST(dataPath,runName,presetPostPath,currentPath)
%POST PROCESS FILE MAKER DUST - write custom variables in dust_post.in and make the post process directory
%
%   Syntax:
%       [customInputPath,outputPath] = ppFileMaker_DUST(dataPath,runName,presetPostPath,currentPath)
%
%   Input:
%       dataPath,          path:  output file path of dust
%       runName,         string:  name of the dust run added as prefix to dust_post.in and 
%                                 gave to the post process folder
%       presetPostPath(*), path:  post processing preset path
%       currentPath(*),    path:  current working path
%
%   Output:
%       customInputPath,  path: dust_post.in file path
%       outputPath,       path: output folder path
%
%   Default settings for optional input (*):
%       presetPostPath: default preset path 'preset_inDustPost.in'
%       currentPath:    retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 4
        currentPath = pwd;
        if nargin < 3
            presetPostPath = sprintf('%s/input-DUST/preset/preset_inDustPost.in',currentPath);
        end
    end
    
    % import and write fixed variable file
    customInputPath = sprintf('%s/input-DUST/%s_inDustPost.in',currentPath,runName);
    
    copyfile(presetPostPath, customInputPath);
    inputFileHandle = fopen(customInputPath,"a");
    
    % write custom variable
    fprintf(inputFileHandle,'data_basename = %s/run',dataPath);
    fprintf(inputFileHandle,'\n');
    fprintf(inputFileHandle,'basename = %s/pp-DUST/%s/pp',currentPath,runName);
    
    % save inDustPost.in
    fclose(inputFileHandle);
    
    % make output directory
    outputPath = sprintf('%s/pp-DUST/%s',currentPath,runName);
    if ~exist(outputPath,'dir')
        mkdir(outputPath);
    end

end