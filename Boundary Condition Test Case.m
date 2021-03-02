Xx = readmatrix('bc_limitedrange.csv');
Yy = readmatrix('bc_pressure_limited.csv');
X = Xx';
Y = Yy';
m = size(X,2);
X = mapminmax(X,-1,1);
[Y,PS] = mapminmax(Y,-1,1);

P = 0.70;
idx = randperm(m);
trainInd = X(:,idx(1:round(P*m))) ; 
testInd = X(:,idx(round(P*m)+1:end)) ;
trainOut =Y(:,idx(1:round(P*m)));
testOut = Y(:,idx(round(P*m)+1:end));

% [trainInd,testInd] = divideind(X,1:600,600:end);
% [trainOut,testOut] = divideind(Y,1:600,600:end);
[nx,mi] = size(trainInd);
[ny,mo] = size(trainOut);
n_hidden = 7;

%Normalizing the data between (-1,1)


alpha = 0.1;
num_iterations = 100;
[W1, b1, W2, b2, A2, cost] = nn_model(trainInd,trainOut,n_hidden, num_iterations, alpha);

Y_again = mapminmax('reverse',trainOut,PS);
A2_again = mapminmax('reverse',A2,PS);
Y_again_rand = reshape(Y_again(:,1),50,50);
A2_again_rand = reshape(A2_again(:,1),50,50);
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

predict(testInd,testOut,W1,b1,W2,b2,PS)

