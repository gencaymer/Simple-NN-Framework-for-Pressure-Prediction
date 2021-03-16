clc; clf; clear all;
Xx = readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\poroperm.csv');
Yy = readmatrix('C:\Users\GençayMerey\Desktop\Projects\Test\Simple-NN-Framework-for-Pressure-Prediction\Datasets\poroperm_pressure.csv');
X = Xx';
Y = Yy';

m = size(X,2);
%% Normalizing the dataset

[X,PS_X] = mapminmax(X,-1,1);
[Y,PS_Y] = mapminmax(Y,-1,1);
%% Splitting the dataset

P1 = 0.70;
P2 = 0.15;
idx = randperm(m);
trainInd = X(:,idx(1:round(P1*m))) ; 
trainOut =Y(:,idx(1:round(P1*m)));

cvInd = X(:,idx((round(P1*m)+1):round((P1+P2)*m)));
cvOut = Y(:,idx((round(P1*m)+1):round((P1+P2)*m)));

testInd = X(:,idx(((round((P1+P2)*m))+1):end));
testOut = Y(:,idx(((round((P1+P2)*m))+1):end));
%% Layer Sizes

nx = size(trainInd,1);
ny = size(trainOut,1);
%% Hyper parameters

n_hidden = 5;
alpha = 0.1;
epochs = 20;
%% nitializing the forward propagation

[n_x,n_h,n_y] = layer_sizes(trainInd,trainOut,n_hidden);
[W1, b1, W2, b2] = initialize(nx,n_hidden,ny);
%% Training Process

 for i=1:epochs
        [Z1, A1, Z2, A2] = forwardprop(trainInd,W1,b1,W2,b2);
        cost_train = computeCost(A2,trainOut);
        cost_train = mean(cost_train,'all');
        cost_cv = predict(cvInd,cvOut,W1,b1,W2,b2,PS_Y);
        [dW1, db1, dW2, db2] = backprop(trainInd,trainOut,W1,b1,W2,b2,Z1,A1,Z2,A2);
        [W1, b1, W2, b2] = update(W1,b1,W2,b2,dW1,db1,dW2,db2,alpha);
        
        dd = animatedline('Color','b','Marker','square','MarkerFaceColor','b');
        ff = animatedline('Color','r','Marker','square','MarkerFaceColor','r');
        addpoints(dd,i,cost_train)
        addpoints(ff,i,cost_cv)
        view(2)
        drawnow update
 end
 
%% Percantage Errors
perc_train = (cost_train/(1-(-1)))*100;
perc_cv =  (cost_cv/(1-(-1)))*100;
fprintf('<strong>Training cost is : %.2f%% </strong> \n',...
    perc_train)
fprintf('<strong>Cross Validation cost is : %.2f%%</strong> \n',...
    perc_cv)
[cost_test, A2_test] = predict(testInd,testOut,W1,b1,W2,b2,PS_Y);
perc_test =(cost_test/(1-(-1)))*100;
fprintf('<strong>Test cost is : %.2f%% </strong> \n',...
    perc_test)
%% Mean and STD calculations
rate_mean_tr = mean(trainInd(3,:),'all');
rate_mean_cv = mean(cvInd(3,:),'all');
rate_mean_test = mean(testInd(3,:),'all');
fprintf('Normalized means for porosity is = Training: %.5f , CV: %.5f, Test: %.5f \n',...
    rate_mean_tr,rate_mean_cv,rate_mean_test)

rate_std_tr= std(trainInd(3,:),0,2);
rate_std_cv= std(cvInd(3,:),0,2);
rate_std_test= std(testInd(3,:),0,2);
fprintf('Normalized deviations for porosity is = Training: %.5f , CV: %.5f, Test: %.5f \n',...
    rate_std_tr,rate_std_cv,rate_std_test)

rate_mean_tr = mean(trainInd(5,:),'all');
rate_mean_cv = mean(cvInd(5,:),'all');
rate_mean_test = mean(testInd(5,:),'all');
fprintf('Normalized means for permeabilty is = Training: %.5f , CV: %.5f, Test: %.5f \n',...
    rate_mean_tr,rate_mean_cv,rate_mean_test)

rate_std_tr= std(trainInd(5,:),0,2);
rate_std_cv= std(cvInd(5,:),0,2);
rate_std_test= std(testInd(5,:),0,2);
fprintf('Normalized deviations for permeability is = Training: %.5f , CV: %.5f, Test: %.5f \n',...
    rate_std_tr,rate_std_cv,rate_std_test)
%% Visualization
Y_again = mapminmax('reverse',testOut,PS_Y);
A2_again = mapminmax('reverse',A2_test,PS_Y);
Y_again_rand = reshape(Y_again(:,2),50,50);
A2_again_rand = reshape(A2_again(:,2),50,50);
Y_again_rand_bars = Y_again_rand /(10^5);
A2_again_rand_bars = A2_again_rand /(10^5);
difference = (Y_again_rand_bars-A2_again_rand_bars);

subplot(2,2,1)
surf(1:50,1:50,(Y_again_rand_bars))
xlabel('X')
ylabel('Y')
title('Ground Truth Pressures')
shading interp
axis tight
%view(2)
colorbar


subplot(2,2,3)
surf(1:50,1:50,(A2_again_rand_bars))
xlabel('X')
ylabel('Y')
title('Estimated Pressures')
shading interp
axis tight
%view(2)
colorbar

subplot(2,2,[2 4])
surf(1:50,1:50,difference)
xlabel('X')
ylabel('Y')
title('Pressure Difference in Bars')
shading interp
axis tight
colorbar