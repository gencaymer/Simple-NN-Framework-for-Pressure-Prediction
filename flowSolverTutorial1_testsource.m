
mrstModule add incomp

inj = 20 + (200-20)*rand(8000,1);
for i=1:size(inj,1)
%% Define the model
% To set up a model, we need: a grid, rock properties (permeability), a
% fluid object with density and viscosity, and boundary conditions.
gravity reset off
[nx,ny] = deal(50, 50);
[Lx,Ly] = deal(50, 50);
G          = cartGrid([nx,ny], [Lx,Ly]);
G          = computeGeometry(G);
rock       = makeRock(G, 0.1*darcy, 0.5);
fluid      = initSingleFluid('mu' ,    1*centi*poise, ...
                             'rho', 1014*kilogram/meter^3);
bc  = pside([], G, 'West', 70.*barsa());
bc  = pside(bc, G, 'East', 70.*barsa());
bc  = pside(bc, G, 'South', 70.*barsa());
bc  = pside(bc, G, 'North', 70.*barsa());
source_cell_index = 1175;
src=addSource([],source_cell_index,inj(i)*meter^3/day);
%% Assemble and solve the linear system
% To solve the flow problem, we use the standard two-point
% flux-approximation method (TPFA), which for a Cartesian grid is the same
% as a classical seven-point finite-difference scheme for Poisson's
% equation. This is done in two steps: first we compute the
% transmissibilities and then we assemble and solve the corresponding
% discrete system.
T   = computeTrans(G, rock);
p_in = 100;
sol = incompTPFA(initResSol(G, p_in.*barsa()), G, T, fluid, 'bc', bc, 'src',src);
cp = 1
input = [ bc.value(1) bc.value(2) bc.value(3) bc.value(4) fluid.rhoWS(1) cp(1) p_in(1) source_cell_index(1) rock.perm(1) rock.poro(1) src.rate(1)];
fprintf('\nIteration: %d \n',i)
%% Plot the face pressures
clf
%plotFaces(G, 1:G.faces.num, convertTo(sol.facePressure, barsa()));
plotCellData(G, convertTo(sol.pressure, barsa()));
plotGrid(G, src.cell, 'FaceColor', 'w');
%set(gca, 'ZDir', 'reverse'), 
title('Pressure [bar]')
view(2), colorbar
%set(gca,'DataAspect',[1 1 1]);
drawnow
writematrix(input,'rate_change.csv','WriteMode','append')
writematrix(sol.pressure','rate_change_pressure.csv','WriteMode','append')
end