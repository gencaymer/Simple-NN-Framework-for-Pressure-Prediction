%% Loading the data
X_load = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\rate_change.csv'))';
Y_load = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\rate_change_pressure.csv'))';
% For convention, the data is transposed such that n x m
%% Feature Changes
%%% Converting the MRST output to darcy units
x((1:4),:) = X_load((1:4),:)*0.00014503773800722; % BC, psia
x(5,:) = X_load(5,:); % density kg/m3
x(6,:) = X_load(6,:); % Viscosity, cp
x(7,:) = X_load(7,:) * 14.7 ; % Initial Pressure,psia
x(8,:) = X_load(8,:); % Well Index
x(9,:) = X_load(9,:)*1.01325E+15; %Permeability, mD
x(10,:) = X_load(10,:); %Porosity, fraction
x(11,:) = X_load(11,:)*6.29; %Inj.Rate, bbl/day

y = Y_load*0.00014503773800722; % Results, psia
%% Optimizing the network
%%% Trying out different hidden layer sizes to obtain the minimum error as
%%% possible.

% LayerSizes = [1 10 15 20 25 30 35 40 50 100];
rng(10)
% for i=2:5
%     hiddenLayerSize = LayerSizes(i);
%     net = fitnet(hiddenLayerSize,'trainscg');
%     net.trainParam.epochs = 1100;
%     net.divideParam.trainRatio = 0.7;
%     net.divideParam.valRatio = 0.15;
%     net.divideParam.testRatio = 0.15;
%     [net,tr] = train(net,x,y);
%     yTrain_true = y(:,tr.trainInd);
%     yTrain_estimates = sim(net,x(:,tr.trainInd));
%     yVal_true = y(:,tr.valInd);
%     yVal_estimates = sim(net,x(:,tr.valInd));
%     mse_train(i) = mean(((yTrain_estimates-yTrain_true).^2),'all');
%     mse_val(i) = mean(((yVal_estimates-yVal_true).^2),'all');
% end
%% Plotting the layer sizes vs cost
% plot(LayerSizes(:,2:5),mse_val(:,2:5),'o');
% xlabel('Size of the Hidden Layer')
% ylabel('Average Cost [psia]')
% hold on
% plot(LayerSizes(:,2:5),mse_train(:,2:5),'+');
%% Chosen Network Architecture
%%% Training options
    net = fitnet(10,'trainscg');
    net.trainParam.epochs = 1100;
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio = 0.15;
    %%% Training command
    [net,tr] = train(net,x,y);
    %%% Estimations
    yTrain_true = y(:,tr.trainInd);
    yTrain_estimates = sim(net,x(:,tr.trainInd));
    yVal_true = y(:,tr.valInd);
    yVal_estimates = sim(net,x(:,tr.valInd));
    yTest_true = y(:,tr.testInd);
    yTest_estimates = sim(net,x(:,tr.testInd));
    mse_train_opt = mean(((yTrain_estimates-yTrain_true).^2),'all')
    mse_val_opt = mean(((yVal_estimates-yVal_true).^2),'all')
    mse_test_opt = mean(((yTest_estimates-yTest_true).^2),'all')
%% Saving the trained network
SingleRate10Net = net;
save SingleRate10Net

%% Visualizing a training set example
y_train_ex_true = reshape(yTrain_true(:,1),50,50);
y_train_ex_est = reshape(yTrain_estimates(:,1),50,50);

figure(1)
subplot(1,3,1)
surf(1:50,1:50,(y_train_ex_true))
colormap("turbo")
xlabel('X')
ylabel('Y')
title('Ground Truth Pressures[psia]')
axis tight
shading interp
colorbar
subplot(1,3,2)
surf(1:50,1:50,(y_train_ex_est))
xlabel('X')
ylabel('Y')
title('Estimated Pressures[psia]')
axis tight
shading interp
colorbar
subplot(1,3,3)
surf(1:50,1:50,(y_train_ex_true-y_train_ex_est))
xlabel('X')
ylabel('Y')
title('Pressure Differences[psia]')
axis tight
shading interp
colorbar

%% Visualizing a Test Set Example
y_test_ex_true = reshape(yTest_true(:,1),50,50);
y_test_ex_est = reshape(yTest_estimates(:,1),50,50);
figure(2)
subplot(1,3,1)
surf(1:50,1:50,(y_test_ex_true))
xlabel('X')
ylabel('Y')
title('Ground Truth Pressures [psia]')
shading interp
axis tight
colormap("turbo")
colorbar
subplot(1,3,2)
surf(1:50,1:50,(y_test_ex_est))
xlabel('X')
ylabel('Y')
title('Estimated Pressures [psia]')
shading interp
axis tight
colorbar
subplot(1,3,3)
surf(1:50,1:50,(y_test_ex_true-y_test_ex_est))
xlabel('X')
ylabel('Y')
title('Pressure Differences [psia]')
shading interp
axis tight
colorbar