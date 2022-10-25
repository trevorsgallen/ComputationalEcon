clear

beta = 0.9985;
r = 0.04;
alpha = 0.0009;
lambda = 0.009;
tau = 0.023;

mu = 0.5;
sigma = 0.1;

UI_interval = linspace(0,2,15)';

h_space = linspace(1,2,21)';

pi_e = 0.9.*eye(21)+[zeros(21,1),[0.1*eye(20) ; [zeros(1,19),0.1]]];
pi_u = 0.8.*eye(21)+[[0.2,zeros(1,20)];[0.2*eye(20),zeros(20,1)]];

c = @(s) 0.5.*s;
pi = @(s) s.^0.3;

tau = 0.0285;

%Discretized wage space (no quadrature here)
    w_space = linspace(0,1,11)';
    prob_wage = pdf('norm',w_space,mu,sigma);
    prob_wage = prob_wage./sum(prob_wage);
    
%h_space = 
%Wh_space 
    wh_space = kron(w_space,h_space);
    wh_space_h = kron(ones(length(w_space),1),h_space);

    V = zeros(length(w_space),length(h_space));
    V_b = zeros(length(wh_space),length(h_space));
    V_0 = zeros(length(h_space),1);
    
    V_new = zeros(length(w_space),length(h_space));
    V_b_new = zeros(length(wh_space),length(h_space));
    V_0_new = zeros(length(h_space),1);
    
%     load V_sto.mat V_0 V_b V;
    asdf
error = Inf;
while error > 0.1
        %Solve for V
                for w_ind = 1:length(w_space)
                    for h_ind = 1:length(h_space)
                        w = w_space(w_ind);
                        h = h_space(h_ind);
                        V_new(w_ind,h_ind) = max( (1-tau).*w.*h + ...
                                     (1-alpha).*beta.*((1-lambda).*sum((pi_e(h_ind,:)*V(w_ind,:)')) + ...
                                     lambda.*sum(pi_u(h_ind,:)*V_b(find(w.*h==wh_space & h == wh_space_h),:)')) , V_0(find(h==h_space)));
                    end
                end

        %Solve for V_b
            for I_ind = 1:length(wh_space)
                for h_ind = 1:length(h_space)
                    I = wh_space(I_ind);
                    h = h_space(h_ind);

                    %Find the unemployment insurance b(I) given I
                        [temp, ind] = min(abs(UI_interval-I));
                        b_I = 0.7.*UI_interval(ind);

                     %Sargent & Ljungqvist didn't seem to specify what I_g(I) was, but
                     %it was probably accept if new income more than old
                         [h_grid,w_grid] = meshgrid(h_space,w_space);

                         %First part
                             int_temp_1 = zeros(length(h_space),1);
                             int_temp_2 = zeros(length(h_space),1);
                             %For each h', we'll get the integral over relevant w
                             for hprime_ind = 1:length(h_space);
                                 hprime = h_space(hprime_ind);
                                 %We'll be integrating over all possible w's
                                 for w_ind = 1:length(w_space);
                                     w = w_space(w_ind);
                                     %It goes into integral #1 if wh'>=I
                                         if w.*hprime >= I
                                             int_temp_1(hprime_ind) = int_temp_1(hprime_ind) + V(w_ind,hprime_ind).*prob_wage(w_ind);
                                         end
                                     %And into integral #2 if wh'<I, in which case you
                                     %have a choice
                                         if w.*hprime < I
                                                %First, for each hprime find the new I
                                                    [temp2, ind2] = min(abs(UI_interval-w.*hprime));
                                                %Now, we have two parts: first choice
                                                     int_temp_2_pt1 = (1-tau).*w.*hprime + (1-alpha).*beta.*((1-lambda).*sum(pi_e(hprime_ind,:).*V(w_ind,:)) + ...
                                                     + lambda.*sum(pi_u(hprime_ind,:)*V_b(ind2,:)'));
                                                 %Second choice
                                                     int_temp_2_pt2 = V_b(ind,hprime_ind);
                                                 %The second integral is the higher of
                                                 %those two!
                                                 int_temp_2(hprime_ind) = prob_wage(w_ind).*max(int_temp_2_pt1,int_temp_2_pt2);
                                         end

                                 end
                             end

                        V_b_prob = @(s) -(-c(s) + (1-tau).*b_I + (1-alpha).*beta.*sum(pi_u(h_ind,:)*((1-pi(s)).*V_b(I_ind,:)' + pi(s).*(int_temp_1 + int_temp_2))));
                        z_ind = 0;
                        for s_try = 0:0.01:1
                            z_ind = z_ind+1;
                            s_try_vec(z_ind) = s_try;
                            V_b_prob_temp(z_ind) = V_b_prob(s);
                        end
                        [temp_a,temp_b] = min(V_b_prob_temp)
%                         [temp1, temp2] = fminbnd(V_b_prob,0,1);

                    V_b_new(I_ind,h_ind) = -temp_b;
                    V_b_policy(I_ind,h_ind) = s_try_vec(temp_a);
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
                V_0_prob = @(s) -(-c(s) + (1-alpha).*beta.*sum(pi_u(h_ind,:)*((1-pi(s))*V_0+pi(s)*temp_int_1')));

                    [temp1, temp2] = fminbnd(V_0_prob,0,1);

                    V_0_new(h_ind) = -temp2;
                    V_0_policy(h_ind) = temp1;
            end

        error = max([max(abs(V_0_new-V_0)),max(max(abs(V_b_new-V_b))),max(max(abs(V_new-V)))])
        
        [max(V_0_new),max(max(V_b_new)),max(max(V_new))]
        
        V_0 = V_0_new;
        V_b = V_b_new;
        V = V_new;
        
end

temp = sortrows([wh_space,V_b_policy])
temp = temp(:,2:end)

save V_sto.mat V_0 V_b V