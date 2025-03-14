Coupled = 1;
TwoCarriers = 1;
RC = 1;

nx = 201;
l = 1e-6;

x =linspace(0,l,nx);
dx = x(2)-x(1);
xm = x(1:nx-1) + 0.5*dx;

%Nd for linear gradient
% Nd = linspace(1e16 * 1e6, 20e16 * 1e6, nx); % Const. 1/cm3 (100 cm/m)^3
% NetDoping = ones(1,nx).*Nd; % doping

%Nd for exponential gradient
Nd = 2e16 * 1e6; %Const. 1/cm3 (100cm/m)^3
a = 5e6;
NetDoping = Nd*exp(-a.*x); %doping

x0 = l/2;
nw = l/20;

%npDisturbance = 1e16*1e6*exp(-((x-x0)/nw).^2);
% Turn npDisturbance off
npDisturbance = 0;
LVbc = 0;
RVbc = 0;

TStop = 14200000*1e-18;
PlDelt = 100000*1e-18;

%axis for linear gradient
% PlotYAxis = {[-3e-2 2e-2] [-2e5 2e6] [-1.5e4 1.5e4]...
%     [0 2e23] [0 6e21] [0 6e44]...
%     [-2e33 2e34] [-1.1e33 2e33] [-1.1e9 4e9] ...
%     [-2.5e7 4e7] [-10e-3 10e-3] [0 2.1e23]};

%axis for exponential gradient
PlotYAxis = {[-4e-2 1e-1] [-2e5 1.5e5] [5e2 1.5e3]...
    [0 1.5e22] [0 3.2e21] [0 1.6e43]...
    [-1e33 5e32] [-6e32 2.5e32] [-2e7 4e7] ...
    [-2.5e7 1.5e7] [-10e-3 10e-3] [0 2.1e22]};

doPlotImage = 0;
PlotFile = 'Gau2Car.gif';
