
%% Loading The Data
Xx = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\poroperm.csv'))';
Yy = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\poroperm_pressure.csv'))';

%% Feature Changes
%%% Converting the MRST output to darcy units
x(1,:) = Xx(1,:)*0.00014503773800722; %Pa to psia
x(2,:) = Xx(2,:)*1.01325E+15; %m2 to mD
x(3,:) = Xx(3,:);
x(4,:) = Xx(4,:);
x(5,:) = Xx(5,:)*6.29; %m3/day to bbl/day

y = Yy*0.00014503773800722; %Pa to psia

%% Optimizing the network
%%% Trying out different hidden layer sizes to get the lowest error
rng(10)
mse_train = ones(1,100);
mse_val = ones(1,100);
for i = 1:100
    hiddenLayerSize = i;
    net = fitnet(hiddenLayerSize,'trainscg');
    net.trainParam.epochs = 5000;
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
plot(1:100,mse_train); hold on;
plot(1:100,mse_val); xlabel('Layer Size'); ylabel('MSE'); legend('Training Cost','Validation Cost');
hold off;

%% Chosen Network Architecture
%%% Training options
hiddenLayerSize = 20;
net = fitnet(hiddenLayerSize,'trainscg');
net.trainParam.epochs = 5000;
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

%%%Average Costs over all data
mse_train = mean(((yTrain_estimates-yTrain_true).^2),'all')
mse_val = mean(((yVal_estimates-yVal_true).^2),'all')
mse_test= mean(((yTest_estimates-yTest_true).^2),'all')

%% Saving the trained network

PoroPerm20NodesNet = net;
save PoroPerm20NodesNet

%% Visualizing a training example
y_train_ex_true = reshape(yTrain_true(:,1),50,50);
y_train_ex_est = reshape(yTrain_estimates(:,1),50,50);

figure('Name','Training Set Example')
subplot(1,3,1)
surf(1:50,1:50,(y_train_ex_true))
xlabel('X')
ylabel('Y')
title('Ground Truth Pressures[psia]')
shading interp
axis tight
colorbar
subplot(1,3,2)
surf(1:50,1:50,(y_train_ex_est))
xlabel('X')
ylabel('Y')
title('Estimated Pressures[psia]')
shading interp
axis tight
colorbar
subplot(1,3,3)
surf(1:50,1:50,(y_train_ex_true-y_train_ex_est))
xlabel('X')
ylabel('Y')
title('Pressure Differences[psia]')
shading interp
axis tight
colorbar


%% Visualizing a Test Set Example
y_test_ex_true = reshape(yTest_true(:,1),50,50);
y_test_ex_est = reshape(yTest_estimates(:,1),50,50);

figure('Name','Test Set Example')
subplot(1,3,1)
surf(1:50,1:50,(y_test_ex_true))
xlabel('X')
ylabel('Y')
title('Ground Truth Pressures [psia]')
shading interp
axis tight
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

