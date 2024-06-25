%  
%       -- AIRCRAFT DESIGN for DUST simulation --
% 
%   Script built to compute in MATLAB a different DUST run on various wing,
%   lerx/canard, vortex (to modelize the LE vortex form lerx), tail and fuselage
%   'fuselageConfig' input variable.
%   The geometry can be built in different ways using 'xxxConfig' and 'xxxDesign'
%   The analysis parameters can be modified using the INPUT section of this file.
%   Only some particular DUST settings can be edited from this script...
%   
%   In order to change different parameters (not present here)
%   it's possible to operate directly on the Dust preset file:
%       > "./input-DUST/preset/...
%       > "./input-DUST/geometry-data/fuselage/...
%
%   The list of possible post processing analysis can be edited to add some
%   desired analysis as ".in" file in the folder: 
%       > "./input-DUST/preset/postAnalysis/.."
%
%   WARNING:    change always wisely the input parameters and double check
%               results obtained... remember that there aren't much checks
%               on the input parameters, so the results can easily leads to 
%               unphysical output values or errors
%
%
%                               Matteo Baio, Politecnico di Milano, 06/2024
%

clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./design-aircraft"));
currentPath = pwd;


%% INPUT

% Parametric analysis input:                    # possible input for different preset: #
analysisName = 'aoa';
%alphaDegVec = 2;
%alphaDegVec = [5 10 15]';
alphaDegVec = [2 5 10]';
configurationName = 'eulerValidation_STAD';

% Wing geometry settings                        ---WING------------------------------------------
wingOrigin   = [4.3679, 1.565, 0.1];            
wingDesign   = 'wing3';                         %  'wing1'  |  can add more desing...
wingSymPoint = [0 -wingOrigin(2) 0];
wingSymNorm  = [0 1 0];
wingConfig   = 'sym';                           %  'none'   |   'right'  |   'left'  |   'sym'
wingChordRes = 20;

% Lerx geometry settings                        ---LERX------------------------------------------
lerxOrigin   = [3.3913, 1.545, 0.1];
lerxDesign   = 'lerx1';                         %  'lerx1'      |   can add more desing...
lerxSymPoint = [0 -lerxOrigin(2) 0];
lerxSymNorm  = [0 1 0];
lerxConfig   = 'none';                          %  'none'   |   'right'  |   'left'  |   'sym'
lerxChordRes = 5;

% Vortex geometry settings                      ---VORTEX----------------------------------------
vortexOrigin   = [-2.5, 0.6, 0.1];
vortexDesign   = 'vortex1';                     % 'vortex1'     |   can add more desing...
vortexSymPoint = [0 -vortexOrigin(2) 0];
vortexSymNorm  = [0 1 0];
vortexConfig   = 'none';                        %  'none'   |   'right'  |   'left'  |   'sym'
vortexChordRes = 1;

% Tail geometry settings                        ---TAIL------------------------------------------
tailOrigin     = [8.9333, 1.005, 0.209330127];  % gap = 0.005
tailDesign     = 'tail1';                       %  'tail1'      |   can add more desing...
tailSymPoint   = [0 -tailOrigin(2) 0]';
tailSymNorm    = [0 1 0]';
tailConfig     = 'sym';                         %  'none'   |   'right'  |   'left'  |   'sym'
tailChordRes   = 15;
tailEulerAngle = [0.0000, 0.0000, 60.00];

% Fuselage geometry settings                    ---FUSELAGE--------------------------------------
fuselageOrigin   = [0.0, 0.000, 0.0];
fuselageDesign   = 'fuselage1';                 %  'fuselage1'  |   can add more desing...
fuselageSymPoint = [0 -fuselageOrigin(2) 0];
fuselageSymNorm  = [0 1 0];
fuselageConfig   = 'sym';                       %  'none'    |   'right'  |   'left'  |   'sym'

% Reference values:
Sref = 26.56;           % symmetric wing = 26.56    |   half wing = 13.28
Cref = 2.65;            
PInf = [];              % correct value should be: 57181.965 at 15000ft and mach 0.5      
rhoInf = 1.225;         % correct value should be: 0.7708 at 15000ft and mach 0.5       
betaDeg = 0;
absVelocity = 68;       % correct value should be: 161.12 at 15000ft and mach 0.5   
aInf  = [];             % correct value should be: 322.24 at 15000ft and mach 0.5   
muInf = [];             % correct value should be: 1.642e-5 at 15000ft and mach 0.5   

