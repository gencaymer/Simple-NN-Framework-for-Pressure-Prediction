function [w1,b1,w2,b2,w3,b3] = deep_update(w1,b1,w2,b2,w3,b3,dw1,db1,dw2,db2,dw3,db3,alpha)
%% Gradient Descent update function  for a neural-network with 3 layer
 w1 = w1 - alpha * dw1;
 b1 = b1 - alpha * db1;
 w2 = w2 - alpha * dw2;
 b2 = b2 - alpha * db2;
 w3 = w3 - alpha * dw3;
 b3 = b3 - alpha * db3;
end