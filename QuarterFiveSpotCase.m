%% 2D- Solver with 1 injector  and 1 producer %%
mrstModule add incomp

rate1 = (0.10 + (0.35-0.10)*rand(10,1))/10^4;
poro = 0.2;
perm = 100;
visc = 10;
for i=1:length(rate1)
    %% Grid % Petrophysical Data
    [nx,ny] = deal(50);
    G = cartGrid([nx,ny],[50,50]);
    G = computeGeometry(G);
    rock = makeRock(G,perm*milli*darcy, poro);
    %% Half transmissibilities
    hT = computeTrans(G,rock);
    %% Fluid Model
    fluid = initSingleFluid('mu',visc*centi*poise,'rho', 1014*kilogram/meter^3);
    %% Source Terms
    src = addSource([],1175,rate1(i)); %Injector at the bottom-left corner
    src = addSource(src,1975,rate1(i)); %Producer at the top-right corner
    %% Initial State
    state = initResSol(G,0.0,1.0); %Zero presure with unit saturation
    %% TPFA Solver
    state = incompTPFA(state,G,hT,fluid,'src',src);
    %% Visualizing the results
    plotCellData(G, convertTo(state.pressure, psia()));
    plotGrid(G,src.cell,'FaceColor','w');
    xlabel('X [m]')
    ylabel('Y [m]')
    title('Pressure Distribution [psia]')
    axis equal tight; colormap(turbo(128)); colorbar
    drawnow

    %% Forming the CSV file
    features = [poro perm fluid.rhoWS visc rate1(i) -rate1(i)];
%     writematrix(features,'quarter_input.csv','WriteMode','append')
%     writematrix(convertTo(state.pressure, psia())','quarter_pressure.csv','WriteMode','append')
    display(i)
end