% DUST settings:
runDUST   = true;                   % 'true' = run dust  |  'false' = use data already in memory
clearData = true;                   % 'true' = clear current data  |  'false' = leaves old run data in memory
xBoxStart = -5;
xBoxEnd   = 20;
yBoxLimit = 10;
zBoxLimit = 10;

%DUST_post settings:
ppVisual    = {'visual_wingF','visual_tailF','visual_fuselageF'};   % if present can ADD: 'visual_lerxF'
ppLoads     = {'load_wingF',  'load_tailF',  'load_fuselageF'};     % if present can ADD: 'load_lerxF'
ppStability = {'load_aeroF'}';                                      % remember to add lerx if present
ppAnalysisList = [ppVisual,ppLoads,ppStability];
%ppAnalysisList = {'visual_debug'};

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
[tailRotation] = rotationTensor(tailEulerAngle);    % rotation tensor computation for tail 
tailRotation = tailRotation';                       % transpose to rotate tail reference sys
tailSymPoint = tailRotation * tailSymPoint;         % tail sym plain origin in the rotated ref sys
tailSymNorm  = tailRotation * tailSymNorm;          % tail sym plain normal in the rotated ref sys
runNameCell  = cell(size(alphaDegVec,1),1);         % run name cell initialization
runDataPath  = cell(size(alphaDegVec,1),1);         % run data path cell initialization
timeCostVec  = zeros(size(alphaDegVec,1),1);        % time cost vector initialization
startingPath = cd;      cd("./design-aircraft");    % move to aircraft design path

% Delete old run data in memory
aircraftDesignPath = cd;
if runDUST == true && clearData == true
    resetDustData(aircraftDesignPath);
end

