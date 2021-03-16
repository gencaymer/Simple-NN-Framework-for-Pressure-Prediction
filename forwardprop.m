function [Z1, A1, Z2, A2] = forwardprop(X,W1,b1,W2,b2)
%% Forward Propagation function according to a simple network with tanh as activation function and reLu as output
 Z1 = W1*X + b1;
    A1 = tanh(Z1);
    Z2 = W2*A1 + b2;
    A2 = max(0,Z2);
end