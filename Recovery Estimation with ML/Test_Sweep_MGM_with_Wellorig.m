clear
mrstModule add ad-core ad-blackoil ad-props mrst-gui
%% Dimensions and gridding of the reservoir
dims = [101 101];
G = cartGrid(dims, [101, 101] * meter);
G = computeGeometry(G);
%% Petrophysical Properties
rock = makeRock(G, 1000*milli*darcy, 0.25);
%% Fluid Properties
fluid = initSimpleADIFluid('phases','WO','mu', [1,10]*centi*poise,...
    'n',[1, 1], 'rho', [1000, 700]*kilogram/meter^3);
%% Turning on the gravity effect:
gravity reset on
%% Defining the model, which contains necessary functions to simulate a mathematical model using the AD-solvers.
model = TwoPhaseOilWaterModel(G,rock,fluid);
disp(model)
%% Setting up initial state
sW = 0*ones(G.cells.num, 1);
s = [sW, 1 - sW]; %for each phase
state = initResSol(G,100*barsa,s);

figure(1);
plotCellData(G,state.s(:,1),'EdgeColor','None')
axis equal tight on
colormap(jet(128));
title('Initial Water Saturation')
view(2)
xlabel('X (m)')
ylabel('Y (m)')
colorbar
caxis([0 1])
%%  Set the boundary conditions and timesteps
injR = sum(poreVolume(G,rock))/(400*day)*1.1;
bc = [];
% bc = fluxside(bc, G, 'Left', injR,1,1, 'sat', [1, 0]);
% bc = fluxside(bc, G, 'South', injR, 1, 1, 'sat', [1,0]);
% bc = pside(bc, G, 'Right', 100*barsa(),1,1,'sat',[0,1]);
% bc = pside(bc, G, 'North', 100*barsa(),1,1,'sat',[0,1]);
dt = repmat(20*day,40, 1);
% src = []; 
W = [];
W = addWell(W, G, rock, 1, 'Type', 'rate', 'Val', injR,'Sign',1, 'Radius'...
    , 0.1,'name', 'Inj', 'Comp_i', [1, 0]);
W = addWell(W, G, rock, G.cells.num, 'Type', 'bhp', 'Val', 100*barsa(),'Sign',-1, 'Radius'...
    , 0.1,'name', 'Prod','Comp_i', [0, 1]);
schedule = simpleSchedule(dt,'bc',bc,'W',W);
%% Simulate the problem
[wellSols, states,  schedulereport] = simulateScheduleAD(state, model, schedule, 'Verbose', true);
%% Plot the segregation process

colorbar off; title('t=0');
set(gca,'Position',[.13 .11 .335 .815]); subplot(1,2,2);
for i = 1:numel(states)
    % Neat title
    str = ['t=', formatTimeRange(sum(dt(1:i)))];
    
    % Plotting
    plotCellData(G, states{i}.s(:, 1),'EdgeColor','None')
    title(str)
    
    % Make axis equal to show column structure
    axis equal tight on
    colormap(jet(128));
    view(2)
    colorbar
    caxis([0, 1])
    drawnow, pause(0.2)
end
