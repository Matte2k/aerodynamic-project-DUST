function [vortexInputPath] = vortexFileMaker_DUST(customVars,runName,vortexSide,presetVortexPath,currentPath)
%VORTEX FILE MAKER DUST - write custom variables in vortex.in
%
%   Syntax:
%       [vortexInputPath] = vortexFileMaker_DUST(customVars,runName,vortexSide,presetVortexPath,currentPath)
%
%   Input:
%       customVars,    string/cell:  strings that have to be written in vortex.in file
%       runName,            string:  name of the dust run added as prefix to vortex.in
%       vortexSide,           char:  'R' for right wing or 'L' for left wing
%       presetVortexPath(*),  path:  vortex preset path
%       currentPath(*),       path:  current working path
%
%   Output:
%       vortexInputPath,  path: vortex.in file path
%
%   Default settings for optional input (*):
%       presetVortexPath: default preset path 'preset_inVortex.in'
%       currentPath:      retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 5
        currentPath = pwd;
        if nargin < 4
            presetVortexPath = sprintf('%s/input-DUST/geometry-data/preset_inVortex.in',currentPath);
        end
    end

    % import and write fixed variable file 
    switch vortexSide
        case 'R'
            vortexInputPath = sprintf('%s/input-DUST/geometry-data/vortexRight_%s.in',currentPath,runName);
        case 'L'
            vortexInputPath = sprintf('%s/input-DUST/geometry-data/vortexLeft_%s.in',currentPath,runName);
        otherwise
            error('insert a valid wing sife: Left (L) or Right(R)')
    end
    
    copyfile(presetVortexPath, vortexInputPath);
    inputFileHandle = fopen(vortexInputPath,"a");
    
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