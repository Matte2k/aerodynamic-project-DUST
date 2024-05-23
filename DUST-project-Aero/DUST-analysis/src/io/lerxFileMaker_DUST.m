function [lerxInputPath] = lerxFileMaker_DUST(customVars,runName,lerxSide,presetLerxPath,currentPath)
%LERX FILE MAKER DUST - write custom variables in lerx.in
%
%   Syntax:
%       [lerxInputPath] = lerxFileMaker_DUST(customVars,runName,lerxSide,currentPath)
%
%   Input:
%       customVars,  string/cell:  strings that have to be written in lerx.in file
%       runName,          string:  name of the dust run added as prefix to lerx.in
%       lerxSide,           char:  'R' for right wing or 'L' for left wing
%       presetLerxPath(*),  path:  lerx preset path
%       currentPath(*),     path:  current working path
%
%   Output:
%       lerxInputPath,  path: lerx.in file path
%
%   Default settings for optional input (*):
%       presetLerxPath: default preset path 'preset_inLerx.in'
%       currentPath:    retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 5
        currentPath = pwd;
        if nargin < 4
            presetLerxPath = sprintf('%s/input-DUST/geometry-data/preset_inLerx.in',currentPath);
        end
    end

    % import and write fixed variable file 
    switch lerxSide
        case 'R'
            lerxInputPath = sprintf('%s/input-DUST/geometry-data/lerxRight_%s.in',currentPath,runName);
        case 'L'
            lerxInputPath = sprintf('%s/input-DUST/geometry-data/lerxLeft_%s.in',currentPath,runName);
        otherwise
            error('insert a valid wing sife: Left (L) or Right(R)')
    end
    
    copyfile(presetLerxPath, lerxInputPath);
    inputFileHandle = fopen(lerxInputPath,"a");
    
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