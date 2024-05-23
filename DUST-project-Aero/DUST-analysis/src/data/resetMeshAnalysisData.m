function [] = resetMeshAnalysisData(analysisFolderPath,noWarning)
%RESET MESH ANALYSIS DATA - clear mesh analysis output data in memory
%
%   Syntax:
%       [] = resetMeshAnalysisData(analysisFolderPath,noWarning)
%   
%   Input:
%       analysisFolderPath, path:  sensitivity-mesh directory
%       noWarning(*),       bool:  disable warning
%
%   Output:
%       []
%
%   Default settings for optional input (*):
%       noWarning: warning locally suppressed by default
%
%   Directory to cleaned-up in sensitivity-box analysis:
%       ./..                            --> all .mat
%       ./output-DUST/..                --> all folders
%       ./pp-DUST/..                    --> all folders
%       ./input-DUST/..                 --> all .in and .h5 except:
%                                               - "inDustRef.in"
%
%                               Matteo Baio, Politecnico di Milano, 06/2024                                                          
%                                                           


    if nargin < 2 || noWarning == true
        warning('off');     % disable warning locally
    end
    
    % main folder
    filePath = analysisFolderPath;
    deleteData(filePath, 'mat');
    
    % pp-DUST
    filePath = sprintf('%s/pp-DUST/',analysisFolderPath);
    deleteData(filePath)
    
    % output-DUST
    filePath = sprintf('%s/output-DUST/',analysisFolderPath);
    deleteData(filePath)
    
    % input-DUST
    filePath = sprintf('%s/input-DUST/',analysisFolderPath);
    fileAvoid = {'inDustRef.in'};
    deleteData(filePath, 'in', fileAvoid);
    deleteData(filePath, 'h5');
    
    if nargin < 2 || noWarning == true
        warning('on');     % enable warning again
    end

end