%Preliminaries
    clc;
    clear;
    close all;

%Set parameters
    beta = 0.9985;  %Discounting
    alpha = 0.0009; %Probability of death
    lambda = 0.009; %Probability of being laid off
    tau = 0.0285;   %Tax rate (welfare state)
    tau_LF = 0;     %Tax rate (Laissez-faire)

%Distribution of wage draws
    mu = 0.5;
    sigma = sqrt(0.1);

%Unemployment insurance intervals
    UI_interval = linspace(0,2,16)';

%Human capital levels and transition matricies
    h_space = linspace(1,2,21)';
    pi_e = 0.9.*eye(21)+[zeros(21,1),[0.1*eye(20) ; [zeros(1,19),0.1]]];
    pi_u = 0.8.*eye(21)+[[0.2,zeros(1,20)];[0.2*eye(20),zeros(20,1)]];

%Cost of search and probability of job offer
    c = @(s) 0.5.*s;
    pi = @(s) s.^0.3;

%Discretized wage space (no quadrature)
    w_space = linspace(0,1,11)';
    prob_wage = pdf('norm',w_space,mu,sigma);
    prob_wage = prob_wage./sum(prob_wage);
    
%Initialize value functions
    V = 642*ones(length(w_space),length(h_space));
    V_b = 640*ones(length(UI_interval),length(h_space));
    V_0 = 637*ones(length(h_space),1);
    
    V_new = zeros(length(w_space),length(h_space));
    V_b_new = zeros(length(UI_interval),length(h_space));
    V_0_new = zeros(length(h_space),1);
    
%Do same for Laissez-Faire economy
    V_LF = 642*ones(length(w_space),length(h_space));
    V_b_LF = 640*ones(length(UI_interval),length(h_space));
    V_0_LF = 637*ones(length(h_space),1);
    
    V_new_LF = V_LF;
    V_b_new_LF = V_b_LF;
    V_0_new_LF = V_0_LF;
% asdf
%     load V_sto3.mat V_0 V_b V V_0_LF V_b_LF V_LF;

