            for I_ind = 1:length(UI_interval)
                for h_ind = 1:length(h_space)
                    I = UI_interval(I_ind);
                    h = h_space(h_ind);

                    %Find the unemployment insurance b(I) given I
                        b_I = 0.7.*UI_interval(I_ind);


                         %Given the current I and current h, we need to
                         %calculate how happy we are next period.
                            int_temp_1 = zeros(length(h_space),1);
                            int_temp_2 = zeros(length(h_space),1);

                            for hprime_ind = 1:length(h_space)
                                for wdraw_ind = 1:length(w_space)
                                    hprime = h_space(hprime_ind);
                                    wdraw = w_space(wdraw_ind);

                                    if wdraw.*hprime >= b_I
                                        int_temp_1(hprime_ind) = int_temp_1(hprime_ind) + prob_wage(wdraw_ind).*V(wdraw_ind,hprime_ind);
                                    end

                                    if wdraw.*hprime < b_I
                                        %Find the proper space

                                        [temp2, ind2] = min(abs(UI_interval-hprime.*wdraw)+(UI_interval<hprime.*wdraw)*1000);
                                        
                                        %Two choices: accept or reject
                                        %If accept,
                                        choice1 = (1-tau).*wdraw.*hprime + (1-alpha).*beta.*((1-lambda).*(pi_e(hprime_ind,:)*V(wdraw_ind,:)') + lambda.*(pi_u(hprime_ind,:)*V_b(ind2,:)'));
                                        choice2 = V_b(I_ind,hprime_ind);

                                        int_temp_2(hprime_ind) = int_temp_2(hprime_ind)+ prob_wage(wdraw_ind).*max(choice1,choice2);
                                    end
                                end
                            end

                        V_b_prob = @(s) -(-c(s) + (1-tau).*b_I + (1-alpha).*beta.*sum(pi_u(h_ind,:)*((1-pi(s)).*V_b(I_ind,:)' + pi(s).*(int_temp_1 + int_temp_2))));

%                         plot([0;0.05;0.075;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],-[V_b_prob(0);V_b_prob(0.05);V_b_prob(0.075);V_b_prob(0.1);V_b_prob(0.2);V_b_prob(0.3);V_b_prob(0.4);V_b_prob(0.5);V_b_prob(0.6);V_b_prob(0.7);V_b_prob(0.8);V_b_prob(0.9);V_b_prob(1)])
%                         hold on
%                         scatter([0;0.05;0.075;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],-[V_b_prob(0);V_b_prob(0.05);V_b_prob(0.075);V_b_prob(0.1);V_b_prob(0.2);V_b_prob(0.3);V_b_prob(0.4);V_b_prob(0.5);V_b_prob(0.6);V_b_prob(0.7);V_b_prob(0.8);V_b_prob(0.9);V_b_prob(1)])
%                         drawnow 
                        
                        z_ind = 0;
                        for s_try = 0:0.01:1
                            z_ind = z_ind+1;
                            s_try_vec(z_ind) = s_try;
                            V_b_prob_temp(z_ind) = V_b_prob(s_try);
                        end
                        [temp_a,temp_b] = min(V_b_prob_temp);
                        
%                         [temp1, temp2] = fminbnd(V_b_prob,0,1);

                    V_b_new(I_ind,h_ind) = -temp_a;
                    V_b_policy(I_ind,h_ind) = s_try_vec(temp_b);
%                     V_b_policy(I_ind,h_ind) = temp_b;

                end
            end