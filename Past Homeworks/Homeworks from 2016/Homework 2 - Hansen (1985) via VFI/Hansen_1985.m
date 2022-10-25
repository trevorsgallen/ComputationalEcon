%Code for Replication of Table 1 Hansen (1985)
%Trevor Gallen

clear
close all
clc

%Parameters
    theta = 0.36;
    delta = 0.025;
    beta = 0.99;
    A = 2;
    h0 = 0.53;
    gamma = 0.95;
    sigma_e = 0.00712;
    B = -A*(log(1-h0))./h0;
    
%Parameter that defines if we use Howard's Improvement algorithm
    howards = 1;
    
%Define state space
    lambda_min = 0.85;
    lambda_max = 1.15;
    lambda_num = 26;
%     lambda_num = 13;
    lambda_space = linspace(lambda_min,lambda_max,lambda_num)';

    k_min = 9;
    k_max = 14;
    k_num = 150;
%     k_num = 15;
    k_space = linspace(k_min,k_max,k_num)';

    [k_grid,lambda_grid] = meshgrid(k_space,lambda_space);

%Parameter that decides if we have divisible or indivisible labor
    divisible = 0;
    if divisible == 1
        dtext = 'divisible';
        V_0 = -138.223752617423*k_grid./k_grid + 2.38244185127231.*k_grid+31.845546984154.*lambda_grid-0.0326811212132505.*k_grid.^2-2.2547522861677.*lambda_grid.^2-0.412003292100822.*k_grid.*lambda_grid;
    end
    if divisible == 0
        dtext = 'indivisible'; 
        V_0 = 132.677392393843*k_grid./k_grid + 2.4476983331298.*k_grid+30.7922947378966.*lambda_grid-0.0314974461225384.*k_grid.^2-1.19289779586991.*lambda_grid.^2-0.502619722765936.*k_grid.*lambda_grid;
    end

%Start out with a guess near the solution (for speed)
% V_0 = zeros(lambda_num,k_num);

