function [loadsTable] = readDataDUST(filepath,type)
%READ DATA DUST - read post process file of a Dust_post run
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
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    switch type
        case 'integral_loads'
            loadsTable = readtable(filepath,CommentStyle='#', ExpectedNumVariables = 7,ReadVariableNames=false);
                loadsTable.Properties.VariableNames = {'time','Fx','Fy','Fz','Mx','My','Mz'};
    
        case 'chordwise_loads'
            warning('Option has not been implemented yet\n')
            return
            
        otherwise
            error('insert a valid analysis type');
    end

end