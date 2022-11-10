%This .m file writes out a "deep" (two-layer) neural network with one hidden layer and
%five nodes, and minimizes it with a genetic algorithm (not stochastic
%gradient descent). For teaching purposes.

clear

%True underlying function
    x_true = sort(4*rand(1000,1));
    y_true = sin(10*x_true).*(x_true<2)+(3*(x_true-2).^2).*(x_true>2);

    N = [20,10];
%One-layer network:
    %Input (one dimensional)
    %Hidden layer (10 logits) (10 biases, 10 parameters)
    init_alpha_1 = rand(N(1),1);
    init_beta_1 = rand(N(1),1);

    init_alpha_2 = rand(1,N(2));
    init_beta_2 = rand(N(1),N(2));

    init_alpha_3 = rand;
    init_beta_3 = rand(N(2),1);

    %First hidden layer takes in one input (num obs times) and spits out 10
    %different logit results.  Note always have to add a layer of ones for
    %the bias parameter.
    g = @(x) 1./(1+exp(-x));
    f_hidden_1 = @(alpha_1,beta_1,x0) g([ones(length(x0),1),x0]*[alpha_1,beta_1]')
    %10 different logits are subjected to a relu layer (irrelevant here)
    relu = @(x) x.*(x>0);
    %10 different logits are then fed as inputs to 5 logit layers 
    f_hidden_2 = @(alpha,beta,x1) g([ones(size(x1,1),1),x1]*[init_alpha_2;init_beta_2])
    %Those 5 logit results (again, num obs times) are then fed to the final
    %"scaling" layer
    f_out = @(alpha_3,beta_3,x2) alpha_3+x2*beta_3;

    %So full function is:
    f = @(alpha_1,beta_1,alpha_2,beta_2,alpha_3,beta_3,x0) f_out(alpha_3,beta_3,f_hidden_2(alpha_2,beta_2,relu(f_hidden_1(alpha_1,beta_1,x_true))))


% %     %Minimize with Nelder-Mead
%     initparm = zeros(3*N+1,1);
%     parm_nm=fminsearch(@(theta) sum((y_true(x_true<3)-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true(x_true<3))).^2),initparm,optimset('Display','iter','MaxIter',1000))
% 
%     %Minimize with patternsearch
%     initparm = parm_nm;
%     parm_ps=patternsearch(@(theta) sum((y_true(x_true<3)-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true(x_true<3))).^2),initparm,[],[],[],[],[],[],psoptimset('Display','iter','MaxFunEvals',10000,'SearchMethod',@MADSPositiveBasis2N,'PollMethod','MADSPositiveBasis2N'))
% 
%     %Minimize with fminunc
%     initparm = parm_ps
%     parm_fmin=fminunc(@(theta) sum((y_true-f(reshape(theta(1:N),[],1),reshape(theta(N+1:2*N),[],1),theta(2*N+1),reshape(theta(2*N+2:end),[],1),x_true)).^2),initparm,optimset('Display','iter','MaxFunEval',1e7,'MaxIter',1e7))

    %Minimize with genetic algorithm
%     initparm = parm_fmin;
    parmbreaks = [1,N(1)]
    parmbreaks(end+1,:) = [parmbreaks(end,2)+1,parmbreaks(end,2)+N(1)]
    parmbreaks(end+1,:) = [parmbreaks(end,2)+1,parmbreaks(end,2)+N(2)]
    parmbreaks(end+1,:) = [parmbreaks(end,2)+1,parmbreaks(end,2)+N(1)*N(2)]
    parmbreaks(end+1,:) = [parmbreaks(end,2)+1,parmbreaks(end,2)+1]
    parmbreaks(end+1,:) = [parmbreaks(end,2)+1,parmbreaks(end,2)+N(2)]

                
    parm_fmin=lsqnonlin(@(theta) y_true-f(reshape(theta(parmbreaks(1,1):parmbreaks(1,2)),[],1),reshape(theta(parmbreaks(2,1):parmbreaks(2,2)),[],1),reshape(theta(parmbreaks(3,1):parmbreaks(3,2)),1,[]),reshape(theta(parmbreaks(4,1):parmbreaks(4,2)),N(1),N(2)),reshape(theta(parmbreaks(5,1):parmbreaks(5,2)),[],1),reshape(theta(parmbreaks(6,1):parmbreaks(6,2)),[],1),x_true),randn(1,parmbreaks(end,end)),[],[],optimset('Display','iter','MaxIter',1e7,'MaxFunEval',1e7));


    f_full = @(x,theta) f(reshape(theta(parmbreaks(1,1):parmbreaks(1,2)),[],1),reshape(theta(parmbreaks(2,1):parmbreaks(2,2)),[],1),reshape(theta(parmbreaks(3,1):parmbreaks(3,2)),1,[]),reshape(theta(parmbreaks(4,1):parmbreaks(4,2)),N(1),N(2)),reshape(theta(parmbreaks(5,1):parmbreaks(5,2)),[],1),reshape(theta(parmbreaks(6,1):parmbreaks(6,2)),[],1),x);

    plot(x_true,f_full(x_true,parm_fmin),'-xk')
    hold on
    scatter(x_true,y_true)
    saveas(gcf,['Deep_7_7.png'])
