% TN_LRTC performs tensor decomposition on a given tensor F based on
% a specified model (TT, TR, or FCTN) and returns the resulting decomposed
% tensor X and G. The indices of the observed entries are specified by Omega.
% The function takes variable parameters in the form of a Matlab variable 
% parameter (varargin) with the following fields:
%
% Inputs:
%   F         - n_1 x ... x n_N tensor to be decomposed
%   Omega     - index of the observed entries
%   varargin  - variable parameters in Matlab with the following fields:
%       varargin{1} - the model name: 'TT', 'TR', or 'FCTN'
%       varargin{2} - rank of the selected model
%       varargin{3} - proximal parameter of the PAM algorithm (default: 0.1)
%       varargin{4} - termination tolerance (default: 1e-5)
%       varargin{5} - maximum number of iterations (default: 1000)
%
% Outputs:
%   X         - recovery tensor based on selected tensor decomposition.
%   G         - tensor factors of the selected model. 
%
% Example usage:
%   [X, G] = TN_LRTC(F, Omega, 'TT', [40,12,12], 0.1, 1e-5, 1000);
%

function [X, G] = TN_LRTC(F, Omega, varargin)

% Check input arguments
if nargin < 2
    error('TN_decomposition requires at least two arguments.');
end

% Set default values for optional parameters
defaults = { 'TT', [40,12,12], 0.1, 1e-5, 1000 };

% Replace defaults with user-specified values
num_defaults = length(defaults);
num_varargin = length(varargin);

if num_varargin > num_defaults
    error('Too many optional arguments provided');
end

defaults(1:num_varargin) = varargin;

[model_name, rank, rho, tol, maxit] = defaults{:};

% Check model name and call corresponding function
switch model_name
    case 'TT'
        disp(['Performing TT-TC']);
        [X, G] = TT_TC(F, Omega, rank, rho, tol, maxit);
    case 'TR'
        disp(['Performing TR-TC']);
        [X, G] = TR_TC(F, Omega, rank, rho, tol, maxit);
    case 'FCTN'
        disp(['Performing FCTN-TC']);
        [X, G] = FCTN_TC(F, Omega, rank, rho, tol, maxit);
    otherwise
        error('Invalid model name specified. Choose from "TT", "TR", or "FCTN".');
end

end



