clc;
clear;
close all;

%Define some parameters
    w = 1;
    nu = 0;
    psi = 4.0001;
    
%Define utility only as a function of endogenous variable L
    %Make negative to minimize
    utilityfxn_temp = @(L) -utilityfxn(L,w,nu,psi)
    
%Graph it out
    L_grid = [0.1:0.01:0.9];
    plot(L_grid,-utilityfxn_temp(L_grid))
    
%Maximize utility using a derivative-based method
    [L_star,ut_star] = fminunc(utilityfxn_temp,0.2)
    
%Maximize utility using a derivative-free method
    [L_star_alt,ut_star_alt] = patternsearch(utilityfxn_temp,0.2,[],[],[],[],0.001,0.999)

    
%Show the maximum on the graph
    hold on
    scatter(L_star,-ut_star)
    
    
%Now, choose the psi that would give us L^*=0.3
    calibrator_temp = @(psitemp) calibrator(psitemp,w,nu)
    [psi_star,fit]=patternsearch(calibrator_temp,2.2)
    
    tic
    [psi_star,fit]=fminunc(calibrator_temp,2.2)
    toc
    