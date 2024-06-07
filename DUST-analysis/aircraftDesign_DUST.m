%  
%       -- AIRCRAFT DESIGN for DUST simulation --
% 
%   Script built to compute in MATLAB a different DUST run on various wing,
%   lerx/canard and vortex (to modelize the leading edge vortex form lerx)
%   The analysis parameters can be modified using the INPUT section of this file.
%   Only some particular DUST settings can be edited from this script...
%   
%   In order to change different parameters (not present here)
%   it's possible to operate directly on the Dust preset file:
%       > "./input-DUST/preset/...
%       > "./input-DUST/geometry-data/fuselage.in
%       > "./input-DUST/geometry-data/fuselage/...
%
%   WARNING:    change always wisely the input parameters and double check
%               results obtained... remember that there aren't much checks
%               on the input parameters, so the results can easily leads to 
%               unphysical output values or errors
%               - example:
%                   on 'componentsLoad' (*), dust run into an error if you
%                   try to compute loads for lerx and no such part has been
%                   added to the geometry...
%
%   NOTE:   by setting 'lerxDesign = lerx0' or 'vortexDesign = vortex0' the
%           correspondent part won't be generated
%
%   TIP:    once the set of the input has been defined... 
%           to have a better visual output is suggested to edit:
%           >   "./input-DUST/preset/preset_inDustPost_X.in"
%           and produce different visualization analysis for each component.
%           In this way the color map can be splitted and the data will be
%           more readable 
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./design-aircraft"));
currentPath = pwd;


%% INPUT

% Parametric analysis input:        # possible input for different preset: #
analysisName = 'aoa';
%alphaDegVec = [0 5 10 15]';
alphaDegVec = 5;
componentsLoad = 'tot';             % 'wing'    | 'lerx'      | 'tot' (*)   | 'stab'

% Wing geometry settings                 
wingDesign     = 'wing1';           %  _____    | 'wing1'     | 'wing2'     | 'wing3'
wingOrigin     = [-0.5, 0.6, 0.0];
wingChordRes   = 15;

% Lerx geometry settings 
lerxDesign     = 'lerx1';           % 'lerx0'   | 'lerx1'     | 'lerx2'     | 'lerx3'
lerxOrigin     = [-1.5, 0.6, 0.1];
lerxChordRes   = 5;

% Vortex geometry settings
vortexDesign   = 'vortex0';         % 'vortex0' | 'vortex1'   | 'vortex2'   | 'vortex3'
vortexOrigin   = [-2.5, 0.6, 0.1];
vortexChordRes = 1;

% Tail geometry settings
tailDesign   = 'tail1';             % 'tail0'   | 'tail1'     | 'tail2'     | 'tail3'
tailOrigin   = [2.5, 0.3, 0.5];
tailChordRes = 5;
%tailRotation = [ 1.000, 0.000, 0.000; ...      can use to define a rotate
%                 0.000, 0.500,-0.866; ...      reference system for the tail
%                 0.000, 0.866, 0.500]' ;       INPUT in []: rotation_tensor --> R 

% Fuselage geometry settings 
fuselageDesign = 'fuselage1';       %  _______  | 'fuselage1' | 'fuselage2'

% Reference values:
Sref = 26.56;  
Cref = 5;
rhoInf = 1.225;
betaDeg  = 0;
absVelocity = 1;

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
clearData = true;                   % 'true' = clear current data  |  'false' = leaves old run data in memory
xBoxStart = -10;
xBoxEnd   = 15;
yBoxLimit = 10;
zBoxLimit = 10;

% Postprocessing settings:
saveOutput = true;
plotFlag = initGraphic();
    plotFlag.text = false;          % print some results in command window
    plotFlag.convergence = true;    % plot convergence over time for previous selected plot
    plotFlag.aero = false;          % plot aero loads data over different angle of attack
    plotFlag.struct = false;        % plot structural loads data over different parametric input


%% AIRCRAFT DESIGN 

% Preprocessing of some input values
u_inf =  cell(size(alphaDegVec,1),1);   % velocity cell initialization
for i = 1:size(alphaDegVec,1)           % loop computing velocity from aoa
    [~,u_inf{i}] = computeVelVec(alphaDegVec(i),betaDeg,absVelocity,plotFlag.text);
