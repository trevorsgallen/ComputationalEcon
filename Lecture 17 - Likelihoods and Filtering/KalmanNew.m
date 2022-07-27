clear
close all
rng(1)

%Set "true" parameters
    phi = 1;
    psi = 0.1;

    sig2_epsilon_true = 1;
    sig2_xi_true = 1;
    sig2_zeta_true = 1;

%Calibrate Kalman Filter (this assumes a good estimation)
    H = [phi 1];
    F = [1];
    PHI = [1]
    SIGMA = [(psi.^2).*sig2_epsilon_true+sig2_xi_true ,  psi ; psi sig2_epsilon_true]

T = 50;
%% Simulate the "True" data
    zeta_true = sqrt(sig2_zeta_true)*randn(T,1);
    epsilon_true = sqrt(sig2_epsilon_true)*randn(T,1);
    xi_true = sqrt(sig2_xi_true)*randn(T,1);
    z_true(1) = 0+zeta_true(1)
    
    for t = 1:T
        if t ~= 1
            z_true(t) = z_true(t-1)+zeta_true(t);
        end
        c_true(t) = phi*z_true(t) + psi*epsilon_true(t) + xi_true(t);
        y_true(t) =  z_true(t) + epsilon_true(t);
    end
    figure(1)
    plot(c_true)
    hold on
    plot(y_true)
    hold on
    plot(zeta_true)
    hold on
    plot(xi_true)
    hold on
    plot(epsilon_true)
    legend('C, consumption','Y, income','\zeta, permanent income shock','\xi, temporary consumption shock','\epsilon, temporary income shock','Location','best')
    title('Simulated Economy')
    xlabel('Period')
    ylabel('Levels')
%   print('~/Dropbox/Women/PermInc/SimulatedData.png','-dpng')

    
%% Estimate the parameters
    dy_true = y_true(2:end)-y_true(1:end-1);
    dc_true = c_true(2:end)-c_true(1:end-1);

%Var zeta
   temp1=cov(dy_true(2:end-1),dy_true(1:end-2)+dy_true(2:end-1)+dy_true(3:end),1);
   sig2_zeta_est = temp1(1,2);
   
%Var epsilon
   temp1=cov(dy_true(2:end-1),dy_true(3:end),1);
   sig2_epsilon_est = -temp1(1,2);

%Psi, Phi, and var xi
   temp1=cov(dc_true(2:end-1),dc_true(1:end-2),1);
   temp1 = temp1(1,2);
   
   temp2=mean(dc_true(2:end-1).*dy_true(2:end-1))
   
   temp3=cov(dc_true(2:end-1),dy_true(1:end-2)+dy_true(2:end-1)+dy_true(3:end),1);
   temp3 = temp3(1,2);

    %These are jointly estimated, so need minimizer
       f = @(psi_est,phi_est,sig2_xi_est) ... 
           [(temp1 - (-(psi_est.^2).*sig2_epsilon_est - (sig2_xi_est)));
           (temp2 -  (phi_est*sig2_zeta_est+2*psi*sig2_epsilon_est));
           (temp3 - (phi_est*sig2_zeta_est))]
       f_temp = @(x) f(x(1),x(2),x(3));
   
   temp = fsolve(f_temp,[psi,phi,sig2_xi_true]);
   psi_est = temp(1);
   phi_est = temp(2);
   sig2_xi_est = temp(3);
       
   
   %Compare parameters to truth
       [sig2_zeta_est , sig2_zeta_true ; 
        sig2_epsilon_est , sig2_epsilon_true ;
        phi_est , phi ; 
        psi_est , psi ;
        sig2_xi_est , sig2_xi_true]


%% Kalman Filter 
    %When I Kalman Filter, I'll use the true parameters, rather than the
    %estimated parameters.
    
