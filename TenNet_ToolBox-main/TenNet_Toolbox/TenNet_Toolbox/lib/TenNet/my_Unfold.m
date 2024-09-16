% mode-i unfold
% This function expands the input tensor, W, along a specific mode-i dimension
% by reshaping it into a matrix of size dim(i)-by-(n1n2...n{i-1}n{i+1}...nN),
% where ni is the size of dimension i in W.
%
% Inputs:
% - W: Input tensor of size n1*n2*...*nN
% - dim: Vector of size N containing the sizes of each dimension of W
% - i: Mode-i dimension along which to unfold the tensor
%
% Output:
% - W: Unfolded tensor of size ni*(n1...n{i-1}n{i+1}...nN)

function W = my_Unfold(W, dim, i)
n=1:length(dim); n(i)=[]; m=zeros(length(dim),1);
m(1)=i; m(2:end)=n;
W = permute(W,m);
W = reshape(W, dim(i), []);
end