end
[wakeBox_min,wakeBox_max] = computeWakeBox([xBoxStart,xBoxEnd],yBoxLimit,zBoxLimit);
runNameCell =  cell(size(alphaDegVec,1),1);         % run name cell initialization
timeCostVec = zeros(size(alphaDegVec,1),1);         % time cost vector initialization
startingPath = cd;      cd("./design-aircraft");    % move to aircraft design path

% Geometry preset path selection (based on the user input)
aircraftDesignPath = cd;
fuselageFilePath = sprintf('%s/input-DUST/geometry-data/%s.in',           aircraftDesignPath,fuselageDesign);
wingPresetPath   = sprintf('%s/input-DUST/preset/preset_inWing_%s.in',    aircraftDesignPath,wingDesign);       
lerxPresetPath   = sprintf('%s/input-DUST/preset/preset_inLerx_%s.in',    aircraftDesignPath,lerxDesign);
vortexPresetPath = sprintf('%s/input-DUST/preset/preset_inVortex_%s.in',  aircraftDesignPath,vortexDesign);
tailPresetPath   = sprintf('%s/input-DUST/preset/preset_inTail_%s.in',    aircraftDesignPath,tailDesign); 
postPresetPath   = sprintf('%s/input-DUST/preset/preset_inDustPost_%s.in',aircraftDesignPath,componentsLoad);

% Symmetry plane definition
wingSymPoint   = [0 -wingOrigin(2) 0];
wingSymNorm    = [0 1 0];
lerxSymPoint   = [0 -lerxOrigin(2) 0];
lerxSymNorm    = [0 1 0];
vortexSymPoint = [0 -vortexOrigin(2) 0];
vortexSymNorm  = [0 1 0];
tailSymPoint   = [0 -tailOrigin(2) 0]';     % if rotate reference used:  tailRotation*[0,-tailOrigin(2),0]';
tailSymNorm    = [0 1 0]';                  % if rotate reference used:  tailRotation*[0, 1, 0]';