%Solve the welfare state economy
    zcount = 0;
    error = Inf;
    while error > 1e-10
        zcount = zcount+1
            %Solve for V
                    for w_ind = 1:length(w_space)
                        for h_ind = 1:length(h_space)
                            w = w_space(w_ind);
                            h = h_space(h_ind);
                            I = w.*h;
                            %Grab the relevant UI index
                                [temp2, ind2] = min(abs(UI_interval-I)+(UI_interval<I)*1000);

                            %Calculate the value function RHS, store
                                V_new(w_ind,h_ind) = max( (1-tau).*w.*h + ...
                                             (1-alpha).*beta.*( (1-lambda).*sum((V(w_ind,:).*pi_e(h_ind,:))) + ...
                                             lambda.*sum(V_b(ind2,:).*pi_u(h_ind,:))) , V_0(h_ind));
                        end
                    end

            %Solve for V_b
                for I_ind = 1:length(UI_interval)
                    for h_ind = 1:length(h_space)
                        I = UI_interval(I_ind);
                        h = h_space(h_ind);
                        %Conditionally integrate over w for each h.
                        for hprime_ind = 1:length(h_space)
                                for wdraw_ind = 1:length(w_space)
                                    hprime = h_space(hprime_ind);
                                    wdraw = w_space(wdraw_ind);
                                    %Grab the UI index
                                        [temp2, ind2prime] = min(abs(UI_interval-hprime.*wdraw)+(UI_interval<hprime.*wdraw)*1000);
                                    %If offer below replacement, can reject
                                        if wdraw*hprime < I.*0.7
                                            v_alt(wdraw_ind,hprime_ind) = max((1-tau).*wdraw.*hprime + ...
                                             (1-alpha).*beta.*( (1-lambda).*(sum(V(wdraw_ind,:).*pi_e(hprime_ind,:))) + ...
                                             lambda.*(sum(V_b(ind2prime,:).*pi_u(hprime_ind,:)))) , V_b(I_ind,hprime_ind));
                                    %Otherwise, accept
                                        elseif wdraw*hprime >= I.*0.7
                                            v_alt(wdraw_ind,hprime_ind) = V(wdraw_ind,hprime_ind);
                                        end
                                end
                                %Store the results of this
                                %second-sub-period optimization problem
                                    val_temp(:,hprime_ind) = v_alt(:,hprime_ind);
                        end
                        
                        %Now that we have that, we can solve for how much
                        %we should search (continuous).
                            V_b_prob = @(s) -(-c(s) + (1-tau).*0.7.*I + (1-alpha).*beta.*(sum(((1-pi(s))*V_b(I_ind,:) + pi(s).*sum(repmat(prob_wage,1,length(h_space)).*val_temp)).*pi_u(h_ind,:))))  ;                  
                            [temp_b,temp_a] = fminbnd(V_b_prob,0,1);

                        V_b_new(I_ind,h_ind) = -temp_a;
                        V_b_policy(I_ind,h_ind) = temp_b;

                    end
                end

            %Solve for V_0
                for h_ind = 1:length(h_space)
                    h = h_space(h_ind);

                    %RHS of V_0 problem
                    V_0_prob = @(s) -(-c(s) + (1-alpha).*beta.*sum(((1-pi(s))*V_0'+pi(s)*sum(repmat(prob_wage,1,length(h_space)).*V)).*pi_u(h_ind,:)));

                    [temp1, temp2] = fminbnd(V_0_prob,0,1);
                    V_0_new(h_ind) = -temp2;
                    V_0_policy(h_ind) = temp1;

                end

            error = max([max(abs(V_0_new-V_0)),max(max(abs(V_b_new-V_b))),max(max(abs(V_new-V)))])

            [mean(mean(V_new)),mean(mean(V_b_new)),mean(V_0_new)]

            V_0 = V_0_new;
            V_b = V_b_new;
            V = V_new;
        save V_sto4.mat V_0 V_b V V_0_LF V_b_LF V_LF;
    end

    save V_sto4.mat V_0 V_b V V_0_LF V_b_LF V_LF;
    
%% Laissez-Faire economy
    zcount = 0;
    error = Inf;
    while error > 1e-10
        zcount = zcount+1
            %Solve for V
                    for w_ind = 1:length(w_space)
                        for h_ind = 1:length(h_space)
                            w = w_space(w_ind);
                            h = h_space(h_ind);
                            I = w.*h;

                            [temp2, ind2] = min(abs(UI_interval-I)+(UI_interval<I)*1000);

                            V_new_LF(w_ind,h_ind) = max( (1-tau_LF).*w.*h + ...
                                         (1-alpha).*beta.*( (1-lambda).*sum((pi_e(h_ind,:)*V_LF(w_ind,:)')) + ...
                                         lambda.*sum(pi_u(h_ind,:)*V_b_LF(ind2,:)')) , V_0_LF(h_ind));
                        end
                    end

            %Solve for V_0
                for h_ind = 1:length(h_space)
                    h = h_space(h_ind);

                    V_0_prob_LF = @(s) -(-c(s) + (1-alpha).*beta.*(pi_u(h_ind,:)*((1-pi(s))*V_0_LF+pi(s)*sum(repmat(prob_wage,1,length(h_space)).*V_LF)')));

                    [temp1, temp2] = fminbnd(V_0_prob_LF,0,1);
                    V_0_new_LF(h_ind) = -temp2;
                    V_0_policy_LF(h_ind) = temp1;

                end

            %Solve for V_b
                for I_ind = 1:length(UI_interval)
                    for h_ind = 1:length(h_space)
                        V_b_new_LF(I_ind,h_ind) = V_0_new_LF(h_ind);
                    end
                end

            error = max([max(abs(V_0_new_LF-V_0_LF)),max(max(abs(V_b_new_LF-V_b_LF))),max(max(abs(V_new_LF-V_LF)))])

            [mean(mean(V_new_LF)),mean(mean(V_b_new_LF)),mean(V_0_new_LF)]

            V_0_LF = V_0_new_LF;
            V_b_LF = V_b_new_LF;
            V_LF = V_new_LF;
            save V_sto4.mat V_0 V_b V V_0_LF V_b_LF V_LF;
    end

        save V_sto4.mat V_0 V_b V V_0_LF V_b_LF V_LF;


%Find reservation wage for unemployed
    for I_ind = 1:length(UI_interval)
        for h_ind = 1:length(h_space)
            I = UI_interval(I_ind);
            h = h_space(h_ind);
            
                    for hprime_ind = 1:length(h_space)
                            val_temp(:,hprime_ind) = max([V(:,hprime_ind),ones(length(w_space),1).*V_b(I_ind,hprime_ind)]')';
                    end
        end
    end

    %% Calculate reservation wage with UI benefits
    for I_ind = 1:length(UI_interval)
        for h_ind = 1:length(h_space)
            tempfun = @(w) interp1(w_space,V(:,h_ind),w,'linear','extrap') - V_b(I_ind,h_ind);
            if sign(tempfun(0)) ~= sign(tempfun(5))
                [rwage(I_ind,h_ind),temp1,temp2] = fzero(tempfun,[0,5]);
            elseif (sign(tempfun(0)) ~= sign(tempfun(1))) & sign(tempfun(1)) < 0
                rwage(I_ind,h_ind) = 1;
            else
                rwage(I_ind,h_ind) = 0;
            end
        end
    end
    
    %%Calculate reservation wage with no UI benefits
    for h_ind = 1:length(h_space)
        if h_ind == 1
            tempfun = @(w) interp1(w_space,V(:,h_ind),w,'linear','extrap') - V_b(I_ind,h_ind);
            V_cts = @(w) [interp1(w_space',V(:,h_ind),w)];
        elseif h_ind > 1
            V_cts = @(w) [V_cts(w),interp1(w_space,V(:,h_ind),w)];
        end
    end
        
    %Welfare State
        clear rwage_V
        for h_ind = 1:length(h_space)
                tempfun = @(w) ((1-tau).*w.*h_space(h_ind) + (1-alpha).*beta.*( (1-lambda).*sum((pi_e(h_ind,:)*V_cts(w)')) + ...
                         lambda.*sum(pi_u(h_ind,:)*V_b(find(UI_interval-w.*h >= 0, 1, 'first'),:)'))) - V_0(h_ind);
            if sign(tempfun(0)) ~= sign(tempfun(1))
                [rwage_V(h_ind)] = fzero(tempfun,[0,1]);
            elseif (sign(tempfun(0)) ~= sign(tempfun(1))) & sign(tempfun(1)) < 0
                    rwage_V(h_ind) = 1;
            else
                rwage_V(h_ind)=0;
            end
        end
        
    %%Calculate reservation wage with no UI benefits
    for h_ind = 1:length(h_space)
        if h_ind == 1
            tempfun_LF = @(w) interp1(w_space,V_LF(:,h_ind),w,'linear','extrap') - V_b_LF(I_ind,h_ind);
            V_cts_LF = @(w) [interp1(w_space',V_LF(:,h_ind),w)];
        elseif h_ind > 1
            V_cts_LF = @(w) [V_cts_LF(w),interp1(w_space,V_LF(:,h_ind),w)];
        end
    end
    
    %Laissez-Faire
        clear rwage_V_LF
        for h_ind = 1:length(h_space)
                tempfun_LF = @(w) ((1-tau_LF).*w.*h_space(h_ind) + (1-alpha).*beta.*( (1-lambda).*sum((pi_e(h_ind,:)*V_cts_LF(w)')) + ...
                         lambda.*sum(pi_u(h_ind,:)*V_b_LF(1,:)'))) - V_0_LF(h_ind);
            if sign(tempfun(0)) ~= sign(tempfun(1))
                [rwage_V_LF(h_ind)] = fzero(tempfun_LF,[0,1]);
            elseif (sign(tempfun_LF(0)) ~= sign(tempfun_LF(1))) & sign(tempfun_LF(1)) < 0
                    rwage_V_LF(h_ind) = 1;
            else
                rwage_V_LF(h_ind)=0;
            end
        end

%Simulate job finding probability.
    %No simulation
    sim_H = 2;
    sim_Hprime1 = 2;
    sim_Hprime2 = 1.95;
    i_ind = length(UI_interval);
    
    wbounds = [[0;cumsum(prob_wage(1:end-1))],cumsum(prob_wage)]
    
    for h_ind = 1:length(h_space)
        s = interp2(h_space,UI_interval,V_b_policy,h_space(h_ind),UI_interval(i_ind));
        %For each offer, see if they accept
        for w_ind = 1:length(w_space)
            if w_space(w_ind) >= interp2(h_space,UI_interval,rwage,h_space(h_ind),UI_interval(i_ind)) | rwage > 0.7.*UI_interval(i_ind)
                accept(w_ind) = 1;
            else 
                accept(w_ind) = 0;
            end
        end
        accept_pr(h_ind) = sum(prob_wage.*accept');
    end
    
%Get the probabilities of your state and the probability of an acceptable
%wage.
    H_sim(:,1) = zeros(length(h_space),1);
    H_sim(end,1) = 1;
    accept_sim = zeros(1,52*5)
    accept_sim(1) = sum(accept_pr'.*H_sim(:,1));
    for t = 2:52*5
        H_sim(:,t) = H_sim(:,t-1)'*pi_u;
        accept_sim(t) = sum(accept_pr'.*H_sim(:,t));
    end
    

%Finding job    
%     for i_ind = 1:I
%         i_ind
%         for t = 1:T
%             if sim_E(i_ind,t) == 0
%                 %Find their search
%                     s_sim(i_ind,t) = ;
%                 
%                 %Determine whether or not they're made an offer
%                     temp1 = rand;
%                     if temp1 < s_sim(i_ind,t).^0.3;
%                         temp2 = rand;
%                         woffer = w_space(find(wbounds(:,1) < temp2 & wbounds(:,2) >= temp2));
%                         if woffer < interp2(h_space,UI_interval,rwage,sim_H(i_ind,t),sim_UI(i_ind,t));
%                             sim_E(i_ind,t+1) = 0;
%                         elseif woffer >= interp2(h_space,UI_interval,rwage,sim_H(i_ind,t),sim_UI(i_ind,t));
%                             sim_E(i_ind,t+1:end) = 1;
%                             sim_findjob(i_ind) = t;
%                         end
%                     elseif temp1 >= s_sim(i_ind,t).^0.3;
%                         sim_E(i_ind,t+1) = 0;
%                     end
%                 %Next, find HC next period
%                     temp3 = rand;
%                     if temp3 < 0.2
%                         sim_H(i_ind,t+1) = max(sim_H(i_ind,t+1)-0.05,1);
%                     elseif temp3 >= 0.2
%                         sim_H(i_ind,t+1) = sim_H(i_ind,t);
%                     end
%             end
%         end
%     end
%     
%     for t = 1:52*5
%         numfindjob(t) = length(find(sim_findjob==t))./length(find(sim_findjob>=t))
%     end

        
    figure(1)
    surf(h_space,UI_interval,V_b_policy)
    ylabel('Past income')
    xlabel('Human Capital')
    set(gca,'Xdir','reverse')
    title('Search Intensities')
    zlim([0,1])
    view([140 45])

    figure(2)
    surf(h_space,UI_interval,rwage)
    xlabel('Human Capital')
    ylabel('Past Earnings')
    title('Reservation Wages')
    zlim([0.7,1])
    caxis([0.7,0.95])
    view([25 25])
    
    figure(3)
    plot(h_space,rwage_V)
    hold on
    plot(h_space,rwage_V_LF,'--r')
    xlabel('Human Capital')
    ylabel('Reservation Wage')
    xlim([1,2])
    ylim([0.65,0.85])
    
%    figure(4)
%    plot(numfindjob)


