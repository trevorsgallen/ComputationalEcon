clear

%Your assets
    A_min = 0.0001;
    A_max = 50;
    A_num = 31;
    A_vec = linspace(log(A_min+3),log(A_max+3),A_num)';
    
%Employment status
    tfp_vec = [0.99;1.01];
    E_vec = [0;1];

%Aggregate asset holding
    k_min = 11;
    k_max = 12.5;
    k_num = 4;
    k_vec = linspace(k_min,k_max,k_num)';

%Aggregate TFP holding  {TFP Hi, Emp}  {TFP Hi, Unemp}  {TFP Low, Emp}  {TFP Low, Unemp}
    tfp_pi = [0.292,0.583,0.094,0.031 ;
                0.024 0.851 0.009 0.116 ;
                0.031 0.094 0.525 0.350 ;
                0.002 0.123 0.039 0.836]

    [A_grid,TFP_grid,E_grid,k_grid] = ndgrid(A_vec,tfp_vec,E_vec,k_vec);
        
    beta = 0.99;
    alpha = 0.36;
    delta = 0.025;

    V_0 = -60+beta*log((A_grid+3)./10)+beta.^2*log((A_grid+3)./10)+beta.^3*log((A_grid+3)./10)+beta.^4*log((A_grid+3)./10)+beta.^5*log((A_grid+3)./10)+beta.^6*log((A_grid+3)./10)+beta.^7*log((A_grid+3)./10)+beta.^8*log((A_grid+3)./10)+beta.^9*log((A_grid+3)./10);
    V_1 = V_0;

    choice_c = zeros(size(A_grid));
    choice_Aprime = zeros(size(A_grid));
    wage_sto = zeros(size(A_grid));
    r_sto = zeros(size(A_grid));
    knextpred_sto = zeros(size(A_grid));

        z2 = 0;
         
    beta_sto = [0.095 0.962 0.085 0.965]
    z2 = 0
