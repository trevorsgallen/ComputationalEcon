%This code estimates the offer distribution of a Helen of Troy/McCall-style search model from data on accepted offers and time periods.
clear
close all

load('data.mat')
seed = 1;

%V is 100x1, theta is 2x1;

N = 1000;
V_guess = zeros(100,1);
theta_guess = [20;50];
W = eye(2);
%Check the nonlinear constraint part
    [temp1,temp2,V_guess]=VCheck(theta_guess,V_guess,[],'nonlinc');

%Check the estimation part
    [temp3]=VCheck(theta_guess,V_guess,[],'estim',data,W);


%Put them together
    est_fcn = @(thetaplus) VCheck(thetaplus(1:2),thetaplus(3:end),[],'estim',data,W);
    Vcon_fcn = @(thetaplus) VCheck(thetaplus(1:2),thetaplus(3:end),[],'nonlinc');

    [temp1,temp2]=fmincon(@(thetaplus) est_fcn(thetaplus),[theta_guess;V_guess],[],[],[],[],[],[],@(thetaplus) Vcon_fcn(thetaplus),optimset('Display','iter','TolX',1e-4,'DiffMinChange',1e-1))

