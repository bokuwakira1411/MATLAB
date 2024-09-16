%==========================================================================
% This function computes the FCTN composition of the factors, as defined in
% [1]. It takes as input the factors G, where G_k is the k-th factor.
% The size of G_k is R_{1,k}*...*R_{k-1,k}*n_k*R{k,k+1}*...*R_{k,N}.
%
% Input:
% G - cell array containing the factors of FCTN, with G{k} being the
% k-th factor.
% k - integer representing the index of the factor.
%
% Output:
% Out - tensor resulting from the FCTN composition of G, with size
% n_1 * R_{1,k}...*n_{k-1}*R_{k-1,k}*R_{k,k+1}n_{k+1}...*R_{k,N}*n_{N}.  
% 
% [1] Yu-Bang Zheng, Ting-Zhu Huang*, Xi-Le Zhao*, Qibin Zhao, Tai-Xiang Jiang
%     Fully-Connected Tensor Network Decomposition and Its Application
%     to Higher-Order Tensor Completion

function Out = sub_TN(G,k)
N = length(G);
a = [k+1:N, 1:k];
for i = [1:k-1,k+1:N]       
    G{i}      = permute(G{i},a);
end   
m = 2; n = 1;
Out = G{a(1)};
M = N;
for i = 1:N-2
    Out = tensor_contraction(Out,G{a(i+1)},M,N,m,n);
    M = M+N-2*i;
    n = [n,1+i];
    tempm = 2+i*(N-i);
    if i>1
        m(2:end)=m(2:end)-[1:i-1];
    end
    m   = [m, tempm];
end

p = zeros(1,2*(N-k));

for i =1:(N-k)
    p(2*i-1)= 2*i;
    p(2*i)  = 2*i-1;
end


Out = permute(Out,[p,2*(N-k)+1:2*(N-1)]);
Out = permute(Out,[2*(N-k)+1:2*(N-1),1:2*(N-k)]);



