clf; clc; clear all;
%% Loading the data
X_load = readmatrix('rate_change.csv');
Y_load = readmatrix('rate_change_pressure.csv');
%% For convention the matrices are transposed as (n x m)
X_load = X_load';
Y_load = Y_load';

%% Trying different m values
dataset_sizes = [1000 2500 4000 6000 9000 10500];
train_ratio = 0.7;
cv_ratio = 0.15;
test_ratio = 0.15;

for j=1:numel(dataset_sizes)
    
X = X_load(:,1:dataset_sizes(j)) ; 
Y = Y_load(:,1:dataset_sizes(j)) ;
m = size(X,2);

%% Normalizing the input-target between (-1,1)
[X_norm, PS_X] = mapminmax(X, -1, 1);
[Y_norm, PS_Y] = mapminmax(Y, -1, 1);

%% Splitting the dataset: training, cv and test
[trainInd,cvInd,testInd] = divideind(X_norm,(1:(round(m*train_ratio))),((round(m*train_ratio+1)...
    :(round(m*(train_ratio+cv_ratio))))),(round((m*(train_ratio+cv_ratio)+1)):dataset_sizes(j)));
[trainOut,cvOut,testOut] = divideind(Y_norm,(1:(round(m*train_ratio))),((round(m*train_ratio+1)...
    :(round(m*(train_ratio+cv_ratio))))),(round((m*(train_ratio+cv_ratio)+1)):dataset_sizes(j)));

rate_mean_tr(j) = mean(trainInd(11,:),'all');
rate_mean_cv(j) = mean(cvInd(11,:),'all');
rate_mean_test(j) = mean(testInd(11,:),'all');
fprintf('Normalized means for dataset %d are= Training: %.5f , CV: %.5f, Test: %.5f \n',j,...
    rate_mean_tr(j),rate_mean_cv(j),rate_mean_test(j))

rate_std_tr(j)= std(trainInd(11,:),0,2);
rate_std_cv(j)= std(cvInd(11,:),0,2);
rate_std_test(j)= std(testInd(11,:),0,2);
fprintf('Normalized Deviations for dataset %d are= Training: %.5f , CV: %.5f, Test: %.5f \n',j,...
    rate_std_tr(j),rate_std_cv(j),rate_std_test(j))
%% Layer sizes for the input and the output layer
nx = size(trainInd,1);
ny = size(trainOut,1);

%% Hyper parameters
n_hidden = 5;
alpha = 0.1;
epochs = 30;

%% Training Process
[n_x,n_h,n_y] = layer_sizes(trainInd,trainOut,n_hidden);
[W1, b1, W2, b2] = initialize(nx,n_hidden,ny);
figure('Name','Training Graph')
title(['Training process for ',num2str(j),'. dataset'])
xlabel('Epoch')
ylabel('Averaged Cost Over Examples')
  for i=1:epochs
        [Z1, A1, Z2, A2] = forwardprop(trainInd,W1,b1,W2,b2);
        cost_train = computeCost(A2,trainOut);
        cost_train(j) = mean(cost_train,'all');
        cost_cv(j) = predict(cvInd,cvOut,W1,b1,W2,b2,PS_Y);
        [dW1, db1, dW2, db2] = backprop(trainInd,trainOut,W1,b1,W2,b2,Z1,A1,Z2,A2);
        [W1, b1, W2, b2] = update(W1,b1,W2,b2,dW1,db1,dW2,db2,alpha);
        
        dd = animatedline('Color','b','Marker','square','MarkerFaceColor','b');
        ff = animatedline('Color','r','Marker','square','MarkerFaceColor','r');
        addpoints(dd,i,cost_train(j))
        addpoints(ff,i,cost_cv(j))
        view(2)
        drawnow update
  end
  
%% Percentage errors
perc_train(j) = (cost_train(j)/(1-(-1)))*100;
perc_cv(j) =  (cost_cv(j)/(1-(-1)))*100;
fprintf('<strong>Training cost for  dataset %d  is : %.2f%% </strong> \n',j,...
    perc_train(j))
fprintf('<strong>Cross Validation cost for  dataset %d  is : %.2f%%</strong> \n',j,...
    perc_cv(j))
[cost_test(j), A2_test] = predict(testInd,testOut,W1,b1,W2,b2,PS_Y);
perc_test(j) =(cost_test(j)/(1-(-1)))*100;
fprintf('<strong>Test cost for dataset %d  is : %.2f%% </strong> \n',j,...
    perc_test(j))
fprintf('---------------------------------------------------------------------\n')
end
%% Plotting the overall Results
figure('Name','Error Graph for Datasets')
plot(dataset_sizes, perc_train,'-bs')
title('Error Measurements for Various Dataset Dimensions')
xlabel('Dataset Size - m')
ylabel('Error(%)')
hold on 
plot(dataset_sizes, perc_cv,'-rs')
hold on
plot(dataset_sizes, perc_test,'-ks')
legend('Training Set','Cross-Validation Set','Test Set')
hold off
%%
% %% Denormalizing the test data
% Y_test = mapminmax('reverse',testOut,PS_Y);
% A2_test = mapminmax('reverse',A2_test,PS_Y);


% %Visualizing a random example
% Y_test_ex = reshape(Y_test(:,35),50,50);
% A2_test_ex = reshape(A2_test(:,35),50,50);
% Y_test_ex_bars = Y_test_ex /(10^5);
% A2_test_ex_bars = A2_test_ex /(10^5);
% difference = (Y_test_ex_bars-A2_test_ex_bars);

% figure
% subplot(2,2,1)
% surf(1:50,1:50,(Y_test_ex_bars))
% colormap(turbo)
% xlabel('X')
% ylabel('Y')
% title('Ground Truth Pressures')
% shading interp
% axis tight
% view(2)
% colorbar
% 
% 
% subplot(2,2,3)
% surf(1:50,1:50,(A2_test_ex_bars))
% xlabel('X')
% ylabel('Y')
% title('Estimated Pressures')
% shading interp
% axis tight
% view(2)
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
% view(2)
% colorbar


