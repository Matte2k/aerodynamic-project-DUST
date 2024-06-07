function [fuselageInputPath] = fuselageFileMaker_DUST(customVars,fuselageName,fuselageSide,presetFuselagePath,currentPath)
%FUSELAGE FILE MAKER DUST - write custom variables in fuselage.in
%
%   Syntax:
%       [fuselageInputPath] = fuselageFileMaker_DUST(customVars,fuselageName,fuselageSide,presetFuselagePath,currentPath)
%
%   Input:
%       customVars,      string/cell:  strings that have to be written in fuselage.in file
%       fuselageName,         string:  name of the dust run added as prefix to fuselage.in
%       fuselageSide,           char:  'R' for right fuselage or 'L' for left fuselage
%       presetFuselagePath(*),  path:  fuselage preset path
%       currentPath(*),         path:  current working path
%
%   Output:
%       fuselageInputPath,  path: fuselage.in file path
%
%   Default settings for optional input (*):
%       presetfuselagePath: default preset path 'preset_inFuselage.in'
%       currentPath:        retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 5
        currentPath = pwd;
        if nargin < 4
            presetFuselagePath = sprintf('%s/input-DUST/geometry-data/preset_inFuselage.in',currentPath);
        end
    end

    % import and write fixed variable file
    switch fuselageSide
        case 'R'
            fuselageInputPath = sprintf('%s/input-DUST/geometry-data/fuselageRight_%s.in',currentPath,fuselageName);
        case 'L'
            fuselageInputPath = sprintf('%s/input-DUST/geometry-data/fuselageLeft_%s.in',currentPath,fuselageName);
        otherwise
            error('insert a valid fuselage sife: Left (L) or Right (R)')
    end
    
    copyfile(presetFuselagePath, fuselageInputPath);
    inputFileHandle = fopen(fuselageInputPath,"a");
    
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