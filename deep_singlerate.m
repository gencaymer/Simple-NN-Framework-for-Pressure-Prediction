clc;  
%% Loading the data

X_load = readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\finalmix.csv');
Y_load = readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\finalmix_pressure.csv');
%% For convention the matrices are transposed as (n x m)

X = X_load';
Y = Y_load';

%% Dataset partition ratios
train_ratio = 0.7;
cv_ratio = 0.15;
test_ratio = 0.15;

m  = size(X,2);

[X_norm, PS_X] = mapminmax(X, -1, 1);
[Y_norm, PS_Y] = mapminmax(Y, -1, 1);

%% Splitting the dataset
[trainInd, cvInd, testInd] = divideind(X_norm,1:7000,7001:8500,8501:10000);
[trainOut, cvOut, testOut] = divideind(Y_norm,1:7000,7001:8500,8501:10000);

%% Hyper parameterss
nx = size(trainInd,1);
ny = size(trainOut,1);
n_hidden = 13;
alpha = 0.01;
epochs = 50;

%% Training Process
[w1,b1,w2,b2,w3,b3] = deep_initialize(nx,n_hidden,5,ny);
figure('Name','Training Graph')
title(['Training Process'])
xlabel('Epoch')
ylabel('Averaged Cost Over Examples')

for i=1:epochs
    [z1,a1,z2,a2,z3,a3]= deep_forward(trainInd,w1,b1,w2,b2,w3,b3);
    cost_train = computeCost(a3,trainOut);
    cost_train = mean(cost_train,'all');
    cost_cv = deep_predict(cvInd,cvOut,w1,b1,w2,b2,w3,b3);
    [dw1,db1,dw2,db2,dw3,db3] = deep_back(trainInd,trainOut,w1,b1,w2,b2,w3,b3,z1,a1,z2,a2,z3,a3);
    [w1,b1,w2,b2,w3,b3] = deep_update(w1,b1,w2,b2,w3,b3,dw1,db1,dw2,db2,dw3,db3,alpha);
    dd = animatedline('Color','b','Marker','square','MarkerFaceColor','b');
        ff = animatedline('Color','r','Marker','square','MarkerFaceColor','r');
        addpoints(dd,i,cost_train)
        addpoints(ff,i,cost_cv)
        drawnow update
end

%% Percentage Errors 
perc_train = (cost_train/2)*100
perc_cv = (cost_cv/2)*100
[cost_test, a3_test]= deep_predict(testInd,testOut,w1,b1,w2,b2,w3,b3);
perc_test = (cost_test/2)*100

A3_test = mapminmax('reverse',a3_test,PS_Y);
Y_test = mapminmax('reverse',testOut,PS_Y);
%Visualizing a random example
Y_test_ex = reshape(Y_test(:,50),50,50);
A3_test_ex = reshape(A3_test(:,50),50,50);
Y_test_ex_bars = Y_test_ex /(10^5);
A3_test_ex_bars = A3_test_ex /(10^5);
difference = (Y_test_ex_bars-A3_test_ex_bars);

figure
subplot(2,2,1)
surf(1:50,1:50,(Y_test_ex_bars))
colormap(turbo)
xlabel('X')
ylabel('Y')
title('Ground Truth Pressures')
shading interp
axis tight
colorbar


subplot(2,2,3)
surf(1:50,1:50,(A3_test_ex_bars))
xlabel('X')
ylabel('Y')
title('Estimated Pressures')
shading interp
axis tight

colorbar

subplot(2,2,[2 4])
surf(1:50,1:50,difference)

xlabel('X')
ylabel('Y')
title('Pressure Difference in Bars')
shading interp
axis tight

colorbar