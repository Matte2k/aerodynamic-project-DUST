
function Polar_Plotter(Polar, CD0_correct, geom, opcond, Name)

global init_flag
if init_flag == 0

    figure(1)
    hold on
    grid minor
    legend("show", 'Location', 'best')
    xlabel('$\alpha$', Interpreter='latex'); ylabel('$C_L$', Interpreter='latex')

    figure(2)
    hold on
    grid minor
    legend("show", 'Location', 'best')
    xlabel('$C_D$', Interpreter='latex'); ylabel('$C_L$', Interpreter='latex')

    figure(3)
    hold on
    grid minor
    legend("show", 'Location', 'best')
    xlabel('$\alpha$', Interpreter='latex'); ylabel('$C_m$', Interpreter='latex')

    figure(4)
    hold on
    grid minor
    legend("show", 'Location', 'best')
    xlabel('$C_L$', Interpreter='latex'); ylabel('$L/D$', Interpreter='latex')
    
    init_flag = 1;
end

Sref = geom(1);
c_ref = geom(2);
b_ref = geom(3);

Re = opcond(1);
Ma = opcond(2);
rho = opcond(3);

%% Drag Coefficient Correction

Polar.CD = Polar.CDi + CD0_correct;

%% CL-Alpha curve

figure(1)
plot(Polar.AoA, Polar.CL,'.-','LineWidth',2, 'MarkerSize', 15, 'DisplayName', Name)

%% CL-CD Curve

figure(2)
plot(Polar.CD, Polar.CL,'.-','LineWidth',2, 'MarkerSize', 15, 'DisplayName', Name)

%% CMY-alpha curve

figure(3)
plot(Polar.AoA, Polar.CMy,'.-','LineWidth',2, 'MarkerSize', 15, 'DisplayName', Name)

%% L/D-CL curve

figure(4)
plot(Polar.CL, Polar.CL./Polar.CD,'.-','LineWidth',2, 'MarkerSize', 15, 'DisplayName', Name)

end
