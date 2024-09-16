% TT_TC - Use Tensor Train decomposition to complete the LRTC model.
%
% Syntax: [X, G] = TT_TC(F, Omega, varargin)
%
% Inputs:
% F - n_1*...*n_N tensor
% Omega - Index of the observed entries
% varargin - Optional variable parameter in Matlab. The fields are:
% varargin{1} - TT-rank: a vector of (N-1).
% varargin{2} - rho: Proximal parameter of PAM algorithm (default: 0.1).
% varargin{3} - tol: Termination tolerance (default: 1e-5).
% varargin{4} - maxit: Maximum number of iterations (default: 1000).
%
% Outputs:
% X - Recovery tensor based on Tensor Train Decomposition.
% G - Factors of X based on Tensor Train decomposition.
% The size of Gk is R_{k-1}*n_k*R_{k} when k ={2,..,N-1}.
% The size of G1 is n_1*R_{1} and GN is R_{N-1}*n_N.
%
% Example:
% [X, G] = TT_TC(F, Omega, R, rho, tol, maxit)
%

function [X, G] = TT_TC(F,Omega,varargin)
%% Default parameter
% Get the number of dimensions and size of the input tensor
N = ndims(F);
Nway = size(F);
% Check the TT-rank is provided
if length(varargin{1})>=1
    R = triu(ones(N),1);
    R1 = varargin{1}; 
   for i = 1:N-1
        R(i,i+1) = R1(i); 
   end
else
    error('Please enter a vector of (N-1) as tt-rank!');
end
% Check the rho is provided
if length(varargin)>=2
    rho = varargin{2}; 
else
    rho   = 0.1;
end
% Check the tol is provided
if length(varargin)>=3
    tol = varargin{3}; 
else
    tol   = 1e-5;
end
% Check the maxit is provided
if length(varargin)>=4
    maxit = varargin{4}; 
else
    maxit = 1000;
end
% Check if there are too many input parameters
if length(varargin)>=5
    error('Too many input parameters.');
end

X = F;
tempdim = diag(Nway)+R+R';

G = cell(1,N);
for i = 1:N
    G{i} = rand(tempdim(i,:));
end

Out.RSE = [];

for k = 1:maxit
    Xold = X;
    % Update G
    for i = 1:N
        Xi = my_Unfold(X,Nway,i);
        Gi = my_Unfold(G{i},tempdim(i,:),i);
        Girest = tnreshape(sub_TN(G,i),N,i);
        tempC = Xi*Girest'+rho*Gi;
        tempA = Girest*Girest'+rho*eye(size(Gi,2));
        G{i}  = my_Fold(tempC*pinv(tempA),tempdim(i,:),i);
    end

    % Update X
    X = (TN_composition(G)+rho*Xold)/(1+rho);
    X(Omega) = F(Omega);

    %% check the convergence
    rse=norm(X(:)-Xold(:))/norm(Xold(:));
    Out.RSE = [Out.RSE,rse];

    if mod(k, 10) == 0  ||   k == 1
        fprintf('TT-TC: iter = %d   RSE=%f   \n', k, rse);
    end

    if rse < tol
        break;
    end
end
for i = 1:N
    G{i} = squeeze(G{i}); 
end
end



