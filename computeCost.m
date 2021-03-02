function cost = computeCost(A2,Y)
m = size(Y,2);
cost = (0.5/m)*sum((A2 - Y).^2,1) ;
end