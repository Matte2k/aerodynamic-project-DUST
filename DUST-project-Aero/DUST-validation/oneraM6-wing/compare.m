clearvars;  close all;  clc
addpath(genpath("./src"));
addpath(genpath("./AVL"));
addpath(genpath("./CFD"));
addpath(genpath("./DUST"));
currentPath = pwd;

%% Chordwise Cp distribution

%%% Cp distribution at Ma=0.3 aoa=0°
t1 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('03','0',1);
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('03','0',2);
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('03','0',3);
    title('station $$y/b=0.95$$');

t1.Title = title(t1,'$$C_p$$ chordwise distribution at $$Ma=0.3$$, $${\alpha}=0.00^{\circ}$$');
t1.Title.Interpreter= 'latex'; 


%%% Cp distribution at Ma=0.3 aoa=3.06°
t1 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('03','3',1);
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('03','3',2);
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('03','3',3);
    title('station $$y/b=0.95$$');

t1.Title = title(t1,'$$C_p$$ chordwise distribution at $$Ma=0.3$$, $${\alpha}=3.06^{\circ}$$');
t1.Title.Interpreter= 'latex'; 


%%% Cp distribution at Ma=0.3 aoa=6.12°
t1 = tiledlayout(1,3);

    nexttile
    chordwiseCp_plot('03','6',1);
    title('station $$y/b=0.20$$');

    nexttile
    chordwiseCp_plot('03','6',2);
    title('station $$y/b=0.65$$');

    nexttile
    chordwiseCp_plot('03','6',3);
    title('station $$y/b=0.95$$');

t1.Title = title(t1,'$$C_p$$ chordwise distribution at $$Ma=0.3$$, $${\alpha}=6.12^{\circ}$$');
t1.Title.Interpreter= 'latex'; 
