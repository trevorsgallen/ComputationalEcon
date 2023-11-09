clear

%Parameterization
    beta = 0.95;
    A = 1;
    delta = 0.05;
    gamma =0.5;
    r = 1/beta-1;
    rho = 0.95;
    sigma = 0.01;

%Human capital space
    A_lb = -0.15;
    A_ub = 0.15;
    h_space = linspace(5,10,5);
    A_space = linspace(A_lb,A_ub,6);
    w_space = linspace(0,2,7);

    [h_grid,A_grid,w_grid]=ndgrid(h_space,A_space,w_space);

%Initialize value function and policy
    V_0 = zeros(size(A_grid));

    i_policy = 0.30*ones(size(h_grid));
    s_policy = 0.47*ones(size(h_grid));

error = Inf;
counter = 0;
tic

no_howard = 0;
while error > 1e-7 & toc < 600
    counter = counter+1;
    rng(1,'twister')
    for h_ind = 1:length(h_space)
        for A_ind = 1:length(A_space)
            for w_ind = 1:length(w_space)
                %Look up value for h and A
                h = h_space(h_ind);
                A = A_space(A_ind);
                w = w_space(w_ind);
        
                %To make it readable as a value function, define recognizable aux functio
                %Note I changed the form of s to be fraction of gross
                %income, which bounds it between 0 and 1, rather than
                %having feasible bounds as a function of w. Useful!
                c = @(i,s) (1-s)*((1+r)*w+h*(1-i));
                hnext = @(i) max(min((1-delta)*h+exp(A)*(i.^gamma),max(h_space)),min(h_space));
                Anext = @(eps) max(min(rho*A+eps,A_ub),A_lb);
                wnext = @(i,s) max(min(s.*((1+r).*w+h.*(1-i)),max(w_space)),min(w_space));

                %Define utility, plugging in constraints
                ut = @(i,s) log(c(i,s))+beta*integral(@(eps) normpdf(eps,0,0.01).*interpn(h_grid,A_grid,w_grid,V_0,hnext(i),Anext(eps),wnext(i,s),'makima'),-3*sigma,+3*sigma);
        
                %Kinda fun way to implement Howard's Improvement Algorithm
                if mod(counter,30)==1 | no_howard==1
                    [temp1,temp2]=patternsearch(@(x)-ut(x(1),x(2)),[0.1,0.1],[],[],[],[],[0.001,0.001],[0.999,0.999],[],psoptimset('Display','off'));
                else
                    temp1(1)=i_policy(h_ind,A_ind,w_ind);
                    temp1(2)=s_policy(h_ind,A_ind,w_ind);
                    temp2 = -ut(i_policy(h_ind,A_ind,w_ind),s_policy(h_ind,A_ind,w_ind));
                end
                V_1(h_ind,A_ind,w_ind) = -temp2;
                i_policy(h_ind,A_ind,w_ind) = temp1(1);
                s_policy(h_ind,A_ind,w_ind) = temp1(2);
                c_policy(h_ind,A_ind,w_ind) = c(temp1(1),temp1(2));
                w_policy(h_ind,A_ind,w_ind) =wnext(temp1(1),temp1(2));

            end
        end
    end


    error = max(reshape(abs(V_1-V_0),[],1))
    V_0 = V_1;

    figure(1)
    if (mod(counter,30) == 1 & no_howard == 0)
        scatter(toc,log(error),'k','x')
    elseif no_howard==1
        scatter(toc,log(error),'red','o')
    end
    drawnow
    hold all
    exportgraphics(gcf,'Fig1.png')
end
toc
ftyu
%Plot the policy functions
    [Anew_grid,wnew_grid]=ndgrid(A_space,w_space);
    figure(2)
    surf(Anew_grid',wnew_grid',interpn(h_grid,A_grid,w_grid,i_policy,8.46*ones(size(Anew_grid)),Anew_grid,wnew_grid,'makima')')
    xlabel('A')
    ylabel('W')
    zlabel('i^*')
    title('i policy')
    exportgraphics(gcf,'Fig2.png')

    figure(3)
    surf(Anew_grid',wnew_grid',interpn(h_grid,A_grid,w_grid,s_policy,8.46*ones(size(Anew_grid)),Anew_grid,wnew_grid,'makima')')
    xlabel('A')
    ylabel('W')
    zlabel('s^*')
    title('s policy')
    exportgraphics(gcf,'Fig3.png')

    figure(4)
    surf(Anew_grid',wnew_grid',interpn(h_grid,A_grid,w_grid,V_0,8.46*ones(size(Anew_grid)),Anew_grid,wnew_grid,'makima')')
    xlabel('A')
    ylabel('W')
    zlabel('V')
    title('Value Function')
    exportgraphics(gcf,'Fig4.png')

%Simulate
    rng(1)
    N = 100;
    h_sim = random('uniform',1,15,N,1);
    A_sim = random('uniform',-0.07,0.07,N,1);
    w_sim = random('uniform',0,max(w_space),N,1)
    i_sim = zeros(N,1);
    s_sim = zeros(N,1);
    c_sim = zeros(N,1);


    for t = 1:10000
        i_sim(:,t)=interpn(h_space,A_space,w_space,i_policy,h_sim(:,t),A_sim(:,t),w_sim(:,t));
        s_sim(:,t)=interpn(h_space,A_space,w_space,s_policy,h_sim(:,t),A_sim(:,t),w_sim(:,t));
        c_sim(:,t)=(1-s_sim(:,t)).*((1+r)*w_sim(:,t)+h_sim(:,t).*(1-i_sim(:,t)));
        A_sim(:,t+1)=max(min(rho.*A_sim(:,t)+sigma*randn(N,1),A_ub),A_lb);
        h_sim(:,t+1)=max(min((1-delta).*h_sim(:,t)+exp(A_sim(:,t)).*(i_sim(:,t).^gamma),max(h_space)),min(h_space));
        w_sim(:,t+1)=max(min(s_sim(:,t).*((1+r).*w_sim(:,t)+h_sim(:,t).*(1-i_sim(:,t))),max(w_space)),min(w_space));
    end

    figure(5)
    ksdensity(reshape(w_sim(:,2000:end),[],1))
    xlabel('Wealth')
    ylabel('Frequency')
    exportgraphics(gcf,'Fig5.png')
