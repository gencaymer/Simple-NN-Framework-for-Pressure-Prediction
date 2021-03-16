
mrstModule add incomp

inj1 = 20 + (150-20)*rand(10000,1); %m3/day
inj2 = 20 + (150-20)*rand(10000,1); %m3/day
poro = 0.2 + (0.32-0.2)*rand(10000,1); %fraction
perm = 0.07 + (0.15-0.07)*rand(10000,1); %darcy
mu = 1 + (30-1)*rand(10000,1); %cp
rho = 950 + (1050-950)*rand(10000,1); %kg/m3
bcc = 20 + (100-20)*rand(10000,1); %bars
for i=1:size(inj1,1)
%% Define the model
% To set up a model, we need: a grid, rock properties (permeability), a
% fluid object with density and viscosity, and boundary conditions.
gravity reset off
[nx,ny] = deal(50, 50);
[Lx,Ly] = deal(50, 50);
G          = cartGrid([nx,ny], [Lx,Ly]);
G          = computeGeometry(G);
rock       = makeRock(G, perm(i)*darcy, poro(i));
fluid      = initSingleFluid('mu' ,    mu(i)*centi*poise, ...
                             'rho', rho(i)*kilogram/meter^3);
bc  = pside([], G, 'West', bcc(i).*barsa());
bc  = pside(bc, G, 'East', bcc(i).*barsa());
bc  = pside(bc, G, 'South', bcc(i).*barsa());
bc  = pside(bc, G, 'North', bcc(i).*barsa());

src=addSource([],1175,inj1(i)*meter^3/day);
src = addSource(src,1975,inj2(i)*meter^3/day);
%% Assemble and solve the linear system

T   = computeTrans(G, rock);
p_in = 20;
sol = incompTPFA(initResSol(G, p_in*barsa()), G, T, fluid,'bc',bc, 'src',src);
input = [ bcc(i)*100000 bcc(i)*100000 bcc(i)*100000 bcc(i)*100000 rho(i) mu(i) p_in(1) 1175 1975 perm(i)*9.87*10^-13 poro(i) inj1(i) inj2(i)];
%% Plot the face pressures
clf
plotFaces(G, 1:G.faces.num, convertTo(sol.facePressure, psia()));
plotCellData(G, convertTo(sol.pressure, psia()));
plotGrid(G, src.cell, 'FaceColor', 'w');
set(gca, 'ZDir', 'reverse'), 
title('Pressure [psia]')
view(2), colorbar
%set(gca,'DataAspect',[1 1 1]);
drawnow
writematrix(input,'finalmix.csv','WriteMode','append')
writematrix(sol.pressure','finalmix_pressure.csv','WriteMode','append')
fprintf('\nIteration: %d \n',i)
end