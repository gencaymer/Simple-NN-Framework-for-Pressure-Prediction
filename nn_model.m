function [W1, b1, W2, b2, A2,cost] =nn_model(X,Y,n_h, num_iterations, alpha)
[n_x,n_h,n_y] = layer_sizes(X,Y,n_h);
[W1, b1, W2, b2] = initialize(n_x,n_h,n_y);
    for i=1:num_iterations
        [Z1, A1, Z2, A2] = forwardprop(X,W1,b1,W2,b2);
        cost = computeCost(A2,Y);
        [dW1, db1, dW2, db2] = backprop(X,Y,W1,b1,W2,b2,Z1,A1,Z2,A2);
        [W1, b1, W2, b2] = update(W1,b1,W2,b2,dW1,db1,dW2,db2,alpha);
        
        h = animatedline('Marker','+','Color','g');
        xlabel('Iteration Count')
        title('Average Cost Over Normalized Training Samples [-1,1]')
        grid on
        addpoints(h,i,mean(cost,'all'))
        drawnow
    end
    cost = mean(cost,'all');
    fprintf("Training set cost for %d nodes and %.3f gradient is: %f \n" ,n_h,alpha,cost)

end