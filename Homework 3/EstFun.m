function [err,out] = EstFun(theta)
    tic
    global sto 
    if isempty(sto)==1 
        sto = [-99,-99,-99,-99,-99];
    end

    ind = find(theta(1)==sto(:,1) & theta(2)==sto(:,2));
    if isempty(ind)== 0
        err = sto(ind(1),3)';
        out = sto(ind(1),:);
    end
    if isempty(ind)==1 
    %Set seed
        rng(1)
    
    %Calibration
        T = 45;
        sbar = -0.2;
        sig_zeta = sqrt(0.02);
        sig_epsilon = sqrt(0.04);
        r = 0.05;
        beta = theta(1);
    
    %State vectors
        T_min = 1;
        T_max = 46;
        T_vec = [T_min:T_max];
        T_num = length(T_vec);
    
        P_min = 1.01;
        P_max = 10;
        P_num = 10;
        P_vec = linspace(P_min,P_max,P_num);
        
        epsilon_min = -5*sig_epsilon;
        epsilon_max = 5*sig_epsilon;
        epsilon_num = 4;
        epsilon_vec = linspace(epsilon_min,epsilon_max,epsilon_num);
    
        s_min = sbar;
        s_max = 20;
        s_num = 10;
        s_vec = linspace(s_min,s_max,s_num);
    
    %Create the grid of states
        [T_grid,P_grid,epsilon_grid,s_grid]=ndgrid(T_vec,P_vec,epsilon_vec,s_vec);
        V = zeros(size(T_grid));
        s_policy = zeros(size(T_grid));
    
    %I'm also going to make a grid to integrate over (epsilon and zeta)
        izeta_min = -5*sig_zeta;
        izeta_max = 5*sig_zeta;
        izeta_num = 20;
        izeta_vec = linspace(izeta_min,izeta_max,izeta_num);
    
        iepsilon_min = -5*sig_epsilon;
        iepsilon_max = 5*sig_epsilon;
        iepsilon_num = 20;
        iepsilon_vec = linspace(iepsilon_min,iepsilon_max,iepsilon_num);
    
    %Create integration grids for trapezoid rule (primitive, but simple, fast,
    %and accurate for this problem.
        [izeta_grid,iepsilon_grid]=meshgrid(izeta_vec,iepsilon_vec);
        prob = reshape(mvnpdf([reshape(izeta_grid,[],1),reshape(iepsilon_grid,[],1)],[0,0],[sig_zeta.^2,0;0,sig_epsilon.^2]),size(izeta_grid));
    
            %Make sure we double integrate to one
               trapz(iepsilon_vec,trapz(izeta_vec,prob,2));
    
    
    %Now loop
    counter = 0;
    for t = T_max-1:-1:T_min
        for P_ind = 1:P_num
            %Display where we are in loop
            for epsilon_ind = 1:epsilon_num
                for s_ind = 1:s_num
    
                    %Loop up epsilon, P, s
                    epsilon = epsilon_vec(epsilon_ind);
                    P = P_vec(P_ind);
                    s = s_vec(s_ind);
                     
                    %Define value function and expectation of value function
                    V_fxn = griddedInterpolant(squeeze(P_grid(t+1,:,:,:)),squeeze(epsilon_grid(t+1,:,:,:)),squeeze(s_grid(t+1,:,:,:)),squeeze(V(t+1,:,:,:)),'makima');
                    EV_fxn = @(s) trapz(iepsilon_vec,trapz(izeta_vec,prob.*V_fxn(min(max(P+izeta_grid,P_min),P_max),iepsilon_grid,repmat(s,size(izeta_grid))),2));
    
                    %Define INcome
                    Y = P+epsilon;
    
                    %If in last period, deterministic
                    if t == T_max-1
                        temp1 = 0;
                        temp2 = -sqrt(max(Y+(1+r)*s-1,0.0001));
                    end
                    if t < T_max-1
                        %If in impossible position, give them low consumption
                        if Y+(1+r)*s-s_min < 1
                            temp1 = s_min;
                            temp2 = -sqrt(max(Y+(1+r)*s-1,0.0001))+beta*EV_fxn(s_min);
                        end
                        %Otherwise, solve the problem
                        if Y+(1+r)*s-s_min > 1
                            s_init = s_policy(t+1,P_ind,epsilon_ind,s_ind);
                            s_pd_max = max(Y+(1+r)*s-1-0.01,s_min);
                            ut = @(sp) -( sqrt(Y+(1+r)*s-sp-1)+beta*EV_fxn(sp));
                            foptions = optimset('Display','off');
                            [temp1,temp2]=fmincon(ut ,[s_init],[],[],[],[],[s_min],[s_pd_max],[],foptions);
                        end
                        
                    end
    
                    %Save policy & value functions
                    s_policy(t,P_ind,epsilon_ind,s_ind) = temp1;
                    V(t,P_ind,epsilon_ind,s_ind)=-temp2;
    
    
                end
            end
        end
    
    end
    
    clear N P s epsilon_shock zeta_shock Y c
    %Great, now simulate N individuals, draw shocks before simulation
        rng(1)
        N = 1000000;
        s = max(min(sqrt(theta(2))*randn(N,1),s_max),s_min);
        epsilon_shock = max(min(sig_epsilon.*randn(N,45),epsilon_max),epsilon_min);
        zeta_shock = sig_zeta.*randn(N,46);
        P = max(min(5*ones(N,1)+zeta_shock(:,t),P_max),P_min);
    
    %Loop over time periods (I solve all individuals at once, in vector, so
    %don't loop over individuals
        for t = 1:45
            tmat(:,t)=t*ones(N,1);
            P(:,t+1)=max(min(P(:,t)+zeta_shock(:,t+1),P_max),P_min);
            Y(:,t) = P(:,t)+epsilon_shock(:,t);
            s(:,t+1)=max(min(interpn(T_grid,P_grid,epsilon_grid,s_grid,s_policy,t*ones(N,1),P(:,t),epsilon_shock(:,t),s(:,t),'linear',0),s_max),s_min);
            c(:,t) = Y(:,t)+(1+r)*s(:,t)-s(:,t+1);
        end
    
    %Store log inc, cons, take diff
        lny = Y;
        lnc = c;
    
        dc = lnc(:,2:end)-lnc(:,1:end-1);
        dy = lny(:,2:end)-lny(:,1:end-1);
    
    %Create square grid so I don't have to care about missing values
        dy_t = dy(:,2:end-1);
        dy_tm1 = dy(:,1:end-2);
        dy_tp1 = dy(:,3:end);
        dc_t = dc(:,2:end-1);
        dc_tm1 = dc(:,1:end-2);
        dc_tp1 = dc(:,3:end);
    
    %Covariances
        covfxn = @(x,y) mean((reshape(x,[],1)-mean(reshape(x,[],1))).*(reshape(y,[],1)-mean(reshape(y,[],1))));
    
        sigxi_hat = covfxn(dc_t,dc_tm1+dc_t+dc_tp1);
        sigzeta_hat = covfxn(dy_t,dy_tm1+dy_t+dy_tp1);
        sigepsilon_hat = -covfxn(dy_t,dy_tp1);
        phihat = covfxn(dc_t,dy_tm1+dy_t+dy_tp1)./covfxn(dy_t,dy_tm1+dy_t+dy_tp1);
        psihat = covfxn(dc_t,dy_tp1)./covfxn(dy_t,dy_tp1);
    
    %Table of results
        table([[0.01;0.02;0.04;0.64;0.05],[sigxi_hat;sigzeta_hat;sigepsilon_hat;phihat;psihat],[0;sig_zeta.^2;sig_epsilon.^2;NaN;NaN]]);
    
    %Plot of results
        % subplot(2,2,1)
        % plot(P')
        % title('Permanent Income')
        % subplot(2,2,2)
        % plot(c')
        % title('Consumption')
        % subplot(2,2,3)
        % plot(s')
        % title('Savings')
        % subplot(2,2,4)
        % plot(var(P))
        % hold on
        % plot(var(c))
        % plot(var(s))
        % legend('Y','C','s')
        % title('Variance by Age')
        
        %This is pretty important, what we do here!
         sim_mom(1,1) = mean(lnc(tmat==30)./lnc(tmat==29),'omitnan');
         sim_mom(2,1) = var(s(tmat==3),'omitnan');
    
         err(1,1) = sim_mom(1,1)-1.001788;
         err(2,1) = sim_mom(2,1)-0.00409;
    
        [theta,err(1,1),err(2,1),toc/60]
    
         errsum = 1000*sum(abs(err).^2);
    
         format short g
        out = [reshape(theta,1,[]),errsum,err(1,1),err(2,1)]
        sto(end+1,:)=out;
    
        err = errsum;
%         err = sum(err);
%          err = errsum;
%          'toc'
%     toc
    end
end


