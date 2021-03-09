
mrstModule add incomp

inj1 = 20 + (150-20)*rand(10000,1); %m3/day
inj2 = 20 + (150-20)*rand(10000,1); %m3/day
for i=1:size(inj1,1)
%% Define the model
% To set up a model, we need: a grid, rock properties (permeability), a
% fluid object with density and viscosity, and boundary conditions.
gravity reset off
[nx,ny] = deal(50, 50);
[Lx,Ly] = deal(50, 50);
G          = cartGrid([nx,ny], [Lx,Ly]);
G          = computeGeometry(G);
rock       = makeRock(G, 0.1*darcy, 0.2);
fluid      = initSingleFluid('mu' ,    1*centi*poise, ...
                             'rho', 1014*kilogram/meter^3);
bc  = pside([], G, 'West', 20.*barsa());
bc  = pside(bc, G, 'East', 20.*barsa());
bc  = pside(bc, G, 'South', 20.*barsa());
bc  = pside(bc, G, 'North', 20.*barsa());

src=addSource([],1175,inj1(i)*meter^3/day);
src = addSource(src,1975,inj2(i)*meter^3/day);
%% Assemble and solve the linear system

T   = computeTrans(G, rock);
p_in = 20;
sol = incompTPFA(initResSol(G, p_in*barsa()), G, T, fluid,'bc',bc, 'src',src);
cp = 1;
input = [ bc.value(1) bc.value(2) bc.value(3) bc.value(4) fluid.rhoWS(1) cp(1) p_in(1) 1175 1975 rock.perm(1) rock.poro(1) inj1(i) inj2(i)];
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
writematrix(input,'multirate_change_new.csv','WriteMode','append')
writematrix(sol.pressure','multirate_change_pressure_new.csv','WriteMode','append')
fprintf('\nIteration: %d \n',i)
end