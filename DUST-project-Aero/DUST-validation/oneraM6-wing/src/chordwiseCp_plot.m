function [] = chordwiseCp_plot(mach,aoa,station)
%CHORDWISE CP PLOT - plot the comparison in Cp distribution between DUST
%and CFD results
%
%   Syntax:
%       [] = chordwiseCp_plot(mach,aoa,station)
%
%   Input:
%       mach,     string: mach condition of the run
%       aoa,      string: aoa condition of the run
%       station,  double: mark the station position
%
%   Output:
%       []
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

%%% DUST result
filepath_DUST = sprintf('./DUST/mach-%s/aoa%s/pp_pressure_%.0f_Cp.dat',mach,aoa,station);
cp_pp_DUST = readtable(filepath_DUST,CommentStyle='#',NumHeaderLines=3 ,ReadVariableNames=false);
cp_pp_DUST = table2array(cp_pp_DUST);

%%% CFD result            
filepath_CFD = sprintf('./CFD/mach-%s/aoa%s/station%.0f.csv',mach,aoa,station);
cp_pp_CFD = readtable(filepath_CFD,ReadVariableNames=false);

%%% Plot
hold on;    grid on;    axis padded;
plot(cp_pp_DUST(1,1:(end-1)),-cp_pp_DUST(end,2:end))    % DUST
plot(cp_pp_CFD{1:end,13},-cp_pp_CFD{1:end,8},'o')       % CFD
legend('DUST','CFD')                                    % 
xlabel('$$x/l$$')
ylabel('$$-C_p$$')

end

