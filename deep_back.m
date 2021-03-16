function [dw1,db1,dw2,db2,dw3,db3] = deep_back(x,y,w1,b1,w2,b2,w3,b3,z1,a1,z2,a2,z3,a3)
%% Backward Propagation function according to a 3 layer network with tanh as activation functions
m= size(x,2);
% Calculation of dz3
dj_da3 = 2*(a3-y);
da3_dz3 =(1 - (tanh(z3).^2));
dj_dz3 = dj_da3 .* da3_dz3;
% Calculation of dw3
dz3_dw3 = a2;
dw3 = (1/m)*dj_dz3*(dz3_dw3');
% Calculation of db3
dz3_db3 = 1;
db3 = (1/m)*sum(dj_dz3 .* dz3_db3,2);
% Calculation of dw2
dz3_da2 = w3;
da2_dz2 =(1 - (tanh(z2).^2));
dz2_dw2 = a1;
dz2 = (dz3_da2') * dj_dz3 .* da2_dz2;
dw2 = (1/m) * dz2 * (dz2_dw2');
% Calculation of db2
dz2_db2 = 1;
db2 = (1/m)* sum(dz2.*dz2_db2,2);
%Calculation of dw1
dz2_da1 = w2;
da1_dz1 = (1 - (tanh(z1).^2));
dz1_dw1 = x;
dz1 =  (dz2_da1') * dz2 .* da1_dz1;
dw1 = (1/m)*dz1*(dz1_dw1');
%Calculation of db1
dz1_db1 = 1;
db1 = (1/m)*sum(dz1 .* dz1_db1,2);
end