% Geometry initialization
configurationName = sprintf('%s_%s_%s_%s',wingDesign,lerxDesign,vortexDesign,tailDesign);
if runDUST == true
    % Delete old run data in memory
    if clearData == true
        resetAircraftDesignData(aircraftDesignPath);
    end

    % WingR.in generation
    [inWingRightVars] = inSymPartInit(wingChordRes,wingSymPoint,wingSymNorm,'R');
    [wingRightFilePath] = wingFileMaker_DUST(inWingRightVars,wingDesign,'R',wingPresetPath);
    
    % WingL.in generation
    [inWingLeftVars] = inSymPartInit(wingChordRes,wingSymPoint,wingSymNorm,'L');
    [wingLeftFilePath] = wingFileMaker_DUST(inWingLeftVars,wingDesign,'L',wingPresetPath);

    % Write variables to generate Wing reference
    [inWingRefVars] = inRefInit('Wing',wingOrigin);
    [inWingPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath);
    [inFuselagePreVars] = inPreFuselageInit(fuselageFilePath);
    
    % Lerx generation section
    if ~isequal(lerxDesign,'lerx0')
        % LerxR.in generation
        [inLerxRightVars] = inSymPartInit(lerxChordRes,lerxSymPoint,lerxSymNorm,'R');
        [lerxRightFilePath] = lerxFileMaker_DUST(inLerxRightVars,lerxDesign,'R',lerxPresetPath);
    
        % LerxL.in generation
        [inLerxLeftVars] = inSymPartInit(lerxChordRes,lerxSymPoint,lerxSymNorm,'L');
        [lerxLeftFilePath] = lerxFileMaker_DUST(inLerxLeftVars,lerxDesign,'L',lerxPresetPath);
        
        % Write variables to generate Lerx reference and geometry
        [inLerxRefVars] = inRefInit('Lerx',lerxOrigin);
        [inLerxPreVars] = inPreLerxInit(lerxRightFilePath,lerxLeftFilePath);
         
    else
        % No lerx reference notification
        inLerxRefVars = '! no lerx reference created';
        inLerxPreVars = '! no lerx gemoetru created';
        
    end
    
    % Vortex generation section 
    if ~isequal(vortexDesign,'vortex0')
        % VortexR.in generation
        [inVortexRightVars] = inSymPartInit(vortexChordRes,vortexSymPoint,vortexSymNorm,'R');
        [vortexRightFilePath] = vortexFileMaker_DUST(inVortexRightVars,vortexDesign,'R',vortexPresetPath);

        % VortexL.in generation
        [inVortexLeftVars] = inSymPartInit(vortexChordRes,vortexSymPoint,vortexSymNorm,'L');
        [vortexLeftFilePath] = vortexFileMaker_DUST(inVortexLeftVars,vortexDesign,'L',vortexPresetPath);
       
        % Write variables to generate Vortex reference and geometry
        [inVortexRefVars] = inRefInit('Vortex',vortexOrigin);     
        [inVortexPreVars] = inPreVortexInit(vortexRightFilePath,vortexLeftFilePath);
    
    else
        % No leading edge vortex reference notification
        inVortexRefVars = '! no vortex reference created';
        inVortexPreVars = '! no vortex geometry created';
        
    end 

    % Tail generation section 
    if ~isequal(tailDesign,'tail0')
        % TailR.in generation
        [inTailRightVars] = inSymPartInit(tailChordRes,tailSymPoint,tailSymNorm,'R');
        [tailRightFilePath] = wingFileMaker_DUST(inTailRightVars,tailDesign,'R',tailPresetPath);

        % TailL.in generation
        [inTailLeftVars] = inSymPartInit(tailChordRes,tailSymPoint,tailSymNorm,'L');
        [tailLeftFilePath] = wingFileMaker_DUST(inTailLeftVars,tailDesign,'L',tailPresetPath);
       
        % Write variables to generate tail reference and geometry
        [inTailRefVars] = inRefInit('Tail',tailOrigin);     % if rotate reference used add:  tailRotation     
        [inTailPreVars] = inPreTailInit(tailRightFilePath,tailLeftFilePath);
    
    else
        % No tail reference notification
        inTailRefVars = '! no tail reference created';
        inTailPreVars = '! no tail geometry created';
        
    end 
    
    % References.in generation
    inRefVars = [inWingRefVars,inLerxRefVars,inVortexRefVars,inTailRefVars];
    [refFilePath] = refFileMaker_DUST(inRefVars,configurationName);                
    
    % Dust_pre.in generation
    inPreVars = [inFuselagePreVars,inWingPreVars, inLerxPreVars,inVortexPreVars,inTailPreVars];
    [preFilePath,modelFilePath] = preFileMaker_DUST(inPreVars,configurationName);  
end


% Aircraft design main loop
for i = 1:size(alphaDegVec,1)
    runNameCell{i} = sprintf('%s_%s%.0f',configurationName,analysisName,alphaDegVec(i));    % parametric run name definition
    if runDUST == true
        % Dust.in generation
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustVars  = {u_inf{i}, wakeBox_min, wakeBox_max, geometry_file, reference_file};
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},postPresetPath);
        
        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(aircraftDesignPath);
    end
end

% Postprocessing of the dust output
[designData]   = organizeData_DUST(runNameCell, alphaDegVec, alphaDegVec, analysisName, timeCostVec, plotFlag.convergence);
[aeroLoads]    = aeroLoads_DUST   (designData, absVelocity, rhoInf, Sref, Cref, plotFlag.aero);
[structLoads]  = structLoads_DUST (designData, absVelocity, rhoInf, Sref, Cref, analysisName, plotFlag.struct);

% Save poostprocessing result in design folder
if saveOutput == true
    dataName = sprintf('%s_designData.mat',configurationName);
    save(dataName,"designData");
    aeroName = sprintf('%s_aeroLoads.mat',configurationName);
    save(aeroName,"aeroLoads");
    structName = sprintf('%s_structLoads.mat',configurationName);
    save(structName,"structLoads");
end

cd(startingPath);