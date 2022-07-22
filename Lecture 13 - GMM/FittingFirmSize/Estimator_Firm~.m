function error = Estimator(theta)

    rng(1,'twister')

    num_F = 5000;
    num_HH = 50000;

    
    alpha = theta(1);
    mu_A = theta(2);
    sigma_A = theta(3);
    A = lognrnd(mu_A,sigma_A,num_F,1);
    tau = 0.01;
    cutoff = 4;

    mu_psi = theta(4);
    sigma_psi = theta(5);
    psi = lognrnd(mu_psi,sigma_psi,num_HH,1);

    %Idiosyncratic firm production functions
        f = @(A,L) A.*L.^alpha;

    %Firm labor demand
        L_D = @(w,A,tau) ((w.*(1+tau))./(alpha.*A)).^(1./(alpha-1));
    %Three possible labors
        L_poss = @(w,A,tau) [L_D(w,A,0),L_D(w,A,tau),cutoff*ones(length(A),1)];   
    %Compare profits
        subindex = @(M,ind1,ind2) M(ind1,ind2);
        pi_poss =  @(w,A,tau) ([ ...
            (subindex(L_poss(w,A,tau),:,1)<cutoff).*(f(A,subindex(L_poss(w,A,tau),:,1))-w.*subindex(L_poss(w,A,tau),:,1)) , ...
            f(A,subindex(L_poss(w,A,tau),:,2))-(1+tau).*w.*subindex(L_poss(w,A,tau),:,2)-10000.*(subindex(L_poss(w,A,tau),:,1)<=cutoff) , ...
            f(A,subindex(L_poss(w,A,tau),:,3))-w.*subindex(L_poss(w,A,tau),:,3)]);

    %Choices
        L_choice_ind = @(w,A,tau)   1.*(subindex(pi_poss(w,A,tau),:,1) > subindex(pi_poss(w,A,tau),:,2) & subindex(pi_poss(w,A,tau),:,1) > subindex(pi_poss(w,A,tau),:,3)) + ...
                                    2.*(subindex(pi_poss(w,A,tau),:,2) > subindex(pi_poss(w,A,tau),:,1) & subindex(pi_poss(w,A,tau),:,2) > subindex(pi_poss(w,A,tau),:,3)) + ...
                                    3.*(subindex(pi_poss(w,A,tau),:,3) > subindex(pi_poss(w,A,tau),:,1) & subindex(pi_poss(w,A,tau),:,3) > subindex(pi_poss(w,A,tau),:,2)) ;
    %Final Labor Choice
        L_D = @(w,A,tau)  subindex(L_poss(w,A,tau),:,1).*(subindex(pi_poss(w,A,tau),:,1) > subindex(pi_poss(w,A,tau),:,2) & subindex(pi_poss(w,A,tau),:,1) > subindex(pi_poss(w,A,tau),:,3)) + ...
                          subindex(L_poss(w,A,tau),:,2).*(subindex(pi_poss(w,A,tau),:,2) > subindex(pi_poss(w,A,tau),:,1) & subindex(pi_poss(w,A,tau),:,2) > subindex(pi_poss(w,A,tau),:,3)) + ...
                          subindex(L_poss(w,A,tau),:,3).*(subindex(pi_poss(w,A,tau),:,3) > subindex(pi_poss(w,A,tau),:,1) & subindex(pi_poss(w,A,tau),:,3) > subindex(pi_poss(w,A,tau),:,2)) ;

    %Utility function
        U = @(w,L) w.*L - 0.001.*(w.*L).^2 + psi.*(1-L);
    %Household labor supply
        L_S = @(w,psi,tau) w./(psi+2.*0.001.*(w.^2));

    %Difference between labor supply and demand:
        Q_diff = @(w) sum(L_S(w,psi)) - sum(L_D(w,A,0));

    %Clear markets
        wstar = fsolve(Q_diff,1);
    
    %Supply and demand
        z = 0;
        for w = linspace(0.5.*wstar,2.*wstar,100)
            z=z+1;
            w_sto(z) = w;
            LS_sto(z) = sum(L_S(w,psi));
            LD_sto(z) = sum(L_D(w,A,0));
        end

        %Moments
            %Proportion of firms smaller than 1
                mom(1,:) = [length(find(L_D(wstar,A,tau)<1))./length(L_D(wstar,A,tau)) , 0.0002]*10000
            %Between 1 and 2
                mom(2,:) = [length(find(L_D(wstar,A,tau)>1 & L_D(wstar,A,tau)<2))./length(L_D(wstar,A,tau)) , 0.0606]*100
            %Between 3 and 4
                mom(3,:) = [length(find(L_D(wstar,A,tau)>3 & L_D(wstar,A,tau)<4))./length(L_D(wstar,A,tau)) , 0.3392]*10
            %At the cutoff
                mom(4,:) = [length(find(L_D(wstar,A,tau)==cutoff))./length(L_D(wstar,A,tau)) , 0.2074]*10
            %Mean firm size
                 mom(5,:) = [mean(L_D(wstar,A,tau)) , 3.4212310169064]
            %Proportion of households that provide < 0.35 labor
                mom(6,:) = [length(find(L_S(wstar,psi)<0.35))./length(L_S(wstar,psi)) , 0.56628]*10
            %Proportion of households that provide between 0.35 and 0.6 lab
                mom(7,:) = [length(find(L_S(wstar,psi)<0.6 & L_S(wstar,psi)>0.35))./length(L_S(wstar,psi)) , 0.36886]*10
            %Proportion of households that provide less than 0.1
                mom(8,:) = [length(find(L_S(wstar,psi)<0.1))./length(L_S(wstar,psi)) , 0.00182]*1000
            %Mean amount of labor supplied
                mom(9,:) = [mean(L_S(wstar,psi)) , 0.354476840480539]*10

                error = sum((mom(:,1)-mom(:,2)).^2)
end
                    
                    
                    
           
                   
                   
                   
         
