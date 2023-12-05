clear
rng(1,'twister')
%First, solve a grid
% load('b.mat','b')
policies = VFIGridSolver();

%Save a representative of the value function to speed up future iterations
    X = [ones(numel(policies.A_grid),1),reshape(policies.A_grid,[],1),reshape(policies.delta_grid,[],1),reshape(policies.h_grid,[],1),reshape(policies.A_grid,[],1).^2,reshape(policies.delta_grid,[],1).^2,reshape(policies.h_grid,[],1).^2,reshape(policies.A_grid.*policies.delta_grid,[],1),reshape(policies.A_grid.*policies.h_grid,[],1),reshape(policies.delta_grid.*policies.h_grid,[],1)];
    Y = reshape(policies.hnext_policy,[],1);
    b = inv(X'*X)*X'*Y;
    save('b.mat','b')
    clear X Y b

%Define the choices and the choice probabilities
    choice_sd = 0.2;
    choice =  griddedInterpolant(policies.A_grid,policies.delta_grid,policies.h_grid,policies.hnext_policy);
    pr_choice = @(A,delta,h,hnext) normpdf((choice(ones(size(h,1),1)*A,ones(size(h,1),1)*delta,h)-hnext),0,choice_sd)
    pr_theta = @(theta,delta) normpdf(theta,1,0.05).*(1/(0.08-0.03));

%Next, simulate the data
%Simulate
    N = 2500;
    A_true = 1.05;
    delta_true = 0.07;
    h_sim = random('uniform',3.9,8.7,N,1);
    for t = 1:10
        h_sim(:,t+1)=choice(ones(N,1)*A_true,ones(N,1)*delta_true,h_sim(:,t))+choice_sd*randn(N,1);
    end
    save('popdata.mat','h_sim');

load('popdata.mat','h_sim')

%Prepare data
data = [reshape(h_sim(:,1:end-1),[],1),reshape(h_sim(:,2:end),[],1)];

%Transition function 
    theta_draw = @(theta) min([max([[theta(1)+0.01*randn,theta(2)+0.01*randn];[0.85,0.02]]);[1.15,0.08]])

%Pass starting point, data, prior, transition function to MCMC
post_dist=MCMC([1,0.05],pr_choice,pr_theta,theta_draw,data);

%Graph out posterior densities
    x = linspace(0.85,1.15,100);
    figure(1)
    subplot(1,2,1)
    plot(x,normpdf(x,1,0.05),'-k')
    hold on
    [temp1]=ksdensity(post_dist(:,1),x);
    plot(x,temp1,'--r')
    legend('Prior','Posterior')
    title('Distribution of A')
    subplot(1,2,2)
    x = linspace(0.03,0.08,100);
    plot(x,pdf('uniform',x,0.03,0.08),'-k')
    hold on
    [temp1]=ksdensity(post_dist(:,2),x);
    plot(x,temp1,'--r')
    title('Distribution of delta')



