%This .m file writes out a simple neural network with one hidden layer and
%five nodes, and minimizes it with a genetic algorithm (not stochastic
%gradient descent). For teaching purposes.

clear

%True underlying data/function
    x_true = sort(4*rand(1000,1));
    y_true = sin(10*x_true).*(x_true<2)+(3*(x_true-2).^2).*(x_true>2);

%Logit function
g = @(x) 1./(1+exp(-x));
%One-layer network:
    %Input (one dimensional)
    %Hidden layer (5 logits) (5 biases, 5 parameters)
    init_alpha_1 = rand(5,1);
    init_beta_1 = rand(5,1);
    %Output layer (1 scaling layer) (one bias, and one scaling for each of the five outputs)
    init_alpha_2 = rand;
    init_beta_2 = rand(5,1);

    %Hidden layer is five stacked logits, each with their own parameters
    f_hidden = @(alpha_1,beta_1,x0) [g(alpha_1(1)+beta_1(1).*x0);
                    g(alpha_1(2)+beta_1(2).*x0);
                    g(alpha_1(3)+beta_1(3).*x0);
                    g(alpha_1(4)+beta_1(4).*x0);
                    g(alpha_1(5)+beta_1(5).*x0)];
    f_out = @(alpha_2,beta_2,x1) alpha_2+x1'*beta_2;

    %So full function is second layer with first layer as inputs, which
    %itself has actual x as an input (fout(flayer(xinput))
    f = @(alpha_1,beta_1,alpha_2,beta_2,x0) f_out(alpha_2,beta_2,f_hidden(alpha_1,beta_1,x0))

    %Single call
    f(init_alpha_1,init_beta_1,init_alpha_2,init_beta_2,3)

    %Poorly written, arrayfun to rescue!
    arrayfun(@(x)f(init_alpha_1,init_beta_1,init_alpha_2,init_beta_2,x),[3;4])

    %Write a function we want to zero
    f_full = @(parm) arrayfun(@(x)f(parm(1:5),parm(6:10),parm(11),parm(12:16),x),x_true)-y_true
    f_full([init_alpha_1;init_beta_1;init_alpha_2;init_beta_2])


    parm=lsqnonlin(f_full,zeros(16,1),[],[],optimset('Display','iter','MaxIter',1e7,'MaxFunEval',1e7,'TolX',1e-6,'TolFun',1e-6))
    
    plot(x_true,arrayfun(@(x)f(parm(1:5),parm(6:10),parm(11),parm(12:16),x),x_true))
    hold on
    plot(x_true,y_true)