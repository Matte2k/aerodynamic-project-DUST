function [customInputPath,outputPath] = inputFileMaker_DUST(customVars,runName,presetInputPath,currentPath)
%INPUT FILE MAKER DUST - write custom variables in dust.in and make the output directory
%
%   Syntax:
%       [customInputPath,outputPath] = inputFileMaker_DUST(customVars,runName,presetInputPath,currentPath)
%
%   Input:
%       customVars,         string/cell:  strings that have to be written in dust.in file
%       runName,            string:  name of the dust run added as prefix to dust.in and 
%                                    gave to the output folder
%       presetInputPath(*), path:  dust.in preset path
%       currentPath(*),     path:  current working path
%
%   Output:
%       customInputPath,  path: dust.in file path
%       outputPath,       path: output folder path
%
%   Default settings for optional input (*):
%       presetInputPath:  default preset path 'preset_inDust.in'
%       currentPath:      retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % default setting for optional input
    if nargin < 4
        currentPath = pwd;
        if nargin < 3
            presetInputPath = sprintf('%s/input-DUST/preset/preset_inDust.in',currentPath);
        end
    end
    
    % import and write fixed variable file
    customInputPath = sprintf('%s/input-DUST/%s_inDust.in',currentPath,runName);
    
    copyfile(presetInputPath, customInputPath);
    inputFileHandle = fopen(customInputPath,"a");
    
    % write custom variable
    fprintf(inputFileHandle,'\n');
    if iscell(customVars)
        for i = 1:size(customVars,2)
            fprintf(inputFileHandle,customVars{1,i});
            fprintf(inputFileHandle,'\n');
        end
    elseif ischar(customVars)
            fprintf(inputFileHandle,customVars);
            fprintf(inputFileHandle,'\n');
    end
    
    fprintf(inputFileHandle,'basename = %s/output-DUST/%s/run',currentPath,runName);
    
    % save inDUST.in
    fclose(inputFileHandle);
    
    % make output directory
    outputPath = sprintf('%s/output-DUST/%s',currentPath,runName);
    if ~exist(outputPath,'dir')
        mkdir(outputPath);
    end

end