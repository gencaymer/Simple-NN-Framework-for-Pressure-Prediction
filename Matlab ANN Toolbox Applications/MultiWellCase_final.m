%% Loading the data
X_load = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\multirate_change_new.csv'))';
Y_load = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\multirate_change_pressure_new.csv'))';

%% Feature Changes
%%% Converting the MRST output to darcy units
y = Y_load * 0.00014503773800722; %psia

x(1:4,:) = X_load(1:4,:) * 0.00014503773800722; %psia
x(5:6,:) = X_load(5:6,:);
x(7,:) = X_load(7,:) * 14.50; %psia
x(8:9,:) = X_load(8:9,:);
x(10,:) = X_load(10,:) * 1.01325E+15; %mD
x(11,:) = X_load(11,:);
x(12:13,:) = X_load(12:13,:) * 6.29; %bbl/day

%% Optimizing the network
%%% Trying out different hidden layer sizes to obtain the minimum error as
%%% possible.
rng(10)
nodes = [ 10 15 20 25];
mse_train = ones(1,length(nodes));
mse_val = ones(1,length(nodes));
for i = 1:length(nodes)
    hiddenLayerSize = nodes(i);
    net = fitnet(hiddenLayerSize,'trainrp');
    net.trainParam.epochs = 600;
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio = 0.15;
    [net,tr] = train(net,x,y);
    yTrain_true = y(:,tr.trainInd);
    yTrain_estimates = sim(net,x(:,tr.trainInd));
    yVal_true = y(:,tr.valInd);
    yVal_estimates = sim(net,x(:,tr.valInd));
    mse_train(i) = mean(((yTrain_estimates-yTrain_true).^2),'all');
    mse_val(i) = mean(((yVal_estimates-yVal_true).^2),'all');
end

%% Plotting the layer sizes vs cost
plot(nodes,mse_train); hold on;
plot(nodes,mse_val); xlabel('Layer Size'); ylabel('MSE'); legend('Training Cost','Validation Cost');
hold off;

%% Chosen Network Architecture
%%% Training options
net = fitnet(10,'trainscg');
%%% Training command
net.trainParam.epochs = 1300;
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;
[net,tr] = train(net,x,y);
%%% Estimations
yTrain_true = y(:,tr.trainInd);
yTrain_estimates = sim(net,x(:,tr.trainInd));
yVal_true = y(:,tr.valInd);
yVal_estimates = sim(net,x(:,tr.valInd));
yTest_true = y(:,tr.testInd);
yTest_estimates = sim(net,x(:,tr.testInd));
%%%Average Costs over all data
mse_train = mean(((yTrain_estimates-yTrain_true).^2),'all')
mse_val = mean(((yVal_estimates-yVal_true).^2),'all')
mse_test = mean(((yTest_estimates-yTest_true).^2),'all')

%% Saving the trained network
MultiWellNet = net;
save MultiWellNet

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