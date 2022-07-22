%Preliminaries
    clear;
    close all;
    clc;

rng(0)

%Determine "population" size
    num = 100000;
    
%Population parameters
    mu_I = 2;
    sigma_I = 3;
    mu_1 = 10;
    mu_2 = 20;
    sigma_1 = 3;
    sigma_2 = 4;
    sigma_12 = 2;

%Get everyone's psi_1 and psi_2

    %Start my random number generator
        rng(0,'twister')

        temp = mvnrnd([mu_1,mu_2],[sigma_1,sigma_12 ; sigma_12 , sigma_2],num);

        psi_1 = temp(:,1);
        psi_2 = temp(:,2);

%Get everyone's income
    Inc = lognrnd(mu_I,sigma_I,num,1);

%Explicitly calibrate prices
    P_M = 1;
    P_P = 2;

utility = @(inc_i,m_i,p_i,psi_1_i,psi_2_i) 5*log(inc_i-m_i.*P_M-p_i.*P_P) + psi_1_i.*m_i + psi_2_i.*p_i;

%Exhaustively search (could be faster)
    for i = 1:num
        %For each person, all your possible choices
            choices_m = [0:1:min(floor(Inc(i)./P_M),10)];
            choices_p = [0:1:min(floor(Inc(i)./P_P),10)];
            [choices_m,choices_p] = meshgrid(choices_m,choices_p);
            choices_m = reshape(choices_m,[],1);
            choices_p = reshape(choices_p,[],1);
            choices_c = Inc(i)-choices_m.*P_M-choices_p.*P_P;
            
        %Utility from each choice
            ut = utility(Inc(i),choices_m,choices_p,psi_1(i),psi_2(i));
         
            ind = find(imag(ut)>0);
            
            ut(ind) = -10000;
            
        %Find thing that makes you happiest
            [tempa,tempb] = max(ut);
        
        %Store your choice
            best_m(i,1) = choices_m(tempb);
            best_p(i,1) = choices_p(tempb);
            best_c(i,1) = choices_c(tempb);
    end

    %After storing the whole population's best choice, we can determine the
    %population moments
    
    
    %First,  households have no insurance
        moment(1,2) = [length(find(best_m==0 & best_p == 0))./num ];
    %Next, households have 1 m contract
        moment(2,2) = [length(find(best_m==1))./num ];
    %Next, households with 1 m contract have at least one
    %p contract
        moment(3,2) = [length(find(best_m==1 & best_p >= 1))./length(find(best_m==1))];
    %The average level of consumption
        moment(4,2) = [mean(best_c) ];
    %Stdev of consumption
        moment(5,2) = [std(best_c)];
    %Conditional on having insurance, average consumption
        moment(6,2) = [mean(best_c(find(best_m+best_p>0))) ];
    %Stdev of consumption
        moment(7,2) = [std(best_c(find(best_m+best_p>0))) ];
    %Proportion of households that have more than 5 contracts
        moment(8,2) = [length(find(best_m+best_p>5))./num ];
    %Correlation of m and p
        moment(9,2) = [corr(best_m,best_p) ];
    %Correlation of m and c
        moment(10,2) = [corr(best_m,best_c) ];
    %Correlation of c and p
        moment(11,2) = [corr(best_c,best_p) ];
format long g
moment
save moment.mat moment



