function [customInputPath,outputPath] = ppFileMaker_DUST(dataPath,runName,analysisList,presetPostPath,currentPath)
%POST PROCESS FILE MAKER DUST - write custom variables in dust_post.in and make the post process directory
%
%   Syntax:
%       [customInputPath,outputPath] = ppFileMaker_DUST(dataPath,runName,analysisList,presetPostPath,currentPath)
%
%   Input:
%       dataPath,          path:  output file path of dust
%       runName,         string:  name of the dust run added as prefix to dust_post.in and 
%                                 gave to the post process folder
%       analysisList,      cell:  cell containing the id name of the different analysis to performe
%       presetPostPath(*), path:  post processing preset path for analysis
%       currentPath(*),    path:  current working path
%
%   Output:
%       customInputPath,  path: dust_post.in file path
%       outputPath,       path: output folder path
%
%   Default settings for optional input (*):
%       presetPostPath: default preset path 'preset_inDustPost.in'
%       currentPath:    retrived by this function
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % default setting for optional input
    if nargin < 5
        currentPath = pwd;
        if nargin < 4
            presetPostPath = sprintf('%s/input-DUST/preset/postAnalysis',currentPath);
        end
    end
    
    % import and write fixed variable file
    customInputPath = sprintf('%s/input-DUST/%s_inDustPost.in',currentPath,runName);
    
    % read all the analysis preset available
    analysisPresetFolder = dir(presetPostPath);
    count = numel(analysisPresetFolder);
    analysisPresetList = cell(count-2,1);
    for j=3:count
        analysisPresetList{j-2} = analysisPresetFolder(j).name;
    end

    % write in dustPost.in the selected analysis
    for i=1:length(analysisList)
        analysisNameCmp = sprintf('%s.in',analysisList{i});
        if any(strcmp(analysisNameCmp,analysisPresetList))
            preset = sprintf('%s/%s.in',presetPostPath,analysisList{i});
            f1 = fileread(preset);
            [fid,msg] = fopen(customInputPath,'at');
            assert(fid>=3,msg)
            fprintf(fid,'\n\n%s',f1);
            fclose(fid);
        end
    end
    
    % write custom variable
    inputFileHandle = fopen(customInputPath,"a");
    fprintf(inputFileHandle,'\ndata_basename = %s/run',dataPath);
    fprintf(inputFileHandle,'\n');
    fprintf(inputFileHandle,'basename = %s/pp-DUST/%s/pp',currentPath,runName);
    
    % save inDustPost.in
    fclose(inputFileHandle);
    
    % make output directory
    outputPath = sprintf('%s/pp-DUST/%s',currentPath,runName);
    if ~exist(outputPath,'dir')
        mkdir(outputPath);
    end

end