
%% Loading the data

X_load = readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\finalmix.csv');
Y_load = readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\finalmix_pressure.csv');

%% Transpose, (nxm)
X = X_load' ; 
Y = Y_load' ;
m = size(X_load,2);

%% Data Partition ratios;
train_ratio = 0.7;
cv_ratio = 0.15;
test_ratio = 0.15;

%% Hyperparameter search
alpha = 0.01;
n_hidden = 10;
epochs = 30;

%% Normalizing the data between (-1,1)
[X_norm, PS_X] = mapminmax(X, -1, 1);
[Y_norm, PS_Y] = mapminmax(Y, -1, 1);

%% Splitting the dataset
[trainInd, cvInd, testInd] = divideind(X_norm,1:7000,7001:8500,8501:10000);
[trainOut, cvOut, testOut] = divideind(Y_norm,1:7000,7001:8500,8501:10000);

%% Training Process
[W1, b1, W2, b2, A2, cost_train] = nn_model(trainInd, trainOut,...
    n_hidden, epochs, alpha);
    cost_train = cost_train;
    cost_cv = predict(cvInd,cvOut,W1,b1,W2,b2);
    [cost_test, A2_test] = predict(testInd,testOut,W1,b1,W2,b2);
    
%% Percentage errors
perc_train = (cost_train/2)*100;
perc_cv = (cost_cv/2)*100;
fprintf('<strong>Training cost for  alpha %.2f and node number %d  is: %.2f%% </strong> \n',alpha,n_hidden,...
    perc_train)
fprintf('<strong>Cross Validation cost for  alpha %.2f and node number %d  is: %.2f%%</strong> \n',alpha,n_hidden,...
    perc_cv)
perc_test =(cost_test/2)*100;
fprintf('<strong>Test cost for  alpha %.2f and node number %d  is: %.2f%% </strong> \n',alpha,n_hidden,...
    perc_test)
fprintf('---------------------------------------------------------------------\n')

%% Visualizing a random example
% A2_test = mapminmax('reverse',A2_test,PS_Y);
% Y_test = mapminmax('reverse',testOut,PS_Y);
% Y_test_ex = reshape(Y_test(:,50),50,50);
% A2_test_ex = reshape(A2_test(:,50),50,50);
% Y_test_ex_bars = Y_test_ex /(10^5);
% A2_test_ex_bars = A2_test_ex /(10^5);
% difference = (Y_test_ex_bars-A2_test_ex_bars);
% 
% subplot(2,2,1)
% surf(1:50,1:50,(Y_test_ex_bars))
% colormap(turbo)
% xlabel('X')
% ylabel('Y')
% title('Ground Truth Pressures')
% shading interp
% axis tight
% colorbar
% 
% subplot(2,2,3)
% surf(1:50,1:50,(A2_test_ex_bars))
% xlabel('X')
% ylabel('Y')
% title('Estimated Pressures')
% shading interp
% axis tight
% colorbar
% 
% subplot(2,2,[2 4])
% surf(1:50,1:50,difference)
% 
% xlabel('X')
% ylabel('Y')
% title('Pressure Difference in Bars')
% shading interp
% axis tight
% colorbar

