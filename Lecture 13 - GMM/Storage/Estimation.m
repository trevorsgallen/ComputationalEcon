function [error] = estimation(theta)
rng(0)
    num = 10000;
    mu_I = theta(1);
    sigma_I = theta(2);
    mu_1 = theta(3);
    mu_2 = theta(4);
    sigma_1 = theta(5);
    sigma_2 = theta(6);
    sigma_12 = theta(7);
    
    [~,p] = chol([sigma_1,sigma_12 ; sigma_12 , sigma_2]);

    if p > 0
        error = 1e20;
    elseif p<=0
        temp = mvnrnd([mu_1,mu_2],[sigma_1,sigma_12 ; sigma_12 , sigma_2],num);

        psi_1 = temp(:,1);
        psi_2 = temp(:,2);

        Inc = lognrnd(mu_I,sigma_I,num,1);

        P_M = 1;
        P_P = 2;

        utility = @(inc_i,m_i,p_i,psi_1_i,psi_2_i) 5*log(inc_i-m_i.*P_M-p_i.*P_P) + psi_1_i.*m_i + psi_2_i.*p_i;

        %Exhaustively search (could be faster)
            for i = 1:num
            choices_m = [0:1:min(floor(Inc(i)./P_M),10)];
            choices_p = [0:1:min(floor(Inc(i)./P_P),10)];
            [choices_m,choices_p] = meshgrid(choices_m,choices_p);
            choices_m = reshape(choices_m,[],1);
            choices_p = reshape(choices_p,[],1);
            choices_c = Inc(i)-choices_m.*P_M-choices_p.*P_P;
            ut = utility(Inc(i),choices_m,choices_p,psi_1(i),psi_2(i));

            [tempa,tempb] = max(ut);

            best_m(i,1) = choices_m(tempb);
            best_p(i,1) = choices_p(tempb);
            best_c(i,1) = choices_c(tempb);
            end

    %Now compare simulated data to moments
        %First, state that 27% of households have no insurance
            moment(1,:) = [length(find(best_m==0 & best_p == 0))./num , 0.27]*10;
        %Next, state that 20% of households have 1 m contract
            moment(2,:) = [length(find(best_m==1))./num , 0.0651]*100;
        %Next, state that 50% of households with 1 m contract have at least one
        %p contract
            moment(3,:) = [length(find(best_m==1 & best_p >= 1))./length(find(best_m==1)) , 0];
        %The average level of consumption is 3
            moment(4,:) = [mean(best_c) , 840.20166]./100;
        %Stdev of consumption is 10
            moment(5,:) = [std(best_c) , 18231.44]./10000;
        %Conditional on having insurance, average consumption is 5
            moment(6,:) = [mean(best_c(find(best_m+best_p>0))) , 1151.2977 ]./1000;
        %Stdev of consumption is 10
            moment(7,:) = [std(best_c(find(best_m+best_p>0))) , 21334.678]./10000;
        %Proportion of households that have more than 5 contracts
            moment(8,:) = [length(find(best_m+best_p>5))./num , 0.5752].*2;
        %Correlation of m and p
            moment(9,:) = [corr(best_m,best_p) , 0.949894243091687].*2;
        %Correlation of m and c
            moment(10,:) = [corr(best_m,best_c) , 0.04560835307154825].*10;
        %Correlation of c and p
            moment(11,:) = [corr(best_c,best_p) , 0.0545153297159776].*10;

            error = log(sum((moment(:,1)-moment(:,2)).^2))
    end
end
