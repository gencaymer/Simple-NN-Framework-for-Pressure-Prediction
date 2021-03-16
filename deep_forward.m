function [z1,a1,z2,a2,z3,a3]= deep_forward(x,w1,b1,w2,b2,w3,b3)
%% Forward propagation function for a 3 layer neural-network,uses tanh as activation function
z1 = w1*x + b1;
a1 = tanh(z1);
z2 = w2*a1 + b2;
a2 = tanh(z2);
z3 = w3*a2 + b3;
a3 = tanh(z3);
end