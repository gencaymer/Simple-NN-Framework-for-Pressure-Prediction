
mrstModule add incomp
% To set up a model, we need: a grid, rock properties (permeability), a
% fluid object with density and viscosity, and boundary conditions.
gravity reset off
poro_mean = 0.25;
poro_std = 0.08;
poro = 0.25;
perm = lognrnd(0.30,0.62,[1,1])*0.1 ;
bc_pa = linspace(100,150,3000);

for k = 1:numel(bc_pa)
for j=1:numel(perm)
for i=1:numel(poro)
[nx,ny] = deal(50, 50);
[Lx,Ly] = deal(50, 50);
G          = cartGrid([nx,ny], [Lx,Ly]);
G          = computeGeometry(G);
rock       = makeRock(G, perm(j)*darcy, poro(i));
mu = 10;
fluid      = initSingleFluid('mu' ,   mu*centi*poise, ...
                             'rho', 1014*kilogram/meter^3);
bc  = pside([], G, 'West', bc_pa(k).*barsa());
bc  = pside(bc, G, 'East', bc_pa(k).*barsa());
bc  = pside(bc, G, 'South', bc_pa(k).*barsa());
bc  = pside(bc, G, 'North', bc_pa(k).*barsa());
source_cell_index = 1175;
pv  = poreVolume(G,rock);
src=addSource([],source_cell_index,(pv(1)/3600)*meter^3/second);

T   = computeTrans(G, rock);
p_in = 20;
sol = incompTPFA(initResSol(G, (p_in).*barsa()), G, T, fluid, 'bc', bc, 'src',src);
input = [ bc.value(1) ...
     rock.perm(1) rock.poro(1) mu p_in src.rate];
% plotFaces(G, 1:G.faces.num, convertTo(sol.facePressure, barsa()));
% plotCellData(G, convertTo(sol.pressure, barsa()));
% plotGrid(G, src.cell, 'FaceColor', 'w');
% %set(gca, 'ZDir', 'reverse'), 
% title('Pressure [bar]')
% axis equal tight
% view(2), colorbar
% set(gca,'DataAspect',[1 1 1]);
% drawnow
writematrix(input,'bc_limitedrange.csv','WriteMode','append')
writematrix(sol.pressure','bc_pressure_limited.csv','WriteMode','append')
disp([k j i])
end
end
end
