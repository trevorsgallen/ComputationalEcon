clear
close all
%Loop over betas
betacounter = 0;
for beta = [0.96,1/(1+0.05)]
    betacounter = betacounter+1;
    %Section 1: Define parameters
        T = 45;
        epsilon = 0.75;
        psi = 10;
%         beta = 1/(1+0.05);
    %      beta = 0.96;
        
        %Wages
        w_vec = ones(T,1);
        w_vec(30) = 1.1;
    
        %Interest Rates
        r_vec = ones(T,1)*0.05;
        r_vec(1) = 0;
        r_vec(20) = 0.1;
    
        %Cumulative r
            cumulativer = cumprod(1+r_vec)
    
    %Section 2: Functions & Maximization
        %Utility function
            ut = @(c,L) log(c)-psi.*(epsilon./(1+epsilon)).*L.^((1+epsilon)./epsilon);
        %Lifetime budget constraint
            bc_lifetime = @(c,L) sum(c./cumulativer)-sum(w_vec.*L./cumulativer);
        %Lifetime utility, penalized
            ut_lifetime = @(c,L) sum((beta.^[0:T-1])'.*ut(c,L))-((bc_lifetime(c,L)>0).*bc_lifetime(c,L))
        %Maximization 
            %Initial Guess
            Lguess=[0.5]*ones(T,1);
            cguess=0.5*ones(T,1);
    
            %If already have a ballpark guess, start at it
            if betacounter == 2
                Lguess = L_sto(1,:)';
                cguess = c_sto(1,:)';
            end

        %Budget constraint
            A = [1./cumulativer;-w_vec./cumulativer]';
            B = 0;

            %Constrained Utility maximization (NPV b.c holds with equality)
           [sol,temp]=fmincon(@(x)-sum(beta.^[0:T-1]'.*ut(x(1:T),x(T+1:end))),[cguess;Lguess],[],[],A,B)

           %Unconstrained Utility maximization (by hand)
%            [sol,temp]=fminunc(@(x)-ut_lifetime(x(1:T),x(T+1:end)),[cguess;Lguess])
            
            c_sol = sol(1:T);
            L_sol = sol(T+1:end);
            NPVs_sol = [0;cumsum(c_sol./cumulativer)-cumsum(w_vec.*L_sol./cumulativer)];
            
            %Store because I'm looping over beta
                c_sto(betacounter,:) = c_sol;
                L_sto(betacounter,:) = L_sol;
                s_sto(betacounter,:) = NPVs_sol;

end
            %Figures
            figure(1)
            subplot(2,2,1)
            plot(c_sto(1,:),'-k')
            hold on
            plot(c_sto(2,:),'-r')
            hold on
            title('Consumption')
            legend('\beta=0.96',['\beta=',num2str(beta,3)],'Location','best')
            subplot(2,2,2)
            plot(L_sto(1,:),'-k')
            hold on
            plot(L_sto(2,:),'-r')
            hold on
            title('Labor')
            subplot(2,2,3)
            plot(s_sto(1,:),'-k')
            hold on
            plot(s_sto(2,:),'-r')
            hold on
            title('Present Value Savings')
            
            saveas(gcf,'Figure1.png')
    

%Learning by doing: wages are a function of past labor and decrease with
%age
    r_vec = ones(T,1)*0.05;
    %Cumulative r
        cumulativer = cumprod(1+r_vec)
    %Utility function
        ut = @(c,L) log(c)-psi.*(epsilon./(1+epsilon)).*L.^((1+epsilon)./epsilon);
    %Lifetime budget constraint
        bc_lifetime = @(c,L) sum(c./cumulativer)-sum((1+cumsum(L)/10-([1:45]'/45).^2).*L./cumulativer);
    %Lifetime utility, penalized
        ut_lifetime = @(c,L) sum((beta.^[1:T])'.*ut(c,L))-((bc_lifetime(c,L)>0).*bc_lifetime(c,L))
    
        %Utility maximization
        [sol,temp]=fminunc(@(x)-ut_lifetime(x(1:T),x(T+1:end)),[cguess;Lguess])
        c_sol = sol(1:T);
        L_sol = sol(T+1:end);

        %Figures
        figure(2)
        subplot(2,2,1)
        plot(c_sol)
        hold on
        title('Consumption')
        subplot(2,2,2)
        plot(L_sol)
        hold on
        title('Labor')
        subplot(2,2,3)
        plot(1+cumsum(L_sol)/10-([1:45]'./45).^2)
        hold on
        title('Wages')
            saveas(gcf,'Figure2.png')




