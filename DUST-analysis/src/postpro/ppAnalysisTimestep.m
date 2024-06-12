function [ppAnalysisCell] = ppAnalysisTimestep(ppAnalysisList,tstepRunName)
%POST PROCESSING ANALYSIS for TIMESTEP - Build the cell containing the different post processing preset
%for the timestep sensitivity analysis
%
%   Syntax:
%       [ppAnalysisCell] = ppAnalysisTimestep(ppAnalysisList,tstepRunName)
%
%   Input:
%       analysisList,      cell:  cell containing the id name of the different analysis to be performed
%       tstepRunName,    double:  id number of the different time step run performed
%
%   Output:
%       ppAnalysisCell,   cell:  cell containing in the i-row all the analysis preset to be performed
%                                one the tstepRunName(i)
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    ppAnalysisCell = cell(size(tstepRunName,1),length(ppAnalysisList));

    for i = 1:size(tstepRunName,1)
        for j = 1:length(ppAnalysisList)
            ppAnalysisCell{i,j} = sprintf('%s_tstep%.0f',ppAnalysisList{j},tstepRunName(i));
        end
    end


end