clc;
clear;
close all;

%Define some parameters
    w = 1;
    nu = 0;
    psi = 4.0001;
    
%Define utility only as a function of endogenous variable L
    %Make negative to minimize (commented out, done directly in code)
    %utilityfxn_temp = @(L) -utilityfxn(L,w,nu,psi)
    
%Graph it out
    L_grid = [0.1:0.01:0.9];
    
%Maximize utility using a derivative-based method
    [L_star,ut_star] = fminunc(@(L) -utilityfxn(L,w,nu,psi),0.2)
    
%Maximize utility using a derivative-free method
    [L_star_alt,ut_star_alt] = patternsearch(@(L) utilityfxn(L,w,nu,psi),0.2,[],[],[],[],0.001,0.999)

    
    
    
%Now, choose the psi and w that would give us L=0.3
    Ltarget = 0.3;
    [psi_star,fit]=patternsearch(@(x)calibfxn(x(1),w,nu,Ltarget),[2.2],[],[],[],[],[0.001])
    

    calibfxn(psi_star,w,nu,Ltarget)
%     tic
%     [psi_star,fit]=fminunc(calibra,2.2)
%     toc
%     

%Show the maximum on the graph
    plot(L_grid,utilityfxn(L_grid,w,nu,psi))
    hold on
    scatter(L_star,-ut_star)
