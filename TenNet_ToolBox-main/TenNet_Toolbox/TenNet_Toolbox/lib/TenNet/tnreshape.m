%==========================================================================
% tnreshape_paper - Reshapes a FCTN composition according to Theorem 4 in [1].
%
% Inputs:
%    Grest - A tensor of size n_1 * R_{1,k} * ... * n_{k-1} * R_{k-1,k} * R_{k,k+1} * n_{k+1} * ... * R_{k,N} * n_{N}
%            where N is the dimension of tensor X and i is the ith dimension.
%    N     - The dimension of tensor X.
%    i     - The ith dimension.
%
% Outputs:
%    Out   - A reshaped tensor of size (R_{1,k}...R_{k-1,k}R_{k,k+1}...R{k,N}) * (n_1...n_{k-1}n_{k+1}...n_{N})
%
% [1] Yu-Bang Zheng, Ting-Zhu Huang*, Xi-Le Zhao*, Qibin Zhao, Tai-Xiang Jiang
%     Fully-Connected Tensor Network Decomposition and Its Application
%     to Higher-Order Tensor Completion

function Out = tnreshape(Grest,N,i)

Nway = size(Grest);
if  length(Nway) < 2*(N-1)
    Nway = [Nway,ones(1,2*(N-1)-length(Nway))];
end

m = zeros(N-1,1);   n = zeros(N-1,1);
for k=1:N-1
    if k<i
        m(k)=2*k;n(k)=2*k-1;
    else
        m(k)=2*k-1;n(k)=2*k;
    end
end
tempG = permute(Grest,[m,n]);
Out = reshape(tempG,prod(Nway(m)),prod(Nway(n)));





