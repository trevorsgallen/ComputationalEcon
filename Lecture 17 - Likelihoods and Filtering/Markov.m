clear

%First, let's make the data
    p = [0.5 , 0.5 ; 0.20 , 0.80];
    p_long = mean(p^100)';
    p_long_alt = [(1-p(2,2))./(2-p(1,1)-p(2,2)) ; 1-(1-p(2,2))./(2-p(1,1)-p(2,2))]
    rng(1)
    temp = rand;
        if temp < p_long(1)
            x_sim(1) = 1;
        elseif temp >= p_long(1)
            x_sim(1) = 2;
        end

    T = 20;

    for t = 1:T
        temp = rand;
        if x_sim(t) == 1 & temp < p(1,1)
            x_sim(t+1) = 1;
        elseif x_sim(t) == 1 & temp >= p(1,1)
            x_sim(t+1) = 2;
        end

        if x_sim(t) == 2 & temp < p(2,2)
            x_sim(t+1) = 2;
        elseif x_sim(t) == 2 & temp >= p(2,2)
            x_sim(t+1) = 1;
        end
    end;
    
%Now, let's write out the log-likelihood
    lik_1 = @(p11,p22) (length(find(x_sim(1:end-1)==1 & x_sim(2:end) == 1))./length(find(x_sim(1:end-1)==1))).*log(p11);
    lik_2 = @(p11,p22) (length(find(x_sim(1:end-1)==1 & x_sim(2:end) == 2))./length(find(x_sim(1:end-1)==1))).*log(1-p11);
    lik_3 = @(p11,p22) (length(find(x_sim(1:end-1)==2 & x_sim(2:end) == 1))./length(find(x_sim(1:end-1)==2))).*log(1-p22);
    lik_4 = @(p11,p22) (length(find(x_sim(1:end-1)==2 & x_sim(2:end) == 2))./length(find(x_sim(1:end-1)==2))).*log(p22);
    lik_tot = @(p11,p22) lik_1(p11,p22)+ lik_2(p11,p22)+ lik_3(p11,p22)+ lik_4(p11,p22);
    
%Estimate
    lik_tot_temp = @(x) -lik_tot(x(1),x(2));
    [x0,temp1,temp2,temp3,temp4,hess] = fminunc(lik_tot_temp,[0.5,0.5]);
    sd_1=[diag(inv(hess)),[(1/(x0(1).*(1-x0(1))))^(-1);(1/(x0(2).*(1-x0(2))))^(-1)]]
    
%But we can do a little more...
    lik_tot_full = @(p11,p22) lik_tot(p11,p22) + sum(mean([p11,1-p11 ; 1-p22 , p22]^100).^([x_sim(1)==1,x_sim(1)==2]));
    lik_tot_full_temp = @(x) -lik_tot_full(x(1),x(2));
    [x0_full,temp1,temp2,temp3,temp4,hess_full] = fminunc(lik_tot_full_temp,[0.5,0.5]);
    sd_2 = sqrt([diag(inv(hess_full)),[(1/(x0_full(1).*(1-x0_full(1))))^(-1);(1/(x0_full(2).*(1-x0_full(2))))^(-1)]])
    
    'Estimated'
    [x0',sd_1(:,1)]
    'Truth'
    [p(1,1);p(2,2)]
    
    
