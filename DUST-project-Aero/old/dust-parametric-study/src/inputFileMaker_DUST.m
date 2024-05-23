function [customInputPath,outputPath] = inputFileMaker_DUST(customVars,runName,currentPath)
% INPUT:  customVar_string/cell, runName_string, (currentDir)
% OUTPUT: outputDir_string

    if nargin < 3
        currentPath = pwd;
    end
    
    % import and write fixed variable file
    presetInputPath = sprintf('%s/input-DUST/preset_inDust.in',currentPath);
    customInputPath = sprintf('%s/input-DUST/inDust_%s.in',currentPath,runName);
    
    copyfile(presetInputPath, customInputPath);
    inputFileHandle = fopen(customInputPath,"a");
    
    % write custom variable
    fprintf(inputFileHandle,'\n');
    for i = 1:size(customVars,2)
        fprintf(inputFileHandle,customVars{1,i});
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