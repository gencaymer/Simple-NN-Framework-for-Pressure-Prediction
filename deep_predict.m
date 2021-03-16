function [cost,a3] = deep_predict(x,y,w1,b1,w2,b2,w3,b3)
m = size(x,2);
z1 = w1*x + b1;
a1 = tanh(z1);
z2 = w2*a1 + b2;
a2 = tanh(z2);
z3 = w3*a2 + b3;
a3 = tanh(z3);
sqrErrors= (a3-y).^2;
cost = 1./(2*m).*sum(sqrErrors);
cost = mean(cost,'all');
end