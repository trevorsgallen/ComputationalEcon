function [error,moment] = estimation(theta)  
try
    num = 10000;
    
    %Load in parameters
        mu_I = theta(1);
        sigma_I = theta(2);
        mu_1 = theta(3);
        mu_2 = theta(4);
        sigma_1 = theta(5);
        sigma_2 = theta(6);
        sigma_12 = theta(7);
    
     %Check to see if variance-covariance is positive semidefinite
        [~,p] = chol([sigma_1,sigma_12 ; sigma_12 , sigma_2]);

    %If not, punish
    if p > 0
        error = 1e20;
    elseif p<=0
    %Otherwise, everything is the same as my DGP
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
        
        %Find thing that makes you happiest
            [tempa,tempb] = max(ut);
        
        %Store your choice
            best_m(i,1) = choices_m(tempb);
            best_p(i,1) = choices_p(tempb);
            best_c(i,1) = choices_c(tempb);
    end

load moment.mat moment
    moment;
    %Now compare simulated data to moments
        %First, households have no insurance
            moment(1,1) = [length(find(best_m==0 & best_p == 0))./num ];
        %Next, state that 20% of households have 1 m contract
            moment(2,1) = [length(find(best_m==1))./num ];
        %Next, state that 50% of households with 1 m contract have at least one
        %p contract
            moment(3,1) = [length(find(best_m==1 & best_p >= 1))./length(find(best_m==1))];
        %The average level of consumption is 3
            moment(4,1) = [mean(best_c) ];
        %Stdev of consumption is 10
            moment(5,1) = [std(best_c) ];
        %Conditional on having insurance, average consumption is 5
            moment(6,1) = [mean(best_c(find(best_m+best_p>0))) ];
        %Stdev of consumption is 10
            moment(7,1) = [std(best_c(find(best_m+best_p>0))) ];
        %Proportion of households that have more than 5 contracts
            moment(8,1) = [length(find(best_m+best_p>5))./num ];
        %Correlation of m and p
            moment(9,1) = [corr(best_m,best_p) ];
        %Correlation of m and c
            moment(10,1) = [corr(best_m,best_c) ];
        %Correlation of c and p
            moment(11,1) = [corr(best_c,best_p) ];
            if rand < 0.01
                [moment(:,1)-moment(:,2)];
            end
            %Use a diagonal, but reweighted weighting matrix.
%             error = (sum(1./[1e-1,1e-2,1e-2,1e7,1e9,1e7,1e9,1e-1,1e-1,1e-3,1e-3]'.*(moment(:,1)-moment(:,2)).^2));
            error = (sum((moment(:,1)-moment(:,2)).^2));
    end
catch
    error = 1e30;
end
end
