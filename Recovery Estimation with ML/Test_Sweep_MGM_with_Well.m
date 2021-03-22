clear
mrstModule add ad-core ad-blackoil ad-props mrst-gui
%% Dataset
df = readmatrix("newtestcase.csv");
poro = df(2501:5000,2);
perm_darcies = df(2501:5000,1);
rate_coef = df(2501:5000,4);
rho = df(2501:5000,5);
mu = df(2501:5000,6);
pwf_prod = df(2501:5000,3);
%% Dimensions and gridding of the reservoir
dims = [101 101];
G = cartGrid(dims, [101, 101] * meter);
G = computeGeometry(G);
for i=1:2500
        %% Petrophysical Properties
        rock = makeRock(G, perm_darcies(i)*darcy, poro(i));
        %% Fluid Properties
        fluid = initSimpleADIFluid('phases','WO','mu', [1,mu(i)]*centi*poise,...
            'n',[1, 1], 'rho', [1000, rho(i)]*kilogram/meter^3);
        %% Turning on the gravity effect:
        gravity reset on
        %% Defining the model, which contains necessary functions to simulate a mathematical model using the AD-solvers.
        model = TwoPhaseOilWaterModel(G,rock,fluid);
        %% Setting up initial state
        sW = 0*ones(G.cells.num, 1);
        s = [sW, 1 - sW]; %for each phase
        state = initResSol(G,100*barsa,s);

%         figure(1);
%         plotCellData(G,state.s(:,1),'EdgeColor','None')
%         axis equal tight on
%         colormap(jet(128));
%         title('Initial Water Saturation')
%         view(2)
%         xlabel('X (m)')
%         ylabel('Y (m)')
%         colorbar
%         caxis([0 1])
        %%  Set the boundary conditions and timesteps
        injR = sum(poreVolume(G,rock))/(400*day)*rate_coef(i);
        bc = [];
        dt = repmat(10*day,36, 1);
        W = [];
        W = addWell(W, G, rock, 1, 'Type', 'rate', 'Val', injR,'Sign',1, 'Radius'...
            , 0.1,'name', 'Inj', 'Comp_i', [1, 0]);
        W = addWell(W, G, rock, G.cells.num, 'Type', 'bhp', 'Val', pwf_prod(i)*barsa(),'Sign',-1, 'Radius'...
            , 0.1,'name', 'Prod','Comp_i', [0, 1]);
        schedule = simpleSchedule(dt,'bc',bc,'W',W);
        %% Simulate the problem
        [wellSols, states,  schedulereport] = simulateScheduleAD(state, model, schedule, 'Verbose', true);
        for j=1:36
            [inj_p(1,j), prod_p(1,j)] = wellSols{j,1}.bhp;
            [inj_qW(1,j), prod_qW(1,j)] = wellSols{j,1}.qWs;
            [inj_qO(1,j), prod_qO(1,j)] = wellSols{j,1}.qOs;
        end
        output = horzcat(inj_p,prod_p,inj_qW,prod_qW,inj_qO,prod_qO);
        writematrix(output,'rateandpdata5000.csv','WriteMode','append')
        fprintf('\n  <strong> Iteration: %d  </strong> \n',i)
        %% Plot the segregation process

%         colorbar off; title('t=0');
%         set(gca,'Position',[.13 .11 .335 .815]); subplot(1,2,2);
% %         for i = 1:numel(states)
%             % Neat title
%             str = ['t=', formatTimeRange(sum(dt(1:i)))];
% 
%             % Plotting
%             plotCellData(G, states{i}.s(:, 1),'EdgeColor','None')
%             title(str)
% 
%             % Make axis equal to show column structure
%             axis equal tight on
%             colormap(jet(128));
%             view(2)
%             colorbar
%             caxis([0, 1])
% 
%             drawnow
%         end
%         plotWellSols(wellSols)
end