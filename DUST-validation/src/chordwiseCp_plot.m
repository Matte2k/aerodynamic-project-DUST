function [] = chordwiseCp_plot(mach,aoa,station,dataList)
%CHORDWISE CP PLOT - plot the comparison in Cp distribution between DUST,
%CFD and experimental results
%
%   Syntax:
%       [] = chordwiseCp_plot(mach,aoa,station,dataList)
%
%   Input:
%       mach,     string: mach condition of the run
%       aoa,      string: aoa condition of the run
%       station,  double: mark the station position
%       dataList,   cell: contains the name of the data type analyzed
%                         the possibilities are: 'dust','cfd','exp'
%
%   Output:
%       []
%
%   Data must be organized in the following format:
%       DUST:   "./data/dust/mach-XX/aoaXX/pp_pressure_XX_Cp.dat"
%       CFD:    "./data/cfd/mach-XX/aoaXX/stationXX.csv"
%       EXP:    "./data/exp/mach-XX/aoaXX/stationXX.dat"
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


%%% Plot
hold on;    grid minor;    axis padded;   box on;
xlabel('$$x/l$$')
ylabel('$$-C_p$$')
legString = cell(1,length(dataList));
i = 1;  % conter for legend string

%%% DUST result
if any(strcmp(dataList,'dust'))
    filepath_DUST = sprintf('./data/dust/mach-%s/aoa%s/pp_pressure_%.0f_Cp.dat',mach,aoa,station);
    cp_pp_DUST = readtable(filepath_DUST,CommentStyle='#',NumHeaderLines=3 ,ReadVariableNames=false);
    cp_pp_DUST = table2array(cp_pp_DUST);
        xZeroFix_DUST = (cp_pp_DUST(1,1:(end-1))-min(cp_pp_DUST(1,1:(end-1))));
        xRescale_DUST = (xZeroFix_DUST)./max(xZeroFix_DUST);
    plot(xRescale_DUST,-cp_pp_DUST(end,2:end))          % DUST
    legString{i}='DUST';        i=i+1;   
end

%%% CFD result
if any(strcmp(dataList,'cfd'))
    filepath_CFD = sprintf('./data/cfd/mach-%s/aoa%s/station%.0f.csv',mach,aoa,station);
    cp_pp_CFD = readtable(filepath_CFD,ReadVariableNames=false);
        xZeroFix_CFD = (cp_pp_CFD{1:end,13}-min(cp_pp_CFD{1:end,13}));
        xRescale_CFD = xZeroFix_CFD./max(xZeroFix_CFD);
    plot(xRescale_CFD,-cp_pp_CFD{1:end,8},'o')          % CFD
    legString{i}='CFD';        i=i+1;   
end

%%% EXPERIMENTAL result
if any(strcmp(dataList,'exp'))
    filepath_EXP = sprintf('./data/exp/mach-%s/aoa%s/station%.0f.dat',mach,aoa,station);
    cp_pp_EXP = readtable(filepath_EXP,CommentStyle='#',ReadVariableNames=false,ExpectedNumVariables=2);
    plot(cp_pp_EXP{1:end,1},-cp_pp_EXP{1:end,2})    % Wind tunnel
    legString{i}='Wind tunnel';   
end

legend(legString);  % legend display

end

