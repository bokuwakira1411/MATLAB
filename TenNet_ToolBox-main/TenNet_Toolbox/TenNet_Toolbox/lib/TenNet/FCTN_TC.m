% FCTN_TC - Use FCTN decomposition to complete the LRTC model.
%
% Syntax: [X, G] = FCTN_TC(F, Omega, varargin)
%
% Inputs:
% F - n_1*...*n_N tensor
% Omega - Index of the observed entries
% varargin - Optional variable parameter in Matlab. The fields are:
% varargin{1} - FCTN-rank: a matrix of (N*N).
% varargin{2} - rho: Proximal parameter of PAM algorithm (default: 0.1).
% varargin{3} - tol: Termination tolerance (default: 1e-5).
% varargin{4} - maxit: Maximum number of iterations (default: 1000).
%
% Outputs:
% X - Recovery tensor based on Fully-Connected Tensor Network Decomposition.
% G - Factors of X based on Fully-Connected Tensor Network decomposition.
% The size of Gk is R_{1,k}*...*R_{1,k-1}*I_k*R_{k,k+1}*...*R_{k,N}.
% Out - Structure containing output information, including iteration number and convergence rate.
%
% Example:
% [X, G] = FCTN_TC(F, Omega, max_R, rho, tol, maxit)
%


function [X, G] = FCTN_TC(F,Omega,varargin)
% Get the number of dimensions and size of the input tensor
N = ndims(F);
Nway = size(F);
% Check the FCTN-rank is provided
if length(varargin)>=1
    % If FCTN-rank is a constant or an upper triangular square matrix
    if size(varargin{1},1)==size(varargin{1},2)
        max_R = varargin{1};
        R = max(triu(ones(N),1)*2, max_R-5);
    else
        error('max_R should be an upper triangular square matrix.');
    end
else
    error('Please enter the FCTN-rank.');
end
% Check if rho is provided
if length(varargin)>=2
    rho = varargin{2};
else
    rho   = 0.1; % Default value
end
% Check if rho is provided
if length(varargin)>=3
    tol = varargin{3};
else
    tol   = 1e-5; % Default value
end
% Check if maxit is provided
if length(varargin)>=4
    maxit = varargin{4};
else
    maxit = 1000; % Default value
end
% Check if there are too many input parameters
if length(varargin)>=5
    error('Too many input parameters.');
end


X = F;
tempdim = diag(Nway)+R+R'; 
max_tempdim = diag(Nway)+max_R+max_R'; %
G = cell(1,N);
for i = 1:N
    G{i} = rand(tempdim(i,:));
end

r_change =0.01;
for k = 1:maxit
    Xold = X;
    for i = 1:N
        % unfold X along the ith dimension
        Xi = my_Unfold(X,Nway,i); 
        % unfold the ith FCTN factor along the ith dimension
        Gi = my_Unfold(G{i},tempdim(i,:),i);
        % compute the tensor rest of the ith FCTN factor,  
        Girest = tnreshape(sub_TN(G,i),N,i);
        % update the ith FCTN factor, see Eq(5) in [1]
        tempC = Xi*Girest'+rho*Gi;
        tempA = Girest*Girest'+rho*eye(size(Gi,2));
        G{i}  = my_Fold(tempC*pinv(tempA),tempdim(i,:),i);
    end
    % Update X
    X = (TN_composition(G)+rho*Xold)/(1+rho);
    X(Omega) = F(Omega);

    %% check the convergence
    rse=norm(X(:)-Xold(:))/norm(Xold(:));

    if mod(k, 10) == 0  ||   k == 1
        fprintf('FCTN-TC: iter = %d   RSE=%f   \n', k, rse);
    end

    if rse < tol
        break;
    end
    % Adopt the rank increase strategy
    rank_inc=double(tempdim<max_tempdim);
    if rse<r_change && sum(rank_inc(:))~=0
        G = rank_inc_adaptive(G,rank_inc,N);
        tempdim = tempdim+rank_inc;
        r_change = r_change*0.5;
    end
end
end

function [G]=rank_inc_adaptive(G,rank_inc,N)
% increase the estimated rank
for j = 1:N
    G{j} = padarray(G{j},rank_inc(j,:),rand(1),'post');
end
end


