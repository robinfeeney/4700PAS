winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15 % Total length of simulation
f = 230e12; %frequency
lambda = c_c/f;

xMax{1} = 20e-6; %Total distance
nx{1} = 200; %Number of times distance should update
nx{2} = 400;
ny{1} = 0.75*nx{1}; %setting height to be 75 percent of width


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0;

epi{1} = ones(nx{1},ny{1})*c_eps_0;
epi{1}(30:170,35:45)= c_eps_0*11.3; % This is what creates the inclusion - you can comment this out / add more here
epi{1}(25:45,45:65)= c_eps_0*11.3;
epi{1}(155:175,45:65)= c_eps_0*11.3;
epi{1}(70:90,80:100)= c_eps_0*11.3;
epi{1}(110:130,80:100)= c_eps_0*11.3;



sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1}; % Distance to be moved per update
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2); %How many times the source should update
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 5;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];


bc{1}.NumS = 1; %Setting of values for boundary conditions
bc{1}.s(1).xpos = nx{1}/(4) + 1; % bc.s(1) is setting the source
bc{1}.s(1).type = 'ss'; % setting the type of source
bc{1}.s(1).fct = @PlaneWaveBC; %Setting function of source to be PlaneWaveBC

% bc{1}.s(2).xpos = floor(nx{1}/(3)) + 1; % bc.s(2) is setting the source
% bc{1}.s(2).type = 'ss'; % setting the type of source
% bc{1}.s(2).fct = @PlaneWaveBC; %Setting function of source to be PlaneWaveBC
% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
st = -0.05; % updating this makes the wave much more visible - adjusted back as it was a LOT with the added inclusions
s = 0;
y0 = yMax/2;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
%bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,y0/2,sty,'s'};

Plot.y0 = round(y0/dx);

bc{1}.xm.type = 'a';
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 0 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






