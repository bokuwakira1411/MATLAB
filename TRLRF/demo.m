%Input: incomplete observation T, P_Omega, initial rank R
%Output: completed tensor X and TR factors G
%% Initialization:
% G = Initialize(T,R);
% Y = {}; M ={}; W = {};
% I = size(T);
% parameter : lamb = [];
% lamb(0) = 1; lamb(length(I)) = 100; p= 1.01, tol =10^-6
% k = 0, k_max = 300;
%% main loop
%for k =1:1:k_max
% X_dummy = X;
