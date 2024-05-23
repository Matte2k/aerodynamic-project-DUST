function [customInputPath] = refFileMaker_DUST(customVars,runName,presetRefPath,currentPath)
%REFERENCE FILE MAKER DUST - write custom variables in reference.in
%
%   Syntax:
%       [customInputPath] = refFileMaker_DUST(customVars,runName,presetRefPath,currentPath)
%
%   Input:
%       customVars,  string/cell:  strings that have to be written in reference.in file
%       runName,          string:  name of the dust run added as prefix to reference.in
%       presetRefPath(*),   path:  reference preset path
%       currentPath(*),     path:  current working path
%
%   Output:
%       customInputPath,  path: reference.in file path
%
%   Default settings for optional input (*):
%       presetRefPath: default preset path 'preset_inDustRef.in'
%       currentPath:   retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%
    

    % default setting for optional input
    if nargin < 4
        currentPath = pwd;
        if nargin < 3
            presetRefPath = sprintf('%s/input-DUST/preset/preset_inDustRef.in',currentPath);
        end
    end
    
    % import and write fixed variable file
    customInputPath = sprintf('%s/input-DUST/%s_inDustRef.in',currentPath,runName);
    
    copyfile(presetRefPath, customInputPath);
    inputFileHandle = fopen(customInputPath,"a");
    
    % write custom variable
    if iscell(customVars)
        for i = 1:size(customVars,2)
            fprintf(inputFileHandle,customVars{1,i});
            fprintf(inputFileHandle,'\n');
        end
    elseif ischar(customVars)
            fprintf(inputFileHandle,customVars);
            fprintf(inputFileHandle,'\n');
    end
    
    % save inDustRef.in
    fclose(inputFileHandle);

end