function [W1, b1, W2, b2] = initialize(n_x,n_h,n_y)
W1 = randn(n_h,n_x)*0.30;
b1 = zeros(n_h,1);
W2 = randn(n_y,n_h)*0.30;
b2 = zeros(n_y,1);
end