% Geometry and Reference configuration build for DUST
if runDUST == true
    %%% WING
    if ~isequal(wingConfig,'none')
        % Wing preset and reference definition
        wingPresetPath = sprintf('%s/input-DUST/preset/preset_inWing_%s.in',aircraftDesignPath,wingDesign);
        [inWingRefVars] = inRefInit('Wing',wingOrigin);  

        % WingR.in generation
        if isequal(wingConfig,'right') || isequal(wingConfig,'sym')
        [inWingRightVars]   = inSymPartInit(wingChordRes,wingSymPoint,wingSymNorm,'R');
        [wingRightFilePath] = wingFileMaker_DUST(inWingRightVars,analysisName,'R',wingPresetPath);
            if isequal(wingConfig,'right')
                [inWingPreVars] = inPreWingInit(wingRightFilePath); % wing pre variables for only right wing
            end
        end
        
        % WingL.in generation
        if isequal(wingConfig,'left') || isequal(wingConfig,'sym')
        [inWingLeftVars]   = inSymPartInit(wingChordRes,wingSymPoint,wingSymNorm,'L');
        [wingLeftFilePath] = wingFileMaker_DUST(inWingLeftVars,analysisName,'L',wingPresetPath);
            if isequal(wingConfig,'right')
                [inWingPreVars] = inPreWingInit(wingLeftFilePath);  % wing pre variables for only left wing
            end
        end

        % Write wing pre variables for symmetric configuration
        if isequal(wingConfig,'sym')
            [inWingPreVars] = inPreWingInit(wingRightFilePath,wingLeftFilePath);
        end

    else
        % No wing reference notification
        inWingRefVars = '! no wing reference created';
        inWingPreVars = '! no wing geometry created';

    end


    %%% LERX
    if ~isequal(lerxConfig,'none')
        % lerx preset and reference definition
        lerxPresetPath = sprintf('%s/input-DUST/preset/preset_inLerx_%s.in',aircraftDesignPath,lerxDesign);
        [inLerxRefVars] = inRefInit('Lerx',lerxOrigin);  

        % LerxR.in generation
        if isequal(lerxConfig,'right') || isequal(lerxConfig,'sym')
        [inLerxRightVars]   = inSymPartInit(lerxChordRes,lerxSymPoint,lerxSymNorm,'R');
        [lerxRightFilePath] = lerxFileMaker_DUST(inLerxRightVars,analysisName,'R',lerxPresetPath);
            if isequal(lerxConfig,'right')
                [inLerxPreVars] = inPreLerxInit(lerxRightFilePath); % lerx pre variables for only right lerx
            end
        end
        
        % LerxL.in generation
        if isequal(lerxConfig,'left') || isequal(lerxConfig,'sym')
        [inLerxLeftVars]   = inSymPartInit(lerxChordRes,lerxSymPoint,lerxSymNorm,'L');
        [lerxLeftFilePath] = lerxFileMaker_DUST(inLerxLeftVars,analysisName,'L',lerxPresetPath);
            if isequal(lerxConfig,'right')
                [inLerxPreVars] = inPreLerxInit(lerxLeftFilePath);  % lerx pre variables for only left lerx
            end
        end

        % Write lerx pre variables for symmetric configuration
        if isequal(lerxConfig,'sym')
            [inLerxPreVars] = inPreLerxInit(lerxRightFilePath,lerxLeftFilePath);
        end

    else
        % No lerx reference notification
        inLerxRefVars = '! no lerx reference created';
        inLerxPreVars = '! no lerx geometry created';

    end


    %%% VORTEX
    if ~isequal(vortexConfig,'none')
        % Vortex preset and reference definition
        vortexPresetPath = sprintf('%s/input-DUST/preset/preset_inVortex_%s.in',aircraftDesignPath,vortexDesign);
        [inVortexRefVars] = inRefInit('Vortex',vortexOrigin);  

        % VortexR.in generation
        if isequal(vortexConfig,'right') || isequal(vortexConfig,'sym')
        [inVortexRightVars]   = inSymPartInit(vortexChordRes,vortexSymPoint,vortexSymNorm,'R');
        [vortexRightFilePath] = vortexFileMaker_DUST(inVortexRightVars,analysisName,'R',vortexPresetPath);
            if isequal(vortexConfig,'right')
                [inVortexPreVars] = inPreVortexInit(vortexRightFilePath); % vortex pre variables for only right vortex
            end
        end
        
        % VortexL.in generation
        if isequal(vortexConfig,'left') || isequal(vortexConfig,'sym')
        [inVortexLeftVars]   = inSymPartInit(vortexChordRes,vortexSymPoint,vortexSymNorm,'L');
        [vortexLeftFilePath] = vortexFileMaker_DUST(inVortexLeftVars,analysisName,'L',vortexPresetPath);
            if isequal(vortexConfig,'right')
                [inVortexPreVars] = inPreVortexInit(vortexLeftFilePath);  % vortex pre variables for only left vortex
            end
        end

        % Write vortex pre variables for symmetric configuration
        if isequal(vortexConfig,'sym')
            [inVortexPreVars] = inPreVortexInit(vortexRightFilePath,vortexLeftFilePath);
        end

    else
        % No vortex reference notification
        inVortexRefVars = '! no vortex reference created';
        inVortexPreVars = '! no vortex geometry created';

    end


    %%% TAIL
    if ~isequal(tailConfig,'none')
        % Tail preset and reference definition
        tailPresetPath = sprintf('%s/input-DUST/preset/preset_inTail_%s.in',aircraftDesignPath,tailDesign);
        [inTailRefVars] = inRefInit('Tail',tailOrigin,tailRotation);  

        % TailR.in generation
        if isequal(tailConfig,'right') || isequal(tailConfig,'sym')
        [inTailRightVars]   = inSymPartInit(tailChordRes,tailSymPoint,tailSymNorm,'R');
        [tailRightFilePath] = tailFileMaker_DUST(inTailRightVars,analysisName,'R',tailPresetPath);
            if isequal(tailConfig,'right')
                [inTailPreVars] = inPreTailInit(tailRightFilePath); % tail pre variables for only right tail
            end
        end
        
        % TailL.in generation
        if isequal(tailConfig,'left') || isequal(tailConfig,'sym')
        [inTailLeftVars]   = inSymPartInit(tailChordRes,tailSymPoint,tailSymNorm,'L');
        [tailLeftFilePath] = tailFileMaker_DUST(inTailLeftVars,analysisName,'L',tailPresetPath);
            if isequal(tailConfig,'right')
                [inTailPreVars] = inPreTailInit(tailLeftFilePath);  % tail pre variables for only left tail
            end
        end

        % Write tail pre variables for symmetric configuration
        if isequal(tailConfig,'sym')
            [inTailPreVars] = inPreTailInit(tailRightFilePath,tailLeftFilePath);
        end

    else
        % No tail reference notification
        inTailRefVars = '! no tail reference created';
        inTailPreVars = '! no tail geometry created';

    end


    %%% FUSELAGE
    if ~isequal(fuselageConfig,'none')
        % Fuselage preset and reference definition
        fuselagePresetPath = sprintf('%s/input-DUST/preset/preset_inFuselage_%s.in',aircraftDesignPath,fuselageDesign);
        [inFuselageRefVars] = inRefInit('Body',fuselageOrigin);                 % 'fuselageOrientation' to correct direction

        % FuselageR.in generation
        if isequal(fuselageConfig,'right') || isequal(fuselageConfig,'sym')
            [inFuselageRightVars]   = inSymPartInit([],fuselageSymPoint,fuselageSymNorm,'R');
            [fuselageRightFilePath] = fuselageFileMaker_DUST(inFuselageRightVars,analysisName,'R',fuselagePresetPath);
            if isequal(fuselageConfig,'right')
                [inFuselagePreVars] = inPreFuselageInit(fuselageRightFilePath); % fuselage pre variables for only right config
            end
        end

        % FuselageL.in generation
        if isequal(fuselageConfig,'left') || isequal(fuselageConfig,'sym')
        [inFuselageLeftVars]   = inSymPartInit([],fuselageSymPoint,fuselageSymNorm,'L');
        [fuselageLeftFilePath] = fuselageFileMaker_DUST(inFuselageLeftVars,analysisName,'L',fuselagePresetPath);
            if isequal(fuselageConfig,'left')
                [inFuselagePreVars] = inPreFuselageInit(fuselageLeftFilePath); % fuselage pre variables for only left config
            end
        end

        % Write fuselage pre variables for symmetric configuration
        if isequal(fuselageConfig,'sym')
            [inFuselagePreVars] = inPreFuselageInit(fuselageRightFilePath,fuselageLeftFilePath);
        end
    
    else
        % No fuselage reference notification
        inFuselageRefVars = '! no fuselage reference created';
        inFuselagePreVars = '! no fuselage geometry created';
    
    end

    
    % References.in generation
    inRefVars = [inWingRefVars,inLerxRefVars,inVortexRefVars,inTailRefVars,inFuselageRefVars];
    [refFilePath] = refFileMaker_DUST(inRefVars,configurationName);                
    
    % Dust_pre.in generation
    inPreVars = [inWingPreVars,inLerxPreVars,inVortexPreVars,inTailPreVars,inFuselagePreVars];
    [preFilePath,modelFilePath] = preFileMaker_DUST(inPreVars,configurationName);  
