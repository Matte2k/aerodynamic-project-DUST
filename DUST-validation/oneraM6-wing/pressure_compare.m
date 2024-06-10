clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./data"))
currentPath = pwd;
[~] = initGraphic;

%% Chordwise Cp distribution at Mach 0.3000

%%% Cp distribution at aoa = 0°
figure(Name='M03-aoa0')
t1 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('03','0',1,{'dust','cfd'});
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('03','0',2,{'dust','cfd'});
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('03','0',3,{'dust','cfd'});
    title('station $$y/b=0.95$$');

t1.Title = title(t1,'$$C_p$$ chordwise distribution at $$Ma=0.3000$$, $${\alpha}=0.00^{\circ}$$');
t1.Title.Interpreter= 'latex'; 


%%% Cp distribution at aoa = 3.06°
figure(Name='M03-aoa3')
t2 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('03','3',1,{'dust','cfd'});
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('03','3',2,{'dust','cfd'});
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('03','3',3,{'dust','cfd'});
    title('station $$y/b=0.95$$');

t2.Title = title(t2,'$$C_p$$ chordwise distribution at $$Ma=0.3000$$, $${\alpha}=3.06^{\circ}$$');
t2.Title.Interpreter= 'latex'; 


%%% Cp distribution at aoa = 6.12°
figure(Name='M03-aoa6')
t3 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('03','6',1,{'dust','cfd'});
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('03','6',2,{'dust','cfd'});
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('03','6',3,{'dust','cfd'});
    title('station $$y/b=0.95$$');

t3.Title = title(t3,'$$C_p$$ chordwise distribution at $$Ma=0.3000$$, $${\alpha}=6.12^{\circ}$$');
t3.Title.Interpreter= 'latex';


%% Chordwise Cp distribution at Mach 0.8395

%%% Cp distribution at aoa = 0°
figure(Name='M08-aoa0')
t4 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('08','0',1,{'dust','cfd','exp'});
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('08','0',2,{'dust','cfd','exp'});
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('08','0',3,{'dust','cfd','exp'});
    title('station $$y/b=0.95$$');

t4.Title = title(t4,'$$C_p$$ chordwise distribution at $$Ma=0.8395$$, $${\alpha}=0.00^{\circ}$$');
t4.Title.Interpreter= 'latex'; 


%%% Cp distribution at aoa = 3.06°
figure(Name='M08-aoa3')
t5 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('08','3',1,{'dust','cfd','exp'});
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('08','3',2,{'dust','cfd','exp'});
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('08','3',3,{'dust','cfd','exp'});
    title('station $$y/b=0.95$$');

t5.Title = title(t5,'$$C_p$$ chordwise distribution at $$Ma=0.8395$$, $${\alpha}=3.06^{\circ}$$');
t5.Title.Interpreter= 'latex'; 


%%% Cp distribution at aoa = 6.12°
figure(Name='M08-aoa6')
t6 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('08','6',1,{'dust','cfd','exp'});
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('08','6',2,{'dust','cfd','exp'});
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('08','6',3,{'dust','cfd','exp'});
    title('station $$y/b=0.95$$');

t6.Title = title(t6,'$$C_p$$ chordwise distribution at $$Ma=0.8395$$, $${\alpha}=6.12^{\circ}$$');
t6.Title.Interpreter= 'latex'; 
