% mode-i fold. 
% This function takes a matrix of size ni*(n1...n_{i-1}n_{i+1}...n_N) and 
% mode-i folds it into a tensor n1*n2*...*nN
% This is the inverse of the my_unfold function
%
% Inputs:
% - W: a matrix of size ni*(n1...n_{i-1}n_{i+1}...n_N)
% - dim: a vector of the dimensions of tensor X
% - i: the ith dimension to fold
%
% Outputs:
% - W: the tensor of size n1*n2...*n_N obtained by mode-i folding


function W = my_Fold(W, dim, i)
n=1:length(dim); n(i)=[]; m=zeros(length(dim),1);
m(1)=i; m(2:end)=n;
W = reshape(W, dim(m));
W = ipermute(W,m);
end