end

% Aircraft design main loop
for i = 1:size(alphaDegVec,1)
    runNameCell{i} = sprintf('%s_%s%.0f',configurationName,analysisName,alphaDegVec(i));    % parametric run name definition
    runDataPath{i} = sprintf('pp-DUST/%s/pp_loadsAero.dat',runNameCell{i});
    if runDUST == true
        % Dust.in generation
        geometry_file  = sprintf('geometry_file = %s', modelFilePath);
        reference_file = sprintf('reference_file = %s',refFilePath);
        inDustVars  = {u_inf{i}, wakeBox_min, wakeBox_max, geometry_file, reference_file};
        [dustFilePath,outputPath] = inputFileMaker_DUST(inDustVars,runNameCell{i});

        % Dust_post.in generation
        [ppFilePath,ppPath] = ppFileMaker_DUST(outputPath,runNameCell{i},ppAnalysisList);
        
        % Dust run
        cd("./input-DUST");
        timeCostVec(i,1) = exec_DUST(preFilePath,dustFilePath,ppFilePath);
        cd(aircraftDesignPath);
    end
end

% Postprocessing of the dust output
[designData]   = organizeData_DUST(runDataPath, alphaDegVec, alphaDegVec, analysisName, timeCostVec, plotFlag.convergence);
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