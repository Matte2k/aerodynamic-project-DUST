function [component] = meanAeroLoadsCorrector(component,reference,meanIdxStart,meanIdxEnd)
%MEAN AERODYNAMIC LOADS CORRECTOR - correct the aerodynamic loads of a
%component in case of unsteady behavior
%
%   Syntax:
%       [component] = meanAeroLoadsCorrector(component,reference,meanIdx)
%
%   Input:      
%       component,     struct: the fields contains:
%                           - designData, row loads data
%                           - aeroLoads, post processed aerodynamic laods
%                           - structLoads, post processed structural loadst
%       reference,      struct:  see description of 'runReferenceValue.m'   
%       meanIdxStart,   double:  starting index to compute mean
%       meanIdxEnd,     double:  ending index to compute mean
%
%   Output:
%       component, struct:  same as the input
%
%   Default settings for optional input (*):
%       meanIdxEnd:  set as end of the simulation data by default
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin < 4
        meanIdxEnd = size(component.designData{1,1},1);
    end

    % mean aerodynamic force computation from 'meanIdxStart' position untill 'meanIdxEnd'
    for i = 1:size(component.designData,1)
        component.aeroLoads.Fz(i)  = mean(component.designData{i,1}.Fz(meanIdxStart:meanIdxEnd));
        component.aeroLoads.Fx(i)  = mean(component.designData{i,1}.Fx(meanIdxStart:meanIdxEnd));
        component.aeroLoads.My(i)  = mean(component.designData{i,1}.My(meanIdxStart:meanIdxEnd));
    end
    
    % overwrite old 'aerodynamic loads' with the new 'mean aerodynamnic loads'
    component.aeroLoads.L  = - component.aeroLoads.Fx.*sin(component.aeroLoads.aoaRad) + component.aeroLoads.Fz.*cos(component.aeroLoads.aoaRad);
    component.aeroLoads.D  =   component.aeroLoads.Fx.*cos(component.aeroLoads.aoaRad) + component.aeroLoads.Fz.*sin(component.aeroLoads.aoaRad);
    component.aeroLoads.Cl = component.aeroLoads.L ./ (0.5* reference.absVelocity^2 * reference.Sref * reference.rhoInf);
    component.aeroLoads.Cd = component.aeroLoads.D ./ (0.5* reference.absVelocity^2 * reference.Sref * reference.rhoInf);
    component.aeroLoads.Cm = component.aeroLoads.My./ (0.5* reference.absVelocity^2 * reference.Sref * reference.Cref * reference.rhoInf);

end