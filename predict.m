function [cost,A2] = predict(x,y,W1,b1,W2,b2,~)
    m = size(x,2);
    %Normalization of the input and output
%     x_n = mapminmax(x,-1,1);
%     [Yn,PS] = mapminmax(y,-1,1);    
    %Forward propagation to get the estimation
    Z1 = W1*x + b1;
    A1 = tanh(Z1);
    Z2 = W2*A1 + b2;
    A2 = max(0,Z2);
    sqrErrors= (A2-y).^2;
    cost =1./(2*m).*sum(sqrErrors);
    cost = mean(cost,'all');
%     fprintf("Cross Validation set cost is: %f  \n" ,cost)
%     
%     %Denormalization of the output
%     y_again = mapminmax('reverse',y,PS);
%     A2_again = mapminmax('reverse',A2,PS);
%     %Reshaping the matrix to display in grids
%     Y_again_rand = reshape(y_again(:,3),50,50);
%     A2_again_rand = reshape(A2_again(:,3),50,50);
%     Y_again_rand_bars = Y_again_rand /(10^5);
%     A2_again_rand_bars = A2_again_rand /(10^5);
%     difference = (Y_again_rand_bars-A2_again_rand_bars);
    
%   Plotting the results
%     figure('Name','CV Data');
%     subplot(2,2,1)
%     surf(1:50,1:50,(Y_again_rand)/10^5)
%     xlabel('X')
%     ylabel('Y')
%     title('Ground Truth Pressures')
%     shading interp
%     axis tight
%     %view(2)
%     colorbar
%     subplot(2,2,3)
%     surf(1:50,1:50,(A2_again_rand)/10^5)
%     xlabel('X')
%     ylabel('Y')
%     title('Estimated Pressures')
%     shading interp
%     axis tight
%     %view(2)
%     colorbar
%     subplot(2,2,[2 4])
%     surf(1:50,1:50,difference)
%     xlabel('X')
%     ylabel('Y')
%     title('Pressure Difference in Bars')
%     shading interp
%     axis tight
%     colorbar
    
    
    
