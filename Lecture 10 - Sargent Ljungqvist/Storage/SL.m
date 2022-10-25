clear

beta = 0.9985;
r = 0.04;
alpha = 0.0009;
lambda = 0.009;
tau = 0.023;

mu = 0.5;
sigma = 0.1;

UI_interval = linspace(0,2,16)';

h_space = linspace(1,2,21)';

pi_e = 0.9.*eye(21)+[zeros(21,1),[0.1*eye(20) ; [zeros(1,19),0.1]]];
pi_u = 0.8.*eye(21)+[[0.2,zeros(1,20)];[0.2*eye(20),zeros(20,1)]];

c = @(s) 0.5.*s;
% c = @(s) 0.*s;
pi = @(s) s.^0.3;

tau = 0.0285;

%Discretized wage space (no quadrature here)
    w_space = linspace(0,1,11)';
    prob_wage = pdf('norm',w_space,mu,sigma);
    prob_wage = prob_wage./sum(prob_wage);
    
%h_space = 

    V = 455*ones(length(w_space),length(h_space));
    V_b = 455*ones(length(UI_interval),length(h_space));
    V_0 = 455*ones(length(h_space),1);
    
    V_new = zeros(length(w_space),length(h_space));
    V_b_new = zeros(length(UI_interval),length(h_space));
    V_0_new = zeros(length(h_space),1);
    
    load V_sto.mat V_0 V_b V;
    
zcount = 0;
error = Inf;
while error > 1e-20
    zcount = zcount+1
        %Solve for V
                for w_ind = 1:length(w_space)
                    for h_ind = 1:length(h_space)
                        w = w_space(w_ind);
                        h = h_space(h_ind);
                        I = w.*h;
                        
                        [temp2, ind2] = min(abs(UI_interval-I)+(UI_interval<I)*1000);
    
                        V_new(w_ind,h_ind) = max( (1-tau).*w.*h + ...
                                     (1-alpha).*beta.*( (1-lambda).*sum((pi_e(h_ind,:)*V(w_ind,:)')) + ...
                                     lambda.*sum(pi_u(h_ind,:)*V_b(ind2,:)')) , V_0(h_ind));
                    end
                end

        %Solve for V_b
            for I_ind = 1:length(UI_interval)
                for h_ind = 1:length(h_space)
                    I = UI_interval(I_ind);
                    h = h_space(h_ind);
                    
                    %I change things a little here
                    
                    for hprime_ind = 1:length(h_space)
                            val_temp(:,hprime_ind) = max([V(:,hprime_ind),ones(length(w_space),1).*V_b(I_ind,hprime_ind)]')';
                            if isempty(w_space(min(find([V(:,hprime_ind)>ones(length(w_space),1).*V_b(I_ind,hprime_ind)]==1)))) ~= 1;
                                rwage(I_ind,hprime_ind) = w_space(min(find([V(:,hprime_ind)>ones(length(w_space),1).*V_b(I_ind,hprime_ind)]==1)));
                            else
                                rwage(I_ind,hprime_ind) = 1;
                            end
                    end
                    
                    
                    
                    
                    V_b_prob = @(s) -(-c(s) + (1-tau).*0.7.*I + (1-alpha).*beta.*(pi_u(h_ind,:)*((1-pi(s))*V_b(I_ind,:)' + pi(s).*sum(repmat(prob_wage,1,length(h_space)).*val_temp)')))  ;                  
                    z_ind = 0;
                    for s_try = 0:0.01:1
                        z_ind = z_ind+1;
                        s_try_vec(z_ind) = s_try;
                        V_b_prob_temp(z_ind) = V_b_prob(s_try);
                    end
                    [temp_a,temp_b] = min(V_b_prob_temp);

                    V_b_new(I_ind,h_ind) = -temp_a;
                    V_b_policy(I_ind,h_ind) = s_try_vec(temp_b);

                    
                end
            end

        %Solve for V_0
            for h_ind = 1:length(h_space)
                h = h_space(h_ind);
                %For each hprime find the integral over w of V
                temp_int_1 = zeros(1,length(h_space));
                for hprime_ind = 1:length(h_space);
                    hprime = h_space(hprime_ind);
                    temp_int_1(1,hprime_ind) = sum(prob_wage.*V(:,hprime_ind));
                end
                
                V_0_prob = @(s) -(-c(s) + (1-alpha).*beta.*(pi_u(h_ind,:)*((1-pi(s))*V_0+pi(s)*temp_int_1')));
                
%                     [temp1, temp2] = fminbnd(V_0_prob,0,1);

                        z_ind = 0;
                        for s_try = 0:0.01:1
                            z_ind = z_ind+1;
                            s_try_vec(z_ind) = s_try;
                            V_0_prob_temp(z_ind) = V_0_prob(s_try);
                        end
                        [temp_a,temp_b] = min(V_0_prob_temp);

                    V_0_new(h_ind) = -temp_a;
                    V_0_policy(h_ind) = s_try_vec(temp_b);
            end

        error = max([max(abs(V_0_new-V_0)),max(max(abs(V_b_new-V_b))),max(max(abs(V_new-V)))])
        
        [mean(mean(V_new)),mean(mean(V_b_new)),mean(V_0_new)]
        
        V_0 = V_0_new;
        V_b = V_b_new;
        V = V_new;
        
%         close all
%         figure(1)
%         plot(h_space,V_b_policy(9,:))
%         xlabel('Human Capital')
%         ylabel('Last Earnings')
%         drawnow
        save V_sto.mat V_0 V_b V
end

for I_ind = 1:length(UI_interval)
    for h_ind = 1:length(h_space)
        temp = squeeze(rwage_sto(I_ind,h_ind,:)).*w_space;
        if max(temp) == 0
            rwage(I_ind,h_ind) = 1;
        end
        if max(temp) > 0
            rwage(I_ind,h_ind) = min(temp(temp>0));
        end
    end
end


%Find reservation wage for unemployed
    for I_ind = 1:length(UI_interval)
        for h_ind = 1:length(h_space)
            I = UI_interval(I_ind);
            h = h_space(h_ind);
            
                    for hprime_ind = 1:length(h_space)
                            val_temp(:,hprime_ind) = max([V(:,hprime_ind),ones(length(w_space),1).*V_b(I_ind,hprime_ind)]')';
                    end

                    asdf
        end
    end

    %% 
    figure(1)
    surf(h_space,UI_interval,V_b_policy)
    ylabel('Past income')
    xlabel('Human Capital')
    set(gca,'Xdir','reverse')
    title('Search Intensities')
    view([140 45])
    
        figure(2)
    surf(h_space,UI_interval,rwage)
    xlabel('Past income')
    ylabel('Human Capital')
    title('Reservation Wages')
    view([40 45])
