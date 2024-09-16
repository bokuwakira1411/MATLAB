%% =================================================================
% This script runs the tensor network (TN) decomposition-based tensor completion (TC) method
%
% More detail can be found in 
%
% [1] Yu-Bang Zheng, Wen-Jie Zheng, Sheng Liu, Xi-Le Zhao, TenNet Toolbox,
%     May, 2023. https://github.com/zhaoxile/TenNet_toolbox.
% [2] Yu-Bang Zheng, Ting-Zhu Huang*, Xi-Le Zhao*, Qibin Zhao, Tai-Xiang Jiang
%     Fully-Connected Tensor Network Decomposition and Its Application to
%     Higher-Order Tensor Completion.
% 
% The test data 'CV_bunny.mat' is available at http://trace.eas.asu.edu/yuv/.
%% =================================================================
clc;
clear;
close all;
addpath(genpath('lib'));
addpath(genpath('data'));

%% Set enable bits
EN_TT         = 1;
EN_TR         = 1;
EN_FCTN       = 1;
methodname    = {'Observed','TT','TR','FCTN'};

%%
Mnum          = length(methodname);
Re_tensor     = cell(Mnum,1);
psnr          = zeros(Mnum,1);
ssim          = zeros(Mnum,1);
time          = zeros(Mnum,1);

%% Load initial data
load('CV_bunny.mat');
Y_tensorT = X;
if max(X(:))>1
    X = X/max(X(:));
end

%% Sampling with random position
for sample_ratio = [0.1]
    
    %% Sampling with random position
    fprintf('=== The sample ratio is %4.2f ===\n', sample_ratio);
    T         = X;
    Ndim      = ndims(T);
    Nway      = size(T);
    rand('seed',2);
    Omega     = find(rand(prod(Nway),1)<sample_ratio);
    F         = zeros(Nway);
    F(Omega)  = T(Omega);
    %%
    i  = 1;
    Re_tensor{i} = F;
    [psnr(i), ssim(i)] = quality_image(T*255, Re_tensor{i}*255);
    enList = 1;
    
    %% Perform  algorithms
    i = i+1;
    if EN_TT
        opts      =[];
        opts.R    =[60,8,4]; %%TT-rank
        modelname = "TT";
        %%%%%
        fprintf('\n');
        t0= tic;
        [Re_tensor{i},G]            = TN_LRTC(F,Omega,modelname,opts.R);
        time(i)                     = toc(t0);
        [psnr(i), ssim(i)]          = quality_image(T*255, Re_tensor{i}*255);
        enList = [enList,i];
    end
    
    %% Use TR
    i = i+1;
    if EN_TR
        opts      = [];
        opts.R    = [30,40,3,6]; %%TR-rank
        modelname = "TR";
        %%%%%
        fprintf('\n');
        t0= tic;
        [Re_tensor{i},G]            = TN_LRTC(F,Omega,modelname,opts.R);
        time(i)                     = toc(t0);
        [psnr(i), ssim(i)]          = quality_image(T*255, Re_tensor{i}*255);
        enList = [enList,i];
    end
    
    %% Use FCTN
    i = i+1;
    if EN_FCTN
        opts=[];
        opts.R = [0,  25,  2,  5;
                  0,   0,  2,  5;
                  0,   0,  0,  2;
                  0,   0,  0,  0];%%FCTN-rank
        modelname = "FCTN";
        %%%%%
        fprintf('\n');
        t0= tic;
        [Re_tensor{i},G]            = TN_LRTC(F,Omega,modelname,opts.R);
        time(i)                     = toc(t0);
        [psnr(i), ssim(i)]          = quality_image(T*255, Re_tensor{i}*255);
        enList = [enList,i];
    end
end

%% Show result
fprintf('\n');
fprintf('================== Result =====================\n');
fprintf(' %8.8s    %5.4s    %5.4s    \n','method','PSNR', 'SSIM' );
for i = 1:length(enList)
    fprintf(' %8.8s    %5.3f    %5.3f    \n',...
        methodname{enList(i)},psnr(enList(i)), ssim(enList(i)));
end
fprintf('================== Result =====================\n');
figure,
show_figResult(Re_tensor,T,min(T(:)),max(T(:)),methodname,enList,1,prod(Nway(3:end)))
