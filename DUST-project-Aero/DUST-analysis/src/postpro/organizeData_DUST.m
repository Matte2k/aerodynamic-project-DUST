function [paramRunData] = organizeData_DUST(dataFolderName,aoaDegVec,variableVec,variableName,timeCostVec,plotFlag)
%ORGANIZE DATA DUST - Read and organize post process data of dust parametric symulations
%
%   Syntax:
%       [paramRunData] = organizeData_DUST(dataFolderName,aoaDegVec,variableVec,variableName,timeCostVec,plotFlag)
%
%   Input:
%       
%       dataFolderName,   cell:  folder name where to find pp_loads.dat file  
%       aoaDegVec,      double:  angle of attack used in the simulation
%       variableVec,    double:  value of the parametric input used
%       variableName,   string:  name of the parameters that changes in the simulations
%       timeCostVec,    dobule:  cpu time cost to run DUST with current parameters
%       plotFlag(*)       bool:  flag to visualize or not convergence plots
%
%   Output:
%       paramRunData,   cell:  on the differt columns contains:
%                               1) integral loads table imported using readDataDUST.m
%                               2) angle of attack in deg used to obtain that result
%                               3) type of analysis present in column n°1
%                               4) type of parametric analysis performed
%                               5) value of the parametric input used to obtain results in column n°1
%                               6) cpu time elapsed to obtain results in column n°1
%
%   Default settings for optional input (*):
%       plotFlag:  set as true by default
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    % Default setting for optional input
    if nargin < 6
        plotFlag = true;
    end

    % Write alpha pretty for aoa analysis
    if isequal(variableName,'aoa')   
        variableName = '$\alpha$';
    end

    % Data import
    analysisType = 'integral_loads';
    paramRunData = cell(size(variableVec,1),5);
    legendCell   = cell(size(variableVec,1),1);
    for i = 1:size(variableVec,1)

        dataPath = sprintf('pp-DUST/%s/pp_loads.dat',dataFolderName{i});
        dataType = sprintf('%s',analysisType);
        
        paramRunData{i,1} = readDataDUST(dataPath,dataType);
        paramRunData{i,2} = aoaDegVec(i);
        paramRunData{i,3} = dataType;
        paramRunData{i,4} = dataFolderName{i};
        paramRunData{i,5} = variableVec(i);
        paramRunData{i,6} = timeCostVec(i);

        legendCell{i} = sprintf('%s = %.0f',variableName,variableVec(i));

    end

        % Convergence plots
        if plotFlag == true
            figure("Name",'Fz vs time')
            title('wing $F_{z}$ convergence')
            hold on;    grid on;    axis padded;
            for i = 1:size(variableVec,1)
                plot(paramRunData{i,1}.time , paramRunData{i,1}.Fz); 
            end
            xlabel('$time$');       ylabel('$F_{z}$');
            legend(legendCell)

            figure("Name",'Fx vs time')
            title('wing $F_{x}$ convergence')
            hold on;    grid on;    axis padded;
            for i = 1:size(variableVec,1)
                plot(paramRunData{i,1}.time , paramRunData{i,1}.Fz);
            end
            xlabel('$time$');      ylabel('$F_{x}$');
            legend(legendCell)
        end

end