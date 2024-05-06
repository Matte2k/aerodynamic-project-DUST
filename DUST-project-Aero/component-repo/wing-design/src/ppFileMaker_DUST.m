function [customInputPath,outputPath] = ppFileMaker_DUST(dataPath,runName,currentPath)
% INPUT:  outputDir_string, runName_string, (currentDir)
% OUTPUT: ppDir_string

    if nargin < 3
        currentPath = pwd;
    end
    
    % import and write fixed variable file
    presetInputPath = sprintf('%s/input-DUST/preset_inDustPost.in',currentPath);
    customInputPath = sprintf('%s/input-DUST/inDustPost_%s.in',currentPath,runName);
    
    copyfile(presetInputPath, customInputPath);
    inputFileHandle = fopen(customInputPath,"a");
    
    % write custom variable
    fprintf(inputFileHandle,'\n');
    fprintf(inputFileHandle,'data_basename = %s/run',dataPath);
    fprintf(inputFileHandle,'\n');
    fprintf(inputFileHandle,'basename = %s/pp-DUST/%s/pp',currentPath,runName);
    
    % save inDUST.in
    fclose(inputFileHandle);
    
    % make output directory
    outputPath = sprintf('%s/pp-DUST/%s',currentPath,runName);
    if ~exist(outputPath,'dir')
        mkdir(outputPath);
    end

end