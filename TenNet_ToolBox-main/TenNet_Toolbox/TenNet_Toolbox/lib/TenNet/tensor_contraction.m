%==========================================================================
% Compute the tensor contraction of two tensors (Definition 3 in [1])
% This function takes two input tensors X and Y, and two sets of mode
% indices n and m, and performs the contraction of the tensors along the
% specified modes. The sizes of the input tensors are adjusted to match
% the mode indices.
% Inputs:
% X - the first tensor
% Y - the second tensor
% Sx - size of X
% Sy - size of Y
% n - The modes of X used to conduct contraction
% m - The modes of Y used to conduct contraction
% Output:
% Out - the tensor contraction result
%
% [1] Yu-Bang Zheng, Ting-Zhu Huang*, Xi-Le Zhao*, Qibin Zhao, Tai-Xiang Jiang
%     Fully-Connected Tensor Network Decomposition and Its Application
%     to Higher-Order Tensor Completion


function Out = tensor_contraction(X, Y, Sx, Sy, n, m)
Nx = ndims(X);     Ny = ndims(Y);
Lx = size(X);      Ly = size(Y);  
if  Nx < Sx
    tempLx = ones(1,Sx-Nx);
    Lx = [Lx,tempLx];
end
if  Ny < Sy
    tempLy = ones(1,Sy-Ny);
    Ly = [Ly,tempLy];
end

indexx = 1:Sx;     indexy = 1:Sy;
indexx(n) = [];    indexy(m) = [];

tempX = permute(X,[indexx,n]);  tempXX=reshape(tempX,prod(Lx(indexx)),prod(Lx(n)));
tempY = permute(Y,[m,indexy]);  tempYY=reshape(tempY,prod(Ly(m)),prod(Ly(indexy)));
tempOut = tempXX*tempYY;
Out     = reshape(tempOut,[Lx(indexx),Ly(indexy)]);
