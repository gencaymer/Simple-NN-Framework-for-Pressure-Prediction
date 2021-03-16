function [dW1, db1, dW2, db2] = backprop(Xn,Yn,W1,b1,W2,b2,Z1,A1,Z2,A2)
%% Backward Propagation function according to a simple network with tanh as activation function and reLu as output
        m = size(Xn,2);
        %Calculation of dZ2
        dJ_dA2 = 2 * (A2 - Yn); % (ny x m)
        dA2_dZ2 =(Z2>0);
%         dA2_dZ2 =  (1 - (tanh(Z2).^2)); %Derivative of the activation function(relu) in output layer  % (ny x m)
        dJ_dZ2 = dJ_dA2 .* dA2_dZ2 ; % (ny x m)
        %Calculation of dW2
        dZ2_dW2 = A1; % (nh x m)
        dW2 = (1/m)*dJ_dZ2 * (dZ2_dW2') ; % Dimensions should be (ny x nh)
        %Calculation of db2 
        dZ2_db2 = 1;
        db2 = (1/m)*sum(dJ_dZ2 .* dZ2_db2,2) ; % Dimensions should be (ny x m)
        %Calculation of dW1
        dZ2_dA1 = W2 ; % (ny x nh)
        %dA1_dZ1 =(Z1 > 0);
         dA1_dZ1 = (1 - (tanh(Z1).^2)); % (nh x m) % Derivative of activation function(TANH) in hidden layer
        dZ1_dW1 = Xn ; % (nx x m)
        dZ1 = (dZ2_dA1') * dJ_dZ2 .* dA1_dZ1; %(nh x m)
        dW1 = (1/m)*dZ1 * (dZ1_dW1') ; % Dimensions should be (nh x nx)
        % Calculation of db1
        dZ1_db1 = 1;
        db1 = (1/m)*sum(dZ1 .* dZ1_db1,2) ; % Dimensions should be (nh x m)
end