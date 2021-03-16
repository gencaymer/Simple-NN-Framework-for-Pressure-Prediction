function [n_x,n_h,n_y] = layer_sizes(X,Y,nn)
%% Finds out layer sizes wrt to given input and output vectors/matrices.
n_x = size(X,1);
n_y = size(Y,1);
n_h = nn;
end