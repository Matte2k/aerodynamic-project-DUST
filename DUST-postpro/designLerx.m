clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"));
currentPath = pwd;
initGraphic;

%% Data import

% input
alphaDegVec  = [0 5 10 15]'; 
dataSubfolderName = 'lerx';
considerTail = false;
[reference] = runReferenceValue(96.672, 0.770153, 2.65, 26.56);
avgLoadIdx = 90;

% variable init
noLerxConfig = struct;
    noLerxConfig.wing = true;
    noLerxConfig.tail = true;
    noLerxConfig.lerx = false;
    noLerxConfig.fuselage = true;

% color map definition
cmap = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250; 0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840];
cmap = cmap(1:length(alphaDegVec),:);
    cbTicksCount = 1:length(alphaDegVec);
    cbTicksPos = [0.5, cbTicksCount, (cbTicksCount(end)+0.5)];

% configuration without lerx
[lerx0.wing,lerx0.tail,lerx0.fuselage] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx0_aoa',reference,noLerxConfig);
[lerx0.wing] = meanAeroLoadsCorrector(lerx0.wing,reference,avgLoadIdx);
[lerx0.tail] = meanAeroLoadsCorrector(lerx0.tail,reference,avgLoadIdx);
[lerx0.fuselage] = meanAeroLoadsCorrector(lerx0.fuselage,reference,avgLoadIdx);

