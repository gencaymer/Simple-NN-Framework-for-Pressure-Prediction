function cost = computeCost(A2,Y)
%% Calculates cost over all samples
m = size(Y,2);
sqrErrors= (A2-Y).^2;
cost =1./(2*m).*sum(sqrErrors);

end