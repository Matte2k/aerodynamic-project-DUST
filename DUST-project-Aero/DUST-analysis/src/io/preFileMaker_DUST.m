function [customInputPath,modelFilePath] = preFileMaker_DUST(customVars,runName,presetPrePath,currentPath)
%PRE PROCESS FILE MAKER DUST - write custom variables in dust_pre.in
%
%   Syntax:
%       [customInputPath,modelFilePath] = preFileMaker_DUST(customVars,runName,presetPrePath,currentPath)
%
%   Input:
%       customVars,  string/cell:  strings that have to be written in dust_pre.in file
%       runName,          string:  name of the dust run added as prefix to dust_pre.in
%       presetPrePath(*),   path:  pre processing preset path
%       currentPath(*),     path:  current working path
%
%   Output:
%       customInputPath,  path: dust_pre.in file path
%       modelFilePath,    path: geo file in .h5 format path
%
%   Default settings for optional input (*):
%       presetPrePath: default preset path 'preset_inDustPre.in'
%       currentPath:   retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 4
        currentPath = pwd;
        if nargin < 3
            presetPrePath = sprintf('%s/input-DUST/preset/preset_inDustPre.in',currentPath);
        end
    end
    
    % import and write fixed variable file
    customInputPath = sprintf('%s/input-DUST/%s_inDustPre.in',currentPath,runName);
    
    copyfile(presetPrePath, customInputPath);
    inputFileHandle = fopen(customInputPath,"a");
    
    % model file definition
    modelFileName = sprintf('geo_%s',runName);    
    modelFilePath = sprintf('%s/input-DUST/%s.h5',currentPath,modelFileName);

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
    
            fprintf(inputFileHandle,'\n');        
            fprintf(inputFileHandle,'file_name = %s.h5',modelFileName);
            fprintf(inputFileHandle,'\n');   
    
    % save inDustPre.in
    fclose(inputFileHandle);

end