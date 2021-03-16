%% Loading the data
x = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\finalmix.csv'))';
y = (readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\finalmix_pressure.csv'))';

%% Feature Changes
%%% Converting the MRST output to darcy units
y = y * 0.00014503773800722; %psia

x(1:4,:) = x(1:4,:) * 0.00014503773800722; %psia
x(5:6,:) = x(5:6,:); %density and viscosity
x(10,:) = x(10,:) * 1.01325E+15; %mD
x(11,:) = x(11,:); %porosity fraction
x(12:13,:) = x(12:13,:) * 6.29; %bbl/day
x(7:9,:) = [];

%% Chosen Network Architecture
%%% Training options
rng(1);
net = fitnet([100, 50],'trainrp');
net.trainParam.epochs = 10000;
net.divideParam.trainRatio = 0.8;
net.divideParam.valRatio = 0.10;
net.divideParam.testRatio = 0.10;
net.trainParam.max_fail = 10;
%%% Training command
[net,tr] = train(net,x,y,'useGPU','yes','showResources','yes');
%%% Estimations
yTrain_true = y(:,tr.trainInd);
yTrain_estimates =sim(net,x(:,tr.trainInd),'useGPU','yes','showResources','yes');
yVal_true = y(:,tr.valInd);
yVal_estimates =sim(net,x(:,tr.valInd),'useGPU','yes','showResources','yes');
yTest_true = y(:,tr.testInd);
yTest_estimates =sim(net,x(:,tr.testInd),'useGPU','yes','showResources','yes');

%% Saving the trained network
DeepNet_finalmix = net;
save DeepNet_finalmix

%% Visualizing a training set example
y_train_ex_true = reshape(yTrain_true(:,1),[50,50]);
y_train_ex_est = reshape(yTrain_estimates(:,1),[50,50]);
figure("Name","Training Set Results")
subplot(1,3,1)
surf(1:50,1:50,(y_train_ex_true))
colormap("turbo")
xlabel('X')
ylabel('Y')
title('Ground Truth Pressures [psia]')
axis tight
shading interp
colorbar
subplot(1,3,2)
surf(1:50,1:50,(y_train_ex_est))
xlabel('X')
ylabel('Y')
title('Estimated Pressures [psia]')
axis tight
shading interp
colorbar
subplot(1,3,3)
surf(1:50,1:50,(y_train_ex_true-y_train_ex_est))
xlabel('X')
ylabel('Y')
title('Pressure Differences [psia]')
axis tight
shading interp
colorbar

%% Visualizing a Test Set Example
y_test_ex_true = reshape(yTest_true(:,1),[50,50]);
y_test_ex_est = reshape(yTest_estimates(:,1),[50,50]);

figure("Name","Test Set Results")
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