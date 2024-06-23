function [plotFlag] = initGraphic(graphicPreset)
%INIT GRAPHIC - Initialize graphic settings and plot flags
%
%   Syntax:
%       [plotFlag] = initGraphic(graphicPreset)
% 
%   Input:
%       graphicPreset,  double: sets plot flag preset as follow:
%                                  0 --> only convergence and structural plot active
%                                  1 --> all plots active
%                                  2 --> all plots turned off
%   
%   Output:
%       plotFlag, struct: different fields corresponds to different kind of plots
%                            text --> print results in command window
%                            convergence --> plot convergence plot over time
%                            aero --> plot aerodynamic loads
%                            struct --> plot structural loads
%   
%                               Matteo Baio, Politecnico di Milano, 06/2024
%


    if nargin == 0
        graphicPreset = 0;
    end

    plotFlag = struct;
    switch graphicPreset
        case 0
            plotFlag.text = false;          % print some results in command window
            plotFlag.convergence = true;    % plot convergence over time for previous selected plot
            plotFlag.aero = false;          % plot aero loads data over different angle of attack
            plotFlag.struct = true;         % plot structural loads data over different parametric input
        case 1
            plotFlag.text = true;           % print some results in command window
            plotFlag.convergence = true;    % plot convergence over time for previous selected plot
            plotFlag.aero = true;           % plot aero loads data over different angle of attack
            plotFlag.struct = true;         % plot structural loads data over different parametric input
        case 2
            plotFlag.text = false;          % print some results in command window
            plotFlag.convergence = false;   % plot convergence over time for previous selected plot
            plotFlag.aero = false;          % plot aero loads data over different angle of attack
            plotFlag.struct = false;        % plot structural loads data over different parametric input
        otherwise
            error('Insert a valid graphin preset value... Check function help');
    end

    % Graphic settings
    set(0,'defaulttextinterpreter','latex');  
    set(0,'defaultAxesTickLabelInterpreter','latex');  
    set(0,'defaultLegendInterpreter','latex');
    set(0,'DefaultLineLineWidth',1.5);

end