%Start out at the truth
    xi_t_tm1 = [z_true(1)];
    Omega_t_tm1 = 1;

    for t = 1:T
    %Forecast
        Yhat = (H*xi_t_tm1)';
         S_yy_t = H*Omega_t_tm1*H'+SIGMA;
         
         
     %Update
        S_xiY_t = Omega_t_tm1*H';
        xi_t_t = xi_t_tm1+S_xiY_t'*inv(S_yy_t)*([y_true(t);c_true(t)]-Yhat);
        Omega_t_t = Omega_t_tm1 - (S_xiY_t')*inv(S_yy_t)*S_xiY_t;
    %Forecast
        xi_tp1_t = F*xi_t_t;
        Omega_tp1_t = F*Omega_t_t*F'+PHI;
        
        xi_t_tm1 = xi_tp1_t;
        Omega_t_tm1 = Omega_tp1_t;
        
        xi_t_t_sto(:,t) = xi_t_t;
        Omega_t_t_sto(:,:,t) = Omega_t_t;
        Omega_tp1_t_sto(:,:,t) = Omega_tp1_t;
        xi_tp1_t_sto(:,t) = xi_tp1_t;
    end
    
%% Kalman Smoother
    %Kalman Smoother
    
        xi_tp1_T = xi_tp1_t;
        for t = T:-1:1
            J = Omega_t_t_sto(:,:,t)*F'*inv(Omega_tp1_t_sto(:,:,t));
            xi_t_T = xi_t_t_sto(:,t) + J*(xi_tp1_T-xi_tp1_t_sto(:,t));
            xi_t_T_sto(:,t) = xi_t_T;
            xi_tp1_T = xi_t_T;
        end
        
        figure(11)
        plot(z_true(2:T)-z_true(1:T-1),'-k')
        hold on
        plot(xi_t_T_sto(2:T)-xi_t_T_sto(1:T-1),'--g')
        hold on
        plot(xi_t_t_sto(2:T)-xi_t_t_sto(1:T-1),'--r')

        [var(z_true(2:T)-z_true(1:T-1));
            var(xi_t_T_sto(2:T)-xi_t_T_sto(1:T-1));
            var(xi_t_t_sto(2:T)-xi_t_t_sto(1:T-1))]

%% 
        %Compare the smoother and the regular filter
        X= [ones(T,1),(xi_t_t_sto-z_true)']
        Y=[xi_t_T_sto-z_true]'
        betatemp = inv(X'*X)*X'*Y
        fit = X*betatemp;
        
            figure(1001)
            scatter(xi_t_t_sto-z_true,xi_t_T_sto-z_true)
            hold on
            plot(xi_t_t_sto-z_true,xi_t_t_sto-z_true,'-k')
            hold on
            plot(xi_t_t_sto-z_true,fit)
            xlabel('Error: First Stage')
            ylabel('Error: Second Stage')



%Now extract out the shocks
    
    z_sim = xi_t_t_sto;
    zeta_sim = [z_sim(1),z_sim(2:end)-z_sim(1:end-1)]
    epsilon_sim = y_true-z_sim
    xi_sim = c_true-phi*z_sim-psi*epsilon_sim;
    
    
    figure(1)
    subplot(2,2,1)
    plot(z_sim(1:T),'--r')
    hold on
    plot(z_true(1:T),'-k')
    legend('Expectation','Truth','Location','Best')
    title('Lifetime Income')
    xlabel('Period')
    ylabel('Level')
    subplot(2,2,2)
    plot(zeta_sim(1:T),'--r')
    hold on
    plot(zeta_true(1:T),'-k')
    title('Permanent Shock')
    xlabel('Period')
    ylabel('Level')
    subplot(2,2,3)
    plot(epsilon_sim(1:T),'--r')
    hold on
    plot(epsilon_true(1:T),'-k')
    xlabel('Period')
    title('Temporary Shock')
    ylabel('Level')
    subplot(2,2,4)
    plot(xi_sim(1:T),'--r')
    hold on
    plot(xi_true(1:T),'-k')
    xlabel('Period')
    title('Consumption Shock')
    ylabel('Level')
    asdf
  % print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/KalmanFilter.png','-dpng')

    %Get regression line
    X=[ones(length(zeta_sim),1),zeta_sim']
    temp=X*((inv(X'*X)*X')*zeta_true)
    r2 = var(temp-zeta_true)./var(zeta_true)
    
    figure(2)
    scatter(zeta_sim,zeta_true)
    hold on
    plot(zeta_sim,zeta_sim,'--r')
    hold on
    plot(zeta_sim,temp,'--g')
    xlim([floor(min(zeta_sim-0.5)),-floor(min(zeta_sim-0.5))])
    title('Estimated vs. True Permanent Shock')
    xlabel('Estimated Permanent Shock')
    ylabel('True Permanent Shock')
    legend('Data','45 degree line','Best Fit Line','Location','Best')
   %print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/PermShocks.png','-dpng')

    
    figure(3)
    plot(z_sim(1:T),'-r')
    hold on
    plot(z_sim(1:T)-1.96*sqrt(squeeze(Omega_t_t_sto))','--r')
    plot(z_sim(1:T)+1.96*sqrt(squeeze(Omega_t_t_sto))','--r')
    hold on
    plot(z_true(1:T),'-k')
    title('Permanent Income and Standard Errors')
    xlabel('Period')
    ylabel('Value')
   %print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/KalmanFilter2.png','-dpng')


    
    