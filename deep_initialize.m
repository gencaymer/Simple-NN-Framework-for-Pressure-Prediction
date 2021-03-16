function [W1,b1,W2,b2,W3,b3] = deep_initialize(n_x,n_h1,n_h2,n_y)
W1 = randn(n_h1,n_x)*0.05;
b1 = zeros(n_h1,1);
W2 = randn(n_h2,n_h1)*0.05;
b2 = zeros(n_h2,1);
W3 = randn(n_y,n_h2)* 0.05;
b3 = zeros(n_y,1);
end