while 1 == 1
    clear error_sto
    tic
    z = 0;
     z2 = z2+1;
     z3=0;
     z4 = 0;
    error = Inf;
    
    tic
    while error  > exp(-12)  & z < 20
        z = z+1;
            v_interp = griddedInterpolant(A_grid,TFP_grid,E_grid,k_grid,V_0,'spline');
            for k_ind = 1:length(k_vec)
                k = k_vec(k_ind);
                for A_ind = 1:length(A_vec)
                    A = exp(A_vec(A_ind))-3;
                    for E_ind = 1:length(E_vec)
                        E = E_vec(E_ind);
                        for tfp_ind = 1:length(tfp_vec)
                            tfp = tfp_vec(tfp_ind);
                            if z2 == 1
                                z4 = z4+1;
                                z4/prod(size(A_grid))
                            end
                            
                            
                            if tfp == 1.01
                                base_r = alpha*tfp*(k^(alpha-1)*(0.309128)^(1-alpha))-delta;
                                base_wage = (1-alpha)*tfp*(k^alpha)*(0.309128)^(-alpha);
                                knextpred = exp(beta_sto(end,1)+beta_sto(end,2)*log(k));
                            end
                            if tfp == 0.99
                                base_r = alpha*tfp*(k^(alpha-1)*(0.297815)^(1-alpha))-delta;
                                base_wage = (1-alpha)*tfp*(k^alpha)*(0.297815)^(-alpha);
                                knextpred = exp(beta_sto(end,3)+beta_sto(end,4)*log(k));
                            end

                        %Start with good guess
                            if z < 2 & z2 == 1
                                x0=  [base_wage*E+(1+base_r)*A*(A>0),min(A,0)];
                            end
                            if z >= 2 | z2 ~= 1
                                 x0 = [choice_c(A_ind,tfp_ind,E_ind,k_ind),choice_Aprime(A_ind,tfp_ind,E_ind,k_ind)];
                            end
                            
                            wage_sto(A_ind,tfp_ind,E_ind,k_ind) = base_wage;
                            r_sto(A_ind,tfp_ind,E_ind,k_ind) = base_r;
                            knextpred_sto(A_ind,tfp_ind,E_ind,k_ind) = knextpred;

                        %U(c,L) = log(c)-psi*log(1-L)
                            %Where c+Aprime < x*L+(1+r)*A

                        %Choose all three subject to the constraint
                            %c is 1
                            %Aprime is 2
                                c_work = @(x) [x(1)+x(2) - (base_wage*E+(1+base_r)*A)];
                                ceq = @(x) 0;
                                nonlinfcn_work = @(x)deal(c_work(x),ceq(x));
                                
                                if tfp_ind == 1 & E_ind == 1
                                    temp_prob = tfp_pi(1,:);
                                elseif tfp_ind == 1 & E_ind == 2
                                    temp_prob = tfp_pi(2,:);
                                elseif tfp_ind == 2 & E_ind == 1
                                    temp_prob = tfp_pi(3,:);
                                elseif tfp_ind == 2 & E_ind == 2
                                    temp_prob = tfp_pi(4,:);
                                end

                                
                                V_interp = @(x) sum([temp_prob*v_interp(ones(4,1).*log(x(2)+3),[1.01;1.01;0.99;0.99],[1;0;1;0],ones(4,1).*knextpred)]);

                                foptions = optimset('Display','off');
                                ut_work = @(x) -(log(x(1))+beta*V_interp(x));
                                [temp1_work,temp2_work] = fmincon(ut_work,x0,[],[],[],[],[0.001,A_min],[Inf,A_max],nonlinfcn_work,foptions);
                                
                                V_1(A_ind,tfp_ind,E_ind,k_ind) = -temp2_work;
                                choice_c(A_ind,tfp_ind,E_ind,k_ind) = temp1_work(1);
                                choice_Aprime(A_ind,tfp_ind,E_ind,k_ind) = temp1_work(2);
                        end
                    end
                end
            end
            toc
            
            figure(5)
            plot(exp(A_grid(:,1,1,1))-3,choice_Aprime(:,2,2,round(k_num/2)))
            hold on
            plot(exp(A_grid(:,1,1,1))-3,exp(A_grid(:,1,1,1))-3,'--r')
            drawnow
            
            error = max(reshape(abs(V_1-V_0),[],1));

            error = max(reshape(abs(V_1-V_0),[],1));
            V_0 = V_1;
            figure(3)
            error_sto(z) = error;
            scatter(z,log(error_sto(z)))
            hold on
            drawnow 
            figure(3)
            toc
    end

    clear *_sim
    %Simulate
    rng(1)
    T = 2000
    N = 1000;
    A_sim = NaN(N,T)*5;
    c_sim = NaN(N,T);
    L_sim = NaN(N,T);
    w_sim = NaN(N,T);
    k_sim = NaN(1,T);
    tfp_sim = NaN(1,T);

    MPL_sim = NaN(1,T);
    MPK_sim = NaN(1,T);

    A_sim(:,1) =  11+9.23*randn(length(A_sim(:,1)),1);
    A_sim(find(A_sim(:,1) > A_max),1) = A_max;
    A_sim(find(A_sim(:,1) < A_min),1) = A_min;

            
    tfp_sim(1) = 1;
    
    tfp_sim = 1.01;
    for t = 2:T
        temp=rand;
            if temp <= 0.875
                tfp_sim(t) = tfp_sim(t-1);
            elseif temp > 0.875 & tfp_sim(t-1) == 1.01
                tfp_sim(t) = 0.99;
            else
                tfp_sim(t) = 1.01;
            end
    end

    E_sim = rand(N,1)>0.069696;
    for t = 2:T
        t;
        for i = 1:N
            temp = rand;
            if tfp_sim(t) == 1.01 & E_sim(i,t-1) == 0
                if rand <= tfp_pi(1,1)+tfp_pi(1,3)
                    E_sim(i,t) = 0 ;
                else
                    E_sim(i,t) = 1;
                end
            end
            if tfp_sim(t) == 1.01 & E_sim(i,t-1) == 1
                if rand <= tfp_pi(2,1)+tfp_pi(2,3)
                    E_sim(i,t) = 0 ;
                else
                    E_sim(i,t) = 1;
                end
            end
            if tfp_sim(t) == 0.99 & E_sim(i,t-1) == 0
                if rand <= tfp_pi(3,1)+tfp_pi(3,3)
                    E_sim(i,t) = 0 ;
                else
                    E_sim(i,t) = 1;
                end
            end
            if tfp_sim(t) == 0.99 & E_sim(i,t-1) == 1
                if rand <= tfp_pi(4,1)+tfp_pi(4,3)
                    E_sim(i,t) = 0 ;
                else
                    E_sim(i,t) = 1;
                end
            end
        end
    end
    
        choice_A_fxn = griddedInterpolant(A_grid,TFP_grid,E_grid,k_grid,choice_Aprime);
        choice_c_fxn = griddedInterpolant(A_grid,TFP_grid,E_grid,k_grid,choice_c);

        tic
    for t = 1:T
        t;
        k_sim(t) = min(max(mean(A_sim(:,t)),k_min),k_max);
        for i = 1:N
            A_sim(i,t+1) = choice_A_fxn([log(A_sim(i,t)+3),tfp_sim(t),E_sim(i,t),k_sim(t)]);
            c_sim(i,t) = choice_c_fxn([log(A_sim(i,t)+3),tfp_sim(t),E_sim(i,t),k_sim(t)]);
        end
        if max(reshape(isnan(A_sim(:,t)),[],1))==1
            asdf
        end
    end
    
    Y_sim = tfp_sim(1:T).*((k_sim(:,1:T).^alpha).*mean(E_sim(:,1:T)).^(1-alpha));

    alpha = 1-0.64

    X = [ones(length(k_sim(1000:end-1)),1),log(k_sim(1000:end-1))'];

    beta_knext = (inv(X'*X)*X'*log(k_sim(1001:end))')';
    
    %Weight reminiscent of Kiefer-Wolfowitz (1952) (bc calculational errors)
    weight = 0.5*(z2.^(-1/3));
    weight = 0.3
    beta_sto(end+1,:) = (1-weight)*beta_sto(end,:)+weight*[beta_knext];
    if exist('beta_sto_2') == 0
        beta_sto_2 = [beta_knext]
    end
    beta_sto_2(end+1,:) = [beta_knext];
    
    close all
    figure(4)
    for x = 1:2
        subplot(3,3,x)
        plot(beta_sto(1:end,x))
        hold on
        plot(beta_sto_2(1:end,x),'--r')
        if x == 1
            title('Knext constant')
        elseif x == 2
            title('Knext capital')
        end
        drawnow
    end
    
    figure(5)
    plot(k_sim)
    drawnow
    
    [beta_sto(end,:)./beta_sto_2(end,:)-1;beta_sto(end,:)-beta_sto_2(end,:);beta_sto(end,:);beta_sto_2(end,:)]

end
plot(exp(A_vec)-3,choice_Aprime(:,1,2,round(k_num/2))-(exp(A_vec)-3),'--k')
hold on
plot(exp(A_vec)-3,choice_Aprime(:,2,2,round(k_num/2))-(exp(A_vec)-3),'-k')
hold on
plot(exp(A_vec)-3,choice_Aprime(:,1,1,round(k_num/2))-(exp(A_vec)-3),'--b')
hold on
plot(exp(A_vec)-3,choice_Aprime(:,2,1,round(k_num/2))-(exp(A_vec)-3),'-b')
plot(exp(A_vec)-3,exp(A_vec)-3-(exp(A_vec)-3),'--r')
title('Savings Rules')
xlabel('Individual Capital')
ylabel('Change in Individual Capital')
legend('Employed, High TFP','Employed, Low TFP','Not employed, High TFP','Not Employed, Low TFP','No Change Line')
print('/Users/tgallen/Dropbox/ResponseHeterogeneity/Writeup/Figures/Fig_KS_SavingsRule.png','-dpng')
