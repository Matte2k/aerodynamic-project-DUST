function [tailInputPath] = tailFileMaker_DUST(customVars,tailName,tailSide,presetTailPath,currentPath)
%TAIL FILE MAKER DUST - write custom variables in tail.in
%
%   Syntax:
%       [tailInputPath] = tailFileMaker_DUST(customVars,tailName,tailSide,presetInputPath,currentPath)
%
%   Input:
%       customVars,  string/cell:  strings that have to be written in tail.in file
%       runName,          string:  name of the dust run added as prefix to tail.in
%       tailSide,           char:  'R' for right tail or 'L' for left tail
%       presetTailPath(*),  path:  tail preset path
%       currentPath(*),     path:  current working path
%
%   Output:
%       tailInputPath,  path: tail.in file path
%
%   Default settings for optional input (*):
%       presetTailPath: default preset path 'preset_inTail.in'
%       currentPath:    retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 5
        currentPath = pwd;
        if nargin < 4
            presetTailPath = sprintf('%s/input-DUST/geometry-data/preset_inTail.in',currentPath);
        end
    end

    % import and write fixed variable file
    switch tailSide
        case 'R'
            tailInputPath = sprintf('%s/input-DUST/geometry-data/tailRight_%s.in',currentPath,tailName);
        case 'L'
            tailInputPath = sprintf('%s/input-DUST/geometry-data/tailLeft_%s.in',currentPath,tailName);
        otherwise
            error('insert a valid tail sife: Left (L) or Right(R)')
    end
    
    copyfile(presetTailPath, tailInputPath);
    inputFileHandle = fopen(tailInputPath,"a");
    
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
    
    % save inRef.in
    fclose(inputFileHandle);

end