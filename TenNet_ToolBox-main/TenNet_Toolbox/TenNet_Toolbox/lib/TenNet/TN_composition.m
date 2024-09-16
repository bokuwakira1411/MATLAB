%==========================================================================
% Description: This function computes the FCTN composition of the factors
% (Definition 5 in [1] ). The FCTN factors are represented by a cell
% array G. The function performs tensor contractions between the factors
% and stores the result in the variable Out.
%
% Inputs:
% - G: a cell array of FCTN factors
%
% Outputs:
% - Out: the FCTN composition of G
%
% Usage: The function can be called using the following syntax:
% Out = TN_composition(G)
% 
% [1] Yu-Bang Zheng, Ting-Zhu Huang*, Xi-Le Zhao*, Qibin Zhao, Tai-Xiang Jiang
%     Fully-Connected Tensor Network Decomposition and Its Application
%     to Higher-Order Tensor Completion


function Out = TN_composition(G)
N = length(G);
m = 2; n = 1;
Out = G{1};
M = N;
for i = 1:N-1
    Out = tensor_contraction(Out,G{i+1},M,N,m,n);
    M = M+N-2*i;
    n = [n,1+i];
    tempm = 2+i*(N-i);
    if i>1
        m(2:end)=m(2:end)-[1:i-1];
    end
    m   = [m, tempm];
end