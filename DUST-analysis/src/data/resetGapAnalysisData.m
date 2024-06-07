function [] = resetGapAnalysisData(analysisFolderPath,noWarning)
%RESET GAP ANALYSIS DATA - clear gap analysis output data in memory
%
%   Syntax:
%       [] = resetGapAnalysisData(analysisFolderPath,noWarning)
%   
%   Input:
%       analysisFolderPath, path:  sensitivity-gap directory
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
%       ./input-DUST/..                 --> all .in and .h5
%       ./input-DUST/geometry-data/..   --> all .in except:
%                                               - "fuselage.in"
%                                               - "preset_inWing.in"
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
    deleteData(filePath, 'in');
    deleteData(filePath, 'h5');
    
    % geometry-data
    filePath  = sprintf('%s/input-DUST/geometry-data',analysisFolderPath);
    fileAvoid = {'fuselage.in','preset_inWing.in'};
    deleteData(filePath, 'in', fileAvoid);
    
    if nargin < 2 || noWarning == true
        warning('on');     % enable warning again
    end

end