function [W1, b1, W2, b2] = update(W1,b1,W2,b2,dW1,db1,dW2,db2,alpha)
  W1 = W1 - alpha * dW1;
  b1 = b1 - alpha * db1;
  W2 = W2 - alpha * dW2;
  b2 = b2 - alpha * db2;
end