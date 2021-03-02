function [Z1, A1, Z2, A2] = forwardprop(X,W1,b1,W2,b2)
 Z1 = W1*X + b1;
    A1 = tanh(Z1);
    Z2 = W2*A1 + b2;
    A2 = tanh(Z2);
end