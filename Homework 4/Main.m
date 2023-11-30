clear

rng(8,'twister')
N = 10000;

%Data Creation (student code wouldn't have this part)
    psi = 3;
    beta = 0.95;
    
    w1 = 5+0.2*randn(N,1);
    w2 = 5+0.2*randn(N,1);
    r = 0.01*randn(N,1);
    nu = rand(N,1);

%Define FOC solutions as functions, for convenience (perturbations)
    c1_fxn = @(psi,beta) (nu+r.*nu+w1+r.*w1+w2)./((1+r).*(1+beta).*(1+psi));
    c2_fxn = @(psi,beta) beta*(nu+r.*nu+w1+r.*w1+w2)./((1+beta).*(1+psi));
    L1_fxn = @(psi,beta) (-nu.*psi-r.*nu.*psi+w1+r.*w1+beta.*w1+r.*beta.*w1+beta.*psi.*w1+r.*beta.*psi.*w1-psi.*w2)./((1+r).*(1+beta).*(1+psi).*w1);

%Store data
    data.c1=  c1_fxn(psi,beta)+randn(N,1);
    data.c2=  c2_fxn(psi,beta)+randn(N,1)*0.01;
    data.L1=  L1_fxn(psi,beta)+randn(N,1)*0.01;
    data.L2=  (1+r).*(((data.c1+data.c2./(1+r))-data.L1.*w1)./w2);
    data.w1 = w1;
    data.w2 = w2;
    data.r = r;
    data.nu = nu;

%Store functions
    fxns.c1 = c1_fxn;
    fxns.c2 = c2_fxn;
    fxns.L1 = L1_fxn;

%Output data
    temp = [data.c1,data.c2,data.L1,data.L2,data.w1,data.w2,r,nu]
    csvwrite('/Users/tgallen/Dropbox/Econ_641/HwkSol/New Homework 4/Data.csv',temp)

%Calibrate
    [bhat1]=fmincon(@(theta)mom([theta(1),theta(2)],data,eye(3),fxns),[0.95,3])

%Efficient GMM: get the vcov matrix
    [temp1,S]=mom([bhat1(1),bhat1(2)],data,eye(3),fxns)
%Use that as a weight, solve again
    [bhat2]=fmincon(@(theta)mom([theta(1),theta(2)],data,inv(S),fxns),[0.95,3])
%Get vcov
    [temp1,S,vcov]=mom([bhat2(1),bhat2(2)],data,eye(3),fxns)
%Report 
    [bhat2',sqrt(diag(vcov)/N)]
%Can import to stata and compare with command:
%gmm  ((nu+r*nu+w1+r*w1+w2)/((1+r)*(1+{beta})*(1+{psi}))-c1) 
%     ({beta}*(nu+r*nu+w1+r*w1+w2)/((1+{beta})*(1+{psi}))-c2) 
%     ((-nu*{psi}-r*nu*{psi}+w1+r*w1+{beta}*w1+r*{beta}*w1+{beta}*{psi}*w1+r*{beta}*{psi}*w1-{psi}*w2)/((1+r)*(1+{beta})*(1+{psi})*w1)-L1), 
%      winitial(identity) from(beta 1 psi 3) 


function [err,S,vhat] = mom(theta,data,W,fxns)
    %Find model values
    c1_model = fxns.c1(theta(2),theta(1));
    c2_model = fxns.c2(theta(2),theta(1));
    L1_model = fxns.L1(theta(2),theta(1));

    %Find individual errors
    mom_i(:,1) = c1_model-data.c1;
    mom_i(:,2) = c2_model-data.c2;
    mom_i(:,3) = L1_model-data.L1;

    %Moment is mean of individuals
    g = mean(mom_i)'

    %Quadratic form w/weighting matrix
    err = g'*W*g;

    %Need derivatives, find by perturbation
    e = 0.000001;
    D(1,1)=mean(fxns.c1(theta(2),theta(1)+e)-fxns.c1(theta(2),theta(1)));
    D(1,2)=mean(fxns.c1(theta(2)+e,theta(1))-fxns.c1(theta(2),theta(1)));
    D(2,1)=mean(fxns.c2(theta(2),theta(1)+e)-fxns.c2(theta(2),theta(1)));
    D(2,2)=mean(fxns.c2(theta(2)+e,theta(1))-fxns.c2(theta(2),theta(1)));
    D(3,1)=mean(fxns.L1(theta(2),theta(1)+e)-fxns.L1(theta(2),theta(1)));
    D(3,2)=mean(fxns.L1(theta(2)+e,theta(1))-fxns.L1(theta(2),theta(1)));
    D = D./e;

    %Var-covar of moment matrix
    S = cov(mom_i)

    %V-cov of estimates
    vhat=inv(D'*inv(cov(mom_i))*D);

end
