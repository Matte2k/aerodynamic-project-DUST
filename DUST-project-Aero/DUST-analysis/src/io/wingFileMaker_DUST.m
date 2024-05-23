function [wingInputPath] = wingFileMaker_DUST(customVars,wingName,wingSide,presetWingPath,currentPath)
%WING FILE MAKER DUST - write custom variables in wing.in
%
%   Syntax:
%       [wingInputPath] = wingFileMaker_DUST(customVars,wingName,wingSide,presetInputPath,currentPath)
%
%   Input:
%       customVars,  string/cell:  strings that have to be written in wing.in file
%       runName,          string:  name of the dust run added as prefix to wing.in
%       wingSide,           char:  'R' for right wing or 'L' for left wing
%       presetWingPath(*),  path:  wing preset path
%       currentPath(*),     path:  current working path
%
%   Output:
%       wingInputPath,  path: wing.in file path
%
%   Default settings for optional input (*):
%       presetWingPath: default preset path 'preset_inWing.in'
%       currentPath:    retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 5
        currentPath = pwd;
        if nargin < 4
            presetWingPath = sprintf('%s/input-DUST/geometry-data/preset_inWing.in',currentPath);
        end
    end

    % import and write fixed variable file
    switch wingSide
        case 'R'
            wingInputPath = sprintf('%s/input-DUST/geometry-data/wingRight_%s.in',currentPath,wingName);
        case 'L'
            wingInputPath = sprintf('%s/input-DUST/geometry-data/wingLeft_%s.in',currentPath,wingName);
        otherwise
            error('insert a valid wing sife: Left (L) or Right(R)')
    end
    
    copyfile(presetWingPath, wingInputPath);
    inputFileHandle = fopen(wingInputPath,"a");
    
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