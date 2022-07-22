clear
clc
close all

alpha_true = 0.7;
mu_A_true = 0.1;
sigma_A_true = 0.1;
mu_psi_true = 0.5;
sigma_psi_true = 0.4;

alpha_guess = 0.6;
mu_A_guess = 0.2;
sigma_A_guess = 0.05;
mu_psi_guess = 0.3;
sigma_psi_guess = 1;

theta_true = [alpha_true,mu_A_true,sigma_A_true,mu_psi_true,sigma_psi_true]';
theta_guess = [alpha_guess,mu_A_guess,sigma_A_guess,mu_psi_guess,sigma_psi_guess]';

% Estimator_Firm(theta_true)

% asdf
psoptions = psoptimset('PlotFcns',@psplotbestf,'SearchMethod',@MADSPositiveBasisNp1,'PollingOrder','success','Display','iter')
% x0 = patternsearch(@Estimator,theta_guess,[],[],[],[],[],[],[],psoptions)
x0 = patternsearch(@Estimator_Firm,theta_guess,[],[],[],[],[],[],[],psoptions)