% Lerx 1
[lerx1.wing,lerx1.tail,lerx1.fuselage,lerx1.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx1_aoa',reference);
[lerx1.wing] = meanAeroLoadsCorrector(lerx1.wing,reference,avgLoadIdx);
[lerx1.tail] = meanAeroLoadsCorrector(lerx1.tail,reference,avgLoadIdx);
[lerx1.lerx] = meanAeroLoadsCorrector(lerx1.lerx,reference,avgLoadIdx);
[lerx1.fuselage] = meanAeroLoadsCorrector(lerx1.fuselage,reference,avgLoadIdx);

% Lerx 2
[lerx2.wing,lerx2.tail,lerx2.fuselage,lerx2.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx2_aoa',reference);
[lerx2.wing] = meanAeroLoadsCorrector(lerx2.wing,reference,avgLoadIdx);
[lerx2.tail] = meanAeroLoadsCorrector(lerx2.tail,reference,avgLoadIdx);
[lerx2.lerx] = meanAeroLoadsCorrector(lerx2.lerx,reference,avgLoadIdx);
[lerx2.fuselage] = meanAeroLoadsCorrector(lerx2.fuselage,reference,avgLoadIdx);

% Lerx 3
[lerx3.wing,lerx3.tail,lerx3.fuselage,lerx3.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx3_aoa',reference);
[lerx3.wing] = meanAeroLoadsCorrector(lerx3.wing,reference,avgLoadIdx);
[lerx3.tail] = meanAeroLoadsCorrector(lerx3.tail,reference,avgLoadIdx);
[lerx3.lerx] = meanAeroLoadsCorrector(lerx3.lerx,reference,avgLoadIdx);
[lerx3.fuselage] = meanAeroLoadsCorrector(lerx3.fuselage,reference,avgLoadIdx);

% Lerx 4
[lerx4.wing,lerx4.tail,lerx4.fuselage,lerx4.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx4_aoa',reference);
[lerx4.wing] = meanAeroLoadsCorrector(lerx4.wing,reference,avgLoadIdx);
[lerx4.tail] = meanAeroLoadsCorrector(lerx4.tail,reference,avgLoadIdx);
[lerx4.lerx] = meanAeroLoadsCorrector(lerx4.lerx,reference,avgLoadIdx);
[lerx4.fuselage] = meanAeroLoadsCorrector(lerx4.fuselage,reference,avgLoadIdx);

% Lerx 5
[lerx5.wing,lerx5.tail,lerx5.fuselage,lerx5.lerx] = dataParser_DUST(alphaDegVec,dataSubfolderName,'lerx5_aoa',reference);
[lerx5.wing] = meanAeroLoadsCorrector(lerx5.wing,reference,avgLoadIdx);
[lerx5.tail] = meanAeroLoadsCorrector(lerx5.tail,reference,avgLoadIdx);
[lerx5.lerx] = meanAeroLoadsCorrector(lerx5.lerx,reference,avgLoadIdx);
[lerx5.fuselage] = meanAeroLoadsCorrector(lerx5.fuselage,reference,avgLoadIdx);


%% Data post-process

%%% Friction drag empiric computation
% Lerx 1
lerx1.surface = (0.925387 * 0.463947);
friction.lerx1 = empiricFrictionDrag(0.3, 40, lerx1.surface, reference.Sref, reference.Cref);
lerx1.lerx.aeroLoads.Cd = lerx1.lerx.aeroLoads.Cd + friction.lerx1;

% Lerx 2
lerx2.surface = (0.709115 * 0.35062);
friction.lerx2 = empiricFrictionDrag(0.3, 40, lerx2.surface, reference.Sref, reference.Cref);
lerx2.lerx.aeroLoads.Cd = lerx2.lerx.aeroLoads.Cd + friction.lerx2;

% Lerx 3
lerx3.surface = (0.492743 * 0.23724);
friction.lerx3 = empiricFrictionDrag(0.3, 40, lerx3.surface, reference.Sref, reference.Cref);
lerx3.lerx.aeroLoads.Cd = lerx3.lerx.aeroLoads.Cd + friction.lerx3;

% Lerx 4
lerx4.surface = (0.925387 * 0.678246);
friction.lerx4 = empiricFrictionDrag(0.3, 40, lerx4.surface, reference.Sref, reference.Cref);
lerx4.lerx.aeroLoads.Cd = lerx4.lerx.aeroLoads.Cd + friction.lerx4;

% Lerx 5
lerx5.surface = (0.925387 * 0.30605);
friction.lerx5 = empiricFrictionDrag(0.3, 40, lerx5.surface, reference.Sref, reference.Cref);
lerx5.lerx.aeroLoads.Cd = lerx5.lerx.aeroLoads.Cd + friction.lerx5;


%%% Total aerodynamic loads computation
% Cl
if considerTail == true
    lerx0.aero.Cl = lerx0.wing.aeroLoads.Cl + lerx0.tail.aeroLoads.Cl;    % tail
    lerx1.aero.Cl = lerx1.wing.aeroLoads.Cl + lerx1.tail.aeroLoads.Cl + lerx1.lerx.aeroLoads.Cl;
    lerx2.aero.Cl = lerx2.wing.aeroLoads.Cl + lerx2.tail.aeroLoads.Cl + lerx2.lerx.aeroLoads.Cl;
    lerx3.aero.Cl = lerx3.wing.aeroLoads.Cl + lerx3.tail.aeroLoads.Cl + lerx3.lerx.aeroLoads.Cl;
    lerx4.aero.Cl = lerx4.wing.aeroLoads.Cl + lerx4.tail.aeroLoads.Cl + lerx4.lerx.aeroLoads.Cl;
    lerx5.aero.Cl = lerx5.wing.aeroLoads.Cl + lerx5.tail.aeroLoads.Cl + lerx5.lerx.aeroLoads.Cl;
else
    lerx0.aero.Cl = lerx0.wing.aeroLoads.Cl;    % no tail
    lerx1.aero.Cl = lerx1.wing.aeroLoads.Cl + lerx1.lerx.aeroLoads.Cl;
    lerx2.aero.Cl = lerx2.wing.aeroLoads.Cl + lerx2.lerx.aeroLoads.Cl;
    lerx3.aero.Cl = lerx3.wing.aeroLoads.Cl + lerx3.lerx.aeroLoads.Cl;
    lerx4.aero.Cl = lerx4.wing.aeroLoads.Cl + lerx4.lerx.aeroLoads.Cl;
    lerx5.aero.Cl = lerx5.wing.aeroLoads.Cl + lerx5.lerx.aeroLoads.Cl;
end

% Cm
if considerTail == true
    lerx0.aero.Cm = lerx0.wing.aeroLoads.Cm + lerx0.tail.aeroLoads.Cm;    % tail
    lerx1.aero.Cm = lerx1.wing.aeroLoads.Cm + lerx1.tail.aeroLoads.Cm + lerx1.lerx.aeroLoads.Cm;
    lerx2.aero.Cm = lerx2.wing.aeroLoads.Cm + lerx2.tail.aeroLoads.Cm + lerx2.lerx.aeroLoads.Cm;
    lerx3.aero.Cm = lerx3.wing.aeroLoads.Cm + lerx3.tail.aeroLoads.Cm + lerx3.lerx.aeroLoads.Cm;
    lerx4.aero.Cm = lerx4.wing.aeroLoads.Cm + lerx4.tail.aeroLoads.Cm + lerx4.lerx.aeroLoads.Cm;
    lerx5.aero.Cm = lerx5.wing.aeroLoads.Cm + lerx5.tail.aeroLoads.Cm + lerx5.lerx.aeroLoads.Cm;
else
    lerx0.aero.Cm = lerx0.wing.aeroLoads.Cm;    % no tail
    lerx1.aero.Cm = lerx1.wing.aeroLoads.Cm + lerx1.lerx.aeroLoads.Cm;
    lerx2.aero.Cm = lerx2.wing.aeroLoads.Cm + lerx2.lerx.aeroLoads.Cm;
    lerx3.aero.Cm = lerx3.wing.aeroLoads.Cm + lerx3.lerx.aeroLoads.Cm;
    lerx4.aero.Cm = lerx4.wing.aeroLoads.Cm + lerx4.lerx.aeroLoads.Cm;
    lerx5.aero.Cm = lerx5.wing.aeroLoads.Cm + lerx5.lerx.aeroLoads.Cm;
end

% Cd
if considerTail == true
    lerx0.aero.Cd = lerx0.wing.aeroLoads.Cd + lerx0.tail.aeroLoads.Cd;    % tail
    lerx1.aero.Cd = lerx1.wing.aeroLoads.Cd + lerx1.tail.aeroLoads.Cd + lerx1.lerx.aeroLoads.Cd;
    lerx2.aero.Cd = lerx2.wing.aeroLoads.Cd + lerx2.tail.aeroLoads.Cd + lerx2.lerx.aeroLoads.Cd;
    lerx3.aero.Cd = lerx3.wing.aeroLoads.Cd + lerx3.tail.aeroLoads.Cd + lerx3.lerx.aeroLoads.Cd;
    lerx4.aero.Cd = lerx4.wing.aeroLoads.Cd + lerx4.tail.aeroLoads.Cd + lerx4.lerx.aeroLoads.Cd;
    lerx5.aero.Cd = lerx5.wing.aeroLoads.Cd + lerx5.tail.aeroLoads.Cd + lerx5.lerx.aeroLoads.Cd;
else
    lerx0.aero.Cd = lerx0.wing.aeroLoads.Cd;    % no tail
    lerx1.aero.Cd = lerx1.wing.aeroLoads.Cd + lerx1.lerx.aeroLoads.Cd;
    lerx2.aero.Cd = lerx2.wing.aeroLoads.Cd + lerx2.lerx.aeroLoads.Cd;
    lerx3.aero.Cd = lerx3.wing.aeroLoads.Cd + lerx3.lerx.aeroLoads.Cd;
    lerx4.aero.Cd = lerx4.wing.aeroLoads.Cd + lerx4.lerx.aeroLoads.Cd;
    lerx5.aero.Cd = lerx5.wing.aeroLoads.Cd + lerx5.lerx.aeroLoads.Cd;
end

%%% Aerodynamic loads delta with lerx0 case
% Cl
lerx1.aero.dCl = lerx1.aero.Cl - lerx0.aero.Cl;
lerx2.aero.dCl = lerx2.aero.Cl - lerx0.aero.Cl;
lerx3.aero.dCl = lerx3.aero.Cl - lerx0.aero.Cl;
lerx4.aero.dCl = lerx4.aero.Cl - lerx0.aero.Cl;
lerx5.aero.dCl = lerx5.aero.Cl - lerx0.aero.Cl;

% Cd
lerx1.aero.dCd = lerx1.aero.Cd - lerx0.aero.Cd;
lerx2.aero.dCd = lerx2.aero.Cd - lerx0.aero.Cd;
lerx3.aero.dCd = lerx3.aero.Cd - lerx0.aero.Cd;
lerx4.aero.dCd = lerx4.aero.Cd - lerx0.aero.Cd;
lerx5.aero.dCd = lerx5.aero.Cd - lerx0.aero.Cd;

% Cm
lerx1.aero.dCm = lerx1.aero.Cm - lerx0.aero.Cm;
lerx2.aero.dCm = lerx2.aero.Cm - lerx0.aero.Cm;
lerx3.aero.dCm = lerx3.aero.Cm - lerx0.aero.Cm;
lerx4.aero.dCm = lerx4.aero.Cm - lerx0.aero.Cm;
lerx5.aero.dCm = lerx5.aero.Cm - lerx0.aero.Cm;

%%% Convergence data on lerx1
for i = 1:length(alphaDegVec)
    if considerTail == true
        lerx1.convergence.Fz(:,i) = lerx1.tail.designData{i,1}.Fz + lerx1.wing.designData{i,1}.Fz + lerx1.lerx.designData{i,1}.Fz;
        lerx1.convergence.Fx(:,i) = lerx1.tail.designData{i,1}.Fx + lerx1.wing.designData{i,1}.Fx + lerx1.lerx.designData{i,1}.Fx;
        lerx1.convergence.My(:,i) = lerx1.tail.designData{i,1}.My + lerx1.wing.designData{i,1}.My + lerx1.lerx.designData{i,1}.My;
    else
        lerx1.convergence.Fz(:,i) = lerx1.wing.designData{i,1}.Fz + lerx1.lerx.designData{i,1}.Fz;
        lerx1.convergence.Fx(:,i) = lerx1.wing.designData{i,1}.Fx + lerx1.lerx.designData{i,1}.Fx;
        lerx1.convergence.My(:,i) = lerx1.wing.designData{i,1}.My + lerx1.lerx.designData{i,1}.My;
    end
end
if considerTail == true
    lerx1.convegence.mFz = lerx1.wing.aeroLoads.Fz + lerx1.tail.aeroLoads.Fz + lerx1.lerx.aeroLoads.Fz;
    lerx1.convegence.mFx = lerx1.wing.aeroLoads.Fx + lerx1.tail.aeroLoads.Fx + lerx1.lerx.aeroLoads.Fx;
    lerx1.convegence.mMy = lerx1.wing.aeroLoads.My + lerx1.tail.aeroLoads.My + lerx1.lerx.aeroLoads.My;
else
    lerx1.convegence.mFz = lerx1.wing.aeroLoads.Fz + lerx1.lerx.aeroLoads.Fz;
    lerx1.convegence.mFx = lerx1.wing.aeroLoads.Fx + lerx1.lerx.aeroLoads.Fx;
    lerx1.convegence.mMy = lerx1.wing.aeroLoads.My + lerx1.lerx.aeroLoads.My;
end



%% Convergence plot (for lerx1)

convergencePlot = figure(Name='Convergence');
tiledlayout(1,3);  
nexttile(1);    % Fz
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(alphaDegVec)
        plot(lerx1.tail.designData{i,1}.time , lerx1.convergence.Fz(:,i),'Color',cmap(i,:));
        yline(lerx1.convegence.mFz(i),'--','Color',cmap(i,:))
    end
    xlabel('$time$ [sec]');       ylabel('$F_{z}$ [N]');
    ylim([-0.5e4,5.5e4])

nexttile(2);    % Fx
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(alphaDegVec)
        plot(lerx1.tail.designData{i,1}.time , lerx1.convergence.Fx(:,i),'Color',cmap(i,:));
        yline(lerx1.convegence.mFx(i),'--','Color',cmap(i,:))
    end
    xlabel('$time$ [sec]');      ylabel('$F_{x}$ [N]');
    ylim([-1.3e4,1.5e3])

nexttile(3);    % My
    hold on;    grid minor;     axis padded;    box on;
    for i = 1:length(alphaDegVec)
        plot(lerx1.tail.designData{i,1}.time , lerx1.convergence.My(:,i),'Color',cmap(i,:));
        yline(lerx1.convegence.mMy(i),'--','Color',cmap(i,:))
    end
    xlabel('$time$ [sec]');      ylabel('$M_{y}$ [N]');
    ylim([-1.75e4,0.25e4])
    
colormap(cmap)                              % apply colormap
caxis([cbTicksPos(1),cbTicksPos(end)])      % to be changed in clim since Matlab R2022a
    cb = colorbar;                          % apply colorbar
    cb.Label.String = '$\alpha$';
    cb.Label.Interpreter = 'latex';
    cb.Ticks = cbTicksPos;
    cb.TickLabels = {'',num2str(alphaDegVec),''};
    cb.Layout.Tile = 'east';
set(cb,'TickLabelInterpreter','latex')
set(convergencePlot,'units','centimeters','position',[0,0,30,10]);
exportgraphics(convergencePlot,'figure\lerx1_convergence.png','Resolution',1000);


%% Chord iteration - plot

%%% Integral loads value compare
integralAeroLoadsChords = figure(Name='Integral loads value vs chord');
tiledlayout(1,3);

nexttile(1)     % Cl
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.Cl,'-o')
    plot(alphaDegVec, lerx2.aero.Cl,'-o')
    plot(alphaDegVec, lerx3.aero.Cl,'-o')
    plot(alphaDegVec, lerx0.aero.Cl,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$C_L$');
    legend('chord long','chord mid','chord short','no lerx',Location='northwest');

nexttile(2)     % Cd
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.Cd,'-o')
    plot(alphaDegVec, lerx2.aero.Cd,'-o')
    plot(alphaDegVec, lerx3.aero.Cd,'-o')
    plot(alphaDegVec, lerx0.aero.Cd,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$C_D$');
    legend('chord long','chord mid','chord short','no lerx',Location='northwest');

nexttile(3)     % Cm
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.Cm,'-o')
    plot(alphaDegVec, lerx2.aero.Cm,'-o')
    plot(alphaDegVec, lerx3.aero.Cm,'-o')
    plot(alphaDegVec, lerx0.aero.Cm,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$C_M$');
    legend('chord long','chord mid','chord short','no lerx',Location='southwest');

set(integralAeroLoadsChords,'units','centimeters','position',[0,0,30,10]);
exportgraphics(integralAeroLoadsChords,'figure\lerxLoadsValue_chord.png','Resolution',1000);


%%% Integral loads difference compare
integralAeroLoadsChords = figure(Name='Integral loads difference vs chord');
tiledlayout(1,3);

nexttile(1)     % Cl
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.dCl,'-o')
    plot(alphaDegVec, lerx2.aero.dCl,'-o')
    plot(alphaDegVec, lerx3.aero.dCl,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$\Delta$ $C_L$');
    legend('chord long','chord mid','chord short',Location='northwest');

nexttile(2)     % Cd
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.dCd,'-o')
    plot(alphaDegVec, lerx2.aero.dCd,'-o')
    plot(alphaDegVec, lerx3.aero.dCd,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$\Delta$ $C_D$');
    legend('chord long','chord mid','chord short',Location='northwest');

nexttile(3)     % Cm
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.dCm,'-o')
    plot(alphaDegVec, lerx2.aero.dCm,'-o')
    plot(alphaDegVec, lerx3.aero.dCm,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$\Delta$ $C_M$');
    legend('chord long','chord mid','chord short',Location='northwest');

set(integralAeroLoadsChords,'units','centimeters','position',[0,0,30,10]);
exportgraphics(integralAeroLoadsChords,'figure\lerxLoadsDiff_chord.png','Resolution',1000);



%% sweep iteration - plot

%%% Integral loads value compare
integralAeroLoadsChords = figure(Name='Integral loads value vs sweep');
tiledlayout(1,3);

nexttile(1)     % Cl
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.Cl,'-o')
    plot(alphaDegVec, lerx4.aero.Cl,'-o')
    plot(alphaDegVec, lerx5.aero.Cl,'-o')
    plot(alphaDegVec, lerx0.aero.Cl,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$C_L$');
    legend('sweep 70','sweep 65','sweep 75','no lerx',Location='northwest');

nexttile(2)     % Cd
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.Cd,'-o')
    plot(alphaDegVec, lerx4.aero.Cd,'-o')
    plot(alphaDegVec, lerx5.aero.Cd,'-o')
    plot(alphaDegVec, lerx0.aero.Cd,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$C_D$');
    legend('sweep 70','sweep 65','sweep 75','no lerx',Location='northwest');

nexttile(3)     % Cm
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.Cm,'-o')
    plot(alphaDegVec, lerx4.aero.Cm,'-o')
    plot(alphaDegVec, lerx5.aero.Cm,'-o')
    plot(alphaDegVec, lerx0.aero.Cm,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$C_M$');
    legend('sweep 70','sweep 65','sweep 75','no lerx',Location='southwest');

set(integralAeroLoadsChords,'units','centimeters','position',[0,0,30,10]);
exportgraphics(integralAeroLoadsChords,'figure\lerxLoadsValue_sweep.png','Resolution',1000);


%%% Integral loads difference compare
integralAeroLoadsChords = figure(Name='Integral loads difference vs sweep');
tiledlayout(1,3);

nexttile(1)     % Cl
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.dCl,'-o')
    plot(alphaDegVec, lerx4.aero.dCl,'-o')
    plot(alphaDegVec, lerx5.aero.dCl,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$\Delta$ $C_L$');
    legend('sweep 70','sweep 65','sweep 75',Location='northwest');

nexttile(2)     % Cd
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.dCd,'-o')
    plot(alphaDegVec, lerx4.aero.dCd,'-o')
    plot(alphaDegVec, lerx5.aero.dCd,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$\Delta$ $C_D$');
    legend('sweep 70','sweep 65','sweep 75',Location='northwest');

nexttile(3)     % Cm
    grid minor; hold on; axis padded; box on;
    plot(alphaDegVec, lerx1.aero.dCm,'-o')
    plot(alphaDegVec, lerx4.aero.dCm,'-o')
    plot(alphaDegVec, lerx5.aero.dCm,'-o')
    xlabel('$\alpha$ [deg]');       ylabel('$\Delta$ $C_M$');
    legend('sweep 70','sweep 65','sweep 75',Location='northwest');

set(integralAeroLoadsChords,'units','centimeters','position',[0,0,30,10]);
exportgraphics(integralAeroLoadsChords,'figure\lerxLoadsDiff_sweep.png','Resolution',1000);


%% selected lerx general plot
