%This .m file writes out a simple neural network with one hidden layer and
%five nodes, and minimizes it with a genetic algorithm (not stochastic
%gradient descent). For teaching purposes.

resnorm_sto = []
parm_sto = zeros(15,3*15+1);
for N = 15:-1:1
clearvars -except N resnorm_sto parm_sto

%True underlying function
    rng(1)
    x_true = sort(4*rand(1000,1));
    y_true = sin(10*x_true).*(x_true<2)+(3*(x_true-2).^2).*(x_true>2);
    g = @(x) 1./(1+exp(-x));

%     N = 8;
%One-layer network:
    %Input (one dimensional)
    %Hidden layer (N logits) (N biases, N parameters)
    %init_alpha_1 = rand(N,1);
    %init_beta_1 = rand(N,1);
    %Output layer (1 scaling layer) (one bias, and one scaling for each of the five outputs)
    %init_alpha_2 = rand;
    %init_beta_2 = rand(N,1);

    %Hidden layer is N stacked logits, each with their own parameters
    f_hidden = @(alpha_1,beta_1,x0) g([ones(length(x0),1),x0]*[alpha_1,beta_1]');
    f_out = @(alpha_2,beta_2,x1) alpha_2+x1*beta_2;

    %So full function is:
    f = @(alpha_1,beta_1,alpha_2,beta_2,x0) f_out(alpha_2,beta_2,f_hidden(alpha_1,beta_1,x0));

    f_full = @(theta)y_true-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true);


    %Multistart
%     problem = createOptimProblem('lsqnonlin','x0',zeros(1,3*N+1),'objective',@(theta)y_true-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true),'lb',-10000*ones(length(3*N+1),1),'ub',10000*ones(length(3*N+1),1));
%     ms = MultiStart('PlotFcns',@gsplotbestf);
%     [parm_ms,errormulti] = run(ms,problem,10000)

%     [parm_ps,resnorm]=patternsearch(@(theta) sum((y_true-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true)).^2),zeros(1,3*N+1),[],[],[],[],-3000*ones(length(3*N+1),1),3000*ones(length(3*N+1),1),psoptimset('Display','iter'));
% 
%     [parm_sa,resnorm]=simulannealbnd(@(theta) sum((y_true-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true)).^2),zeros(1,3*N+1),-3000*ones(length(3*N+1),1),3000*ones(length(3*N+1),1),optimset('Display','iter'));
% 
%     %Once more for good measure
%     [parm,resnorm]=ga(@(theta) sum((y_true-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true)).^2),3*N+1,[],[],[],[],-3000*ones(length(3*N+1),1),3000*ones(length(3*N+1),1),[],[],gaoptimset('Display','iter','InitialPopulation',[parm_ps;parm_ms;parm_sa],'PopulationSize',100000));
% 
%     %Once more for good measure
    [parm,resnorm]=lsqnonlin(@(theta) y_true-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true),zeros(1,3*N+1),-3000*ones(length(3*N+1),1),3000*ones(length(3*N+1),1),optimset('Display','iter','MaxIter',1e7,'MaxFunEval',1e7));


    resnorm_sto(end+1,:)=[N,resnorm]
    parm_sto(end+1,1:N) = parm(1:N);
    parm_sto(end+1,16:16+N-1) = parm(N+1:2*N);
    parm_sto(end+1,31) = parm(2*N+1);
    parm_sto(end+1,32:32+N-1) = parm(2*N+2:end);

    close all
    plot(x_true,y_true,'-xr')
    hold on
    plot(x_true,f(reshape(parm(1:N),[],1),reshape(parm(N+1:2*N),[],1),parm(2*N+1),reshape(parm(2*N+2:end),[],1),x_true),'-k')
    legend('Data','Fit')
    saveas(gcf,['Fig_Shallow_',num2str(N),'.png'])
    save(['Shallow_',num2str(N),'.mat'])
end