%     Xtemp = [reshape(k_grid./k_grid,[],1),reshape(k_grid,[],1),reshape(lambda_grid,[],1),reshape(k_grid.^2,[],1),reshape(lambda_grid.^2,[],1),reshape(k_grid.*lambda_grid,[],1)]
%     Ytemp = reshape(V_1,[],1)
%     inv(Xtemp'*Xtemp)*Xtemp'*Ytemp

V_1 = V_0;

zzz = 0;
%Loop
    error = Inf;
    t = 0;
    tic
    while error > 1e-8 & t < 20
        t = t+1;
        [t,error]
            %Define our V as an interpolated function
%             F = griddedInterpolant(reshape(lambda_grid,[],1), reshape(k_grid,[],1), reshape(V_0,[],1),'makima');
            F = griddedInterpolant((lambda_grid), (k_grid), (V_0),'makima');
            %Loop over every lambda and k
            for k_ind = 1:k_num
                for lambda_ind = 1:lambda_num
                    k_now = k_grid(lambda_ind,k_ind);
                    lambda_now = lambda_grid(lambda_ind,k_ind);
                    zzz = zzz+1;
                    zzz/(k_num*lambda_num);

                    %Give the solver an initial guess
                        if isinf(error) == 1
                            initguess =  [k_min,0.33];
                        elseif isinf(error) == 0
                            initguess = reshape(squeeze(policy(lambda_ind,k_ind,:)),1,[]);
                        end
                    %Define LHS of the Bellman
                        %Define utility (divisible or indivisible?)
                            if divisible == 1
                                utility = @(k_next,l,lambdanext) -(log(lambda_now.*(k_now.^theta)*(l.^(1-theta))+(1-delta).*k_now-min(max(k_next,k_min),k_max))+A.*log(1-l)+beta.*F(lambdanext,min(max(k_next,k_min),k_max)));
                            end
                            if divisible == 0
                                utility = @(k_next,l,lambdanext) -(log(lambda_now.*(k_now.^theta)*(l.^(1-theta))+(1-delta).*k_now-min(max(k_next,k_min),k_max))+B.*(1-l)+beta.*F(lambdanext,min(max(k_next,k_min),k_max)));
                            end
                        utility_temp = @(x) utility(x(1),x(2),(1-gamma)+gamma*lambda_now);
                        options = optimoptions(@fminunc,'Algorithm','quasi-newton','Display','off');
                    %Maximize utility
                        try
                            psoptions = psoptimset('MaxFunEval',100000,'Display','off');
                            [x0,temp] = patternsearch(utility_temp,initguess,[],[],[],[],[k_min,0.1],[min(lambda_now.*(k_now.^theta)*(0.6.^(1-theta))+(1-delta).*k_now,k_max),0.6],[],psoptions);
                            if t > 10
                                [x0,temp] = fminunc(utility_temp,x0 ,options);
                            end
                        catch
                            'ERROR'
                            [t,k_ind,lambda_ind]
                          [x0,temp] = fminunc(utility_temp,initguess,options);
                        end
                    %Store value, policy
                        V_1(lambda_ind,k_ind) = -temp;
                        policy(lambda_ind,k_ind,:) = x0;

                end
            end

%             %Howard's Improvement Algorithm
            zzz2 = 0;
            if howards == 1
                if error > 1e-15
                    for zz = 1:100
                        for k_ind = 1:k_num
                            for lambda_ind = 1:lambda_num
                                zzz2 = zzz2+1;
                                zzz2/(100*k_num*lambda_num);
                                %Apply our policy function solutions
                                %repeatedly (100 times)
                                k_now = k_grid(lambda_ind,k_ind);
                                lambda_now = lambda_grid(lambda_ind,k_ind);
                                F = griddedInterpolant((lambda_grid), (k_grid), (V_1));
                                %Define utility (divisible or indivisible?)
                                    if divisible == 1
                                        utility = @(k_next,l,lambdanext) -(log(lambda_now.*(k_now.^theta)*(l.^(1-theta))+(1-delta).*k_now-min(max(k_next,k_min),k_max))+A.*log(1-l)+beta.*F(lambdanext,min(max(k_next,k_min),k_max)));
                                    end
                                    if divisible == 0
                                        utility = @(k_next,l,lambdanext) -(log(lambda_now.*(k_now.^theta)*(l.^(1-theta))+(1-delta).*k_now-min(max(k_next,k_min),k_max))+B.*(1-l)+beta.*F(lambdanext,min(max(k_next,k_min),k_max)));
                                    end
                                utility_temp = @(x) utility(x(1),x(2),(1-gamma)+gamma*lambda_now);
                                V_1_temp(lambda_ind,k_ind) = -utility_temp([policy(lambda_ind,k_ind,1),policy(lambda_ind,k_ind,2)]);
                            end
                        end
                        V_1 = V_1_temp;
                    end
                end
            end

        %Calculate new error, display some statistics about it
            error = max(max(abs(V_0-V_1)));
            [t,max(max(abs(V_0-V_1))),mean(mean(abs(V_0-V_1)))]

        %Replace V_0 with V_1
            V_0 = V_1;
            plot(V_0(1,:))
            hold all
            drawnow
    end
    toc

    lambda_sim(1) = 1;
    for t = 1:10000
        lambda_sim(t+1) = (1-gamma)+gamma*lambda_sim(t) + 0.00712*randn;
    end
    




%%%Now calculate some perfectly transitory counterfactuals
            %Define our V as an interpolated function
  
            wshock_vec = linspace(-0.45848,0.8467,10)
            Alimit_vec = linspace(0.9,1,3)
            
            for wshock_ind = 1:length(wshock_vec)
                for Alimit_ind = 1:length(Alimit_vec)
                    for k_ind = 1:k_num
                        for lambda_ind = 1:lambda_num
                            for choice_ind = 1:2
                                policy_shock_alternate(lambda_ind,k_ind,wshock_ind,Alimit_ind,choice_ind) = policy(lambda_ind,k_ind,choice_ind);
                                policy_shock_c(lambda_ind,k_ind,wshock_ind,Alimit_ind,:) = NaN;
                            end
                        end
                    end
                end
            end

            tic
            z = 0;
            F = griddedInterpolant((lambda_grid), (k_grid), (V_0));
            for wshock_ind = 1:length(wshock_vec)
                wshock = wshock_vec(wshock_ind)
                for Alimit_ind = 1:2
                    %length(Alimit_vec)
                    Alimit = Alimit_vec(Alimit_ind)
                    %Loop over every lambda and k
                    for k_ind = 1:k_num
                        for lambda_ind = 1:lambda_num
                            z = z+1;
                            toc./(z./(length(wshock_vec)*length(wshock_vec)*length(Alimit_vec)*k_num*lambda_num))-toc
                            k_now = k_grid(lambda_ind,k_ind);
                            lambda_now = lambda_grid(lambda_ind,k_ind);
                            zzz = zzz+1;
                            zzz/(k_num*lambda_num);

                                initguess_1 = conv2(policy_shock_alternate(:,:,wshock_ind,Alimit_ind,1),ones(3),'same')./conv2(ones(size(policy_shock_alternate(:,:,wshock_ind,Alimit_ind,1))),ones(3),'same');
                                initguess_2 = conv2(policy_shock_alternate(:,:,wshock_ind,Alimit_ind,2),ones(3),'same')./conv2(ones(size(policy_shock_alternate(:,:,wshock_ind,Alimit_ind,2))),ones(3),'same');

                            %Give the solver an initial guess
                                    initguess = [initguess_1(lambda_ind,k_ind),initguess_2(lambda_ind,k_ind)];
                                    initguess = max([[max(k_min,Alimit*k_now)+0.01,0.1+0.01] ; initguess]);
                                    initguess = min([[min(lambda_now.*(k_now.^theta)*(0.6.^(1-theta))+(1-delta).*k_now,k_max)-0.01,0.6-0.01] ; initguess]);
                                    if Alimit == 1
                                        initguess(1) = k_now;
                                    end
                                    
                            %Define LHS of the Bellman
                                %Define utility (divisible or indivisible?)
                                    if divisible == 1
                                        utility = @(k_next,l,lambdanext) -(log(lambda_now.*(k_now.^theta)*(l.^(1-theta))   - wshock*l.*(1-theta).*(lambda_now.*(k_now.^theta)*(l.^(1-theta)))./l   +(1-delta).*k_now-min(max(k_next,k_min),k_max))+A.*log(1-l)+beta.*F(lambdanext,min(max(k_next,k_min),k_max)));
                                    end
                                    if divisible == 0
                                        utility = @(k_next,l,lambdanext) -(log(lambda_now.*(k_now.^theta)*(l.^(1-theta))   - wshock*l.*(1-theta).*(lambda_now.*(k_now.^theta)*(l.^(1-theta)))./l    +(1-delta).*k_now-min(max(k_next,k_min),k_max))+B.*(1-l)+beta.*F(lambdanext,min(max(k_next,k_min),k_max)));
                                    end
                                utility_temp = @(x) utility(x(1),x(2),(1-gamma)+gamma*lambda_now);
                                options = optimoptions(@fminunc,'Algorithm','quasi-newton','Display','off');
                            %Maximize utility
%                                 try
                                    cons = @(k_next,l) (lambda_now.*(k_now.^theta)*(l.^(1-theta))   - wshock*l.*(1-theta).*(lambda_now.*(k_now.^theta)*(l.^(1-theta)))./l   +(1-delta).*k_now-min(max(k_next,k_min),k_max));
                                    temp = cons(initguess(1),initguess(2));
                                    while temp <= 0
                                        initguess(2) = initguess(2)+0.01;
                                        temp = cons(initguess(1),initguess(2))
                                    end
                                
                                    psoptions = psoptimset('MaxFunEval',1000000,'Display','off');
                                    [x0,temp] = patternsearch(utility_temp,initguess,[],[],[],[],[max(k_min,Alimit*k_now),0.1],[min(lambda_now.*(k_now.^theta)*(0.6.^(1-theta))+(1-delta).*k_now,k_max),0.6],[],psoptions);
                                    if t > 10
                                        [x0,temp] = fminunc(utility_temp,x0 ,options);
                                    end
                                    
%                                 catch
%                                     'ERROR'
%                                     [t,k_ind,lambda_ind]
%                                   [x0,temp] = fminunc(utility_temp,initguess,options);
%                                 end
                            %Store value, policy
%                                 V_1(lambda_ind,k_ind) = -temp;
                                policy_shock_alternate(lambda_ind,k_ind,wshock_ind,Alimit_ind,:) = x0;
                                policy_shock_c(lambda_ind,k_ind,wshock_ind,Alimit_ind,:) = lambda_now.*(k_now.^theta)*(x0(2).^(1-theta))   - wshock*x0(2).*(1-theta).*(lambda_now.*(k_now.^theta)*(x0(2).^(1-theta)))./x0(2)    +(1-delta).*k_now-min(max(x0(1),k_min),k_max);

                        end
                    end
                end
            end
        
            
            
    lambda_ind
    k_ind
    wshock_ind
    Alimit_ind

    
    %For the "agent", when fairly constrained, by "idiosyncratic" productivity, by k, how labor market behavior
    %differ when shocked by w?
    
    
    %Want so say:  response to tfp shock is different depending on wage
        subplot(2,2,1)
        hold on
        plot(wshock_vec',((squeeze(policy_shock_alternate(10,75,:,1,2)))-(squeeze(policy_shock_alternate(14,75,:,1,2)))))
        title('dL/dTFP(wage)')
        xlabel('Idiosyncratic Wage')
        ylabel('dL')
        subplot(2,2,2)
        hold on
        plot(wshock_vec',((squeeze(policy_shock_c(10,75,:,2)))-(squeeze(policy_shock_c(14,75,:,1)))))
        title('dc/dTFP(wage)')
        xlabel('Idiosyncratic Wage')
        ylabel('dc')
        subplot(2,2,3)
        hold on
        plot(wshock_vec',((squeeze(policy_shock_alternate(10,75,:,2,2)))-(squeeze(policy_shock_alternate(14,75,:,2,2)))))
        title('dL/dTFP(wage)')
        xlabel('Idiosyncratic Wage')
        ylabel('dL')
        subplot(2,2,4)
        hold on
        plot(wshock_vec',((squeeze(policy_shock_c(10,75,:,2)))-(squeeze(policy_shock_c(14,75,:,2)))))
        title('dc/dTFP(wage)')
        xlabel('Idiosyncratic Wage')
        ylabel('dc')

        save indivisible.mat
asdf
        
        
        subplot(1,2,1)
        plot(wshock_vec',((squeeze(policy_shock_alternate(10,7,:,1,2)))-(squeeze(policy_shock_alternate(14,7,:,1,2)))))
        title('dL/dTFP(wage)')
        xlabel('Idiosyncratic Wage')
        ylabel('dL')
        subplot(1,2,2)
        plot(wshock_vec',((squeeze(policy_shock_c(10,7,:,1)))-(squeeze(policy_shock_c(14,7,:,1)))))
        title('dc/dTFP(wage)')
        xlabel('Idiosyncratic Wage')
        ylabel('dc')

        
        
        plot(wshock_vec',((squeeze(policy_shock_alternate(14,7,:,1,2)))-(squeeze(policy_shock_alternate(10,7,:,1,2))))./0.32)
        title('Change in Labor in Response to TFP Shock as a function of Wage')
        xlabel('Idiosyncratic Wage')
        ylabel('Change in labor')

        
asdf
    
    surf((squeeze(policy_shock_alternate(12,:,:,5,2))-squeeze(policy_shock_alternate(5,:,:,5,2)))-(squeeze(policy_shock_alternate(12,:,:,1,2))-squeeze(policy_shock_alternate(5,:,:,1,2))))
    
    figure(1)
    subplot(1,2,1)
    surf(-wshock_vec,k_space,squeeze(policy_shock_alternate(12,:,:,5,2))-squeeze(policy_shock_alternate(5,:,:,5,2)))
    title('Labor with borrowing constraints')
    shading interp
    subplot(1,2,2)
    surf(-wshock_vec,k_space,squeeze(policy_shock_alternate(12,:,:,1,2))-squeeze(policy_shock_alternate(5,:,:,1,2)))
    title('Labor without borrowing constraints')
    shading interp
    subplot(2,2,3)
    surf(-wshock_vec,k_space,squeeze(policy_shock_alternate(12,:,:,5,1))-squeeze(policy_shock_alternate(5,:,:,5,1)))
    title('Consumption with borrowing constraints')
    shading interp
    subplot(2,2,4)
    surf(-wshock_vec,k_space,squeeze(policy_shock_alternate(12,:,:,1,1))-squeeze(policy_shock_alternate(5,:,:,1,1)))
    title('Consumption without borrowing constraints')
    shading interp

    
    figure(2)
    subplot(1,2,1)
    surf(-wshock_vec,k_space,(squeeze(policy_shock_alternate(12,:,:,5,2))-squeeze(policy_shock_alternate(5,:,:,5,2))))
    title('Constrained')
    subplot(1,2,2)
    surf(-wshock_vec,k_space,(squeeze(policy_shock_alternate(12,:,:,1,2))-squeeze(policy_shock_alternate(5,:,:,1,2))))
    title('Unconstrained ')
    shading interp
    subplot(1,2,2)
    surf(-wshock_vec,k_space,(squeeze(policy_shock_alternate(12,:,:,5,2))-squeeze(policy_shock_alternate(5,:,:,5,2)))  -  (squeeze(policy_shock_alternate(12,:,:,1,2))-squeeze(policy_shock_alternate(5,:,:,1,2)))   )
    title('Labor')
    shading interp

            
    %Now examine how they behave when they are credit constrained
    %Define the policy functions as usable functions
        k_policy = griddedInterpolant((lambda_grid), (k_grid), (policy(:,:,1)));
        l_policy = griddedInterpolant((lambda_grid), (k_grid), (policy(:,:,2)));


%     figure(1)
%     subplot(2,2,1)
%     surf(-wshock_vec,k_space,squeeze(policy_shock_alternate(12,:,:,5,2))-squeeze(policy_shock_alternate(5,:,:,5,2)))
%     hold on
%     ksdensity([reshape(w_sim,[],1),reshape(k_sim,[],1))
%     title('Labor with borrowing constraints')
%     shading interp
%     subplot(2,2,2)
%     surf(-wshock_vec,k_space,squeeze(policy_shock_alternate(12,:,:,1,2))-squeeze(policy_shock_alternate(5,:,:,1,2)))
%     title('Labor without borrowing constraints')
