function [] = deleteData(filePath,fileType,noDelete)
%DELETE DATA - delete data in the selected path
%
%   Syntax:
%       [] = deleteData(filePath,fileType,noDelete)
%
%   Input:
%       filePath,       path:  path where delete datas
%       fileType(*),  string:  extension of the file to delete     
%       noDelete(*),    cell:  contains name of the file to NOT delete
%
%   Output:
%       []
%
%   Default settings for optional input (*):
%       fileType: if no input the function remove all the subfolders in 'filePath'
%       noDelete: if no input every file will be deleted
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    % spot all the target file or delete the subfolders
    if nargin < 2
        fileList = dir(fullfile(filePath));
        count = numel(fileList);

        % subfolder delete loop
        for i = 3:count     % start from 3 to avoid '.' and '..' folders
            rmdir(fullfile(filePath,fileList(i).name),'s');
        end
        return
    else
        % spot file with 'fileType' extension
        fileExt  = sprintf('*.%s',fileType);
        fileList = dir(fullfile(filePath,fileExt));
        count = numel(fileList);
    end

    % delete loop
    if nargin < 3
        % delete files with 'fileType' extension
        for i = 1:count             
            delete(fullfile(filePath,fileList(i).name));
        end
    else
        % delete files avoiding the ones defined in 'noDelete'
        for i = 1:count             
            if ~any(strcmp(fileList(i).name,noDelete))
                delete(fullfile(filePath,fileList(i).name));
            end
        end
    end

end