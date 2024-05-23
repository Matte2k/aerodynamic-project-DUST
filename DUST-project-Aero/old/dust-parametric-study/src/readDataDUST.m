function [loadsTable] = readDataDUST(filepath,type)
%READ DATA DUST
%
%   Syntax:
%       [loadsTable] = readDataDUST(filepath,type)
%
%   Input:
%       filepath,   path:  path of the file.dat
%       type,     string:  type of the data file, choose between:
%                             -  integral_loads
%                             -  chordwise_loads
%
%   Output:
%       loadsTable,  table: data file imported
%

    switch type
        case 'integral_loads'
            loadsTable = readtable(filepath,NumHeaderLines = 4, ExpectedNumVariables = 7);
                loadsTable.Properties.VariableNames = {'time','Fx','Fy','Fz','Mx','My','Mz'};
    
        case 'chordwise_loads'
            warning('Option has not been implemented yet\n')
            return
            
        otherwise
            error('insert a valid analysis type');
    end

end