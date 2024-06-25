function [wing,tail,fuselage,lerx]=dataParser_DUST(alphaDegVec,analysisName,variableName,reference,components)
%DATA PARSER DUST - Parser for integral loads data of different geometry component
%
%   Syntax:
%       [wing,tail,fuselage,lerx]=dataParser_DUST(alphaDegVec,analysisName,variableName,reference,lerxPart)
%
%   Input:      
%       aoaDegVec,      double:  angle of attack used in the simulation
%       analysisName,   string:  name of the analysis performed
%       variableName,   string:  name of the variable changing in different run
%       reference,      struct:  see description of 'runReferenceValue.m'   
%       components(*)   struct:  struct defining the component to consider:
%                                   - wing,     bool
%                                   - tail,     bool
%                                   - lerx,     bool
%                                   - fuselage, bool
%
%   Output:
%       wing,     struct: the fields contains:
%                           - designData, row loads data
%                           - aeroLoads, post processed aerodynamic laods
%                           - structLoads, post processed structural loads
%       tail,     struct:  same as 'wing'
%       fuselage, struct:  same as 'wing'
%       lerx,     struct:  same as 'wing'
%
%   Default settings for optional input (*):
%       lerxPart:  set as false by default
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

    if nargin < 5
        components.wing = true;
        components.tail = true;
        components.lerx = true;
        components.fuselage = true;
    end

    absVelocity  = reference.absVelocity;
    rhoInf       = reference.rhoInf;
    Sref         = reference.Sref;
    Cref         = reference.Cref;
    timeCostVec  = zeros(size(alphaDegVec,1),1);
    alphaNameVec = 1:size(alphaDegVec,1);

    runNameCell   = cell(size(alphaDegVec,1),1);         % run name cell initialization
    wingDataPath  = cell(size(alphaDegVec,1),1);         % wing data path cell initialization
    tailDataPath  = cell(size(alphaDegVec,1),1);         % tail data path cell initialization
    lerxDataPath  = cell(size(alphaDegVec,1),1);         % lerx data path cell initialization
    fuselageDataPath = cell(size(alphaDegVec,1),1);      % fuselage data path cell initialization
    
    for i = 1:size(alphaDegVec,1)
        runNameCell{i}  = sprintf('%s%.0f',variableName,alphaNameVec(i));            % parametric run name definition
        wingDataPath{i} = sprintf('data/%s/dust/%s/pp_loadsWing.dat',analysisName,runNameCell{i});
        tailDataPath{i} = sprintf('data/%s/dust/%s/pp_loadsTail.dat',analysisName,runNameCell{i});
        lerxDataPath{i} = sprintf('data/%s/dust/%s/pp_loadsLerx.dat',analysisName,runNameCell{i});
        fuselageDataPath{i} = sprintf('data/%s/dust/%s/pp_loadsFuselage.dat',analysisName,runNameCell{i});
    end
        
    
    % Postprocessing of the dust output
    if components.wing == true
    wing = struct;
        [wing.designData]   = organizeData_DUST(wingDataPath, alphaDegVec, alphaDegVec, variableName, timeCostVec, false);
        [wing.aeroLoads]    = aeroLoads_DUST   (wing.designData, absVelocity, rhoInf, Sref, Cref, false);
        [wing.structLoads]  = structLoads_DUST (wing.designData, absVelocity, rhoInf, Sref, Cref, variableName, false);
    end
    
    if components.tail == true
    tail = struct;
        [tail.designData]   = organizeData_DUST(tailDataPath, alphaDegVec, alphaDegVec, variableName, timeCostVec, false);
        [tail.aeroLoads]    = aeroLoads_DUST   (tail.designData, absVelocity, rhoInf, Sref, Cref, false);
        [tail.structLoads]  = structLoads_DUST (tail.designData, absVelocity, rhoInf, Sref, Cref, variableName, false);
    end
    
    if components.fuselage == true
    fuselage = struct;
        [fuselage.designData]   = organizeData_DUST(fuselageDataPath, alphaDegVec, alphaDegVec, variableName, timeCostVec, false);
        [fuselage.aeroLoads]    = aeroLoads_DUST   (fuselage.designData, absVelocity, rhoInf, Sref, Cref, false);
        [fuselage.structLoads]  = structLoads_DUST (fuselage.designData, absVelocity, rhoInf, Sref, Cref, variableName, false);
    end
    
    if components.lerx == true
    lerx = struct;
        [lerx.designData]   = organizeData_DUST(lerxDataPath, alphaDegVec, alphaDegVec, variableName, timeCostVec, false);
        [lerx.aeroLoads]    = aeroLoads_DUST   (lerx.designData, absVelocity, rhoInf, Sref, Cref, false);
        [lerx.structLoads]  = structLoads_DUST (lerx.designData, absVelocity, rhoInf, Sref, Cref, variableName, false);
    end

end

