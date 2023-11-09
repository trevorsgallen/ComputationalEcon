clear
rng(1)

%Here's an actor-critic model where we know the critic is correct, but
%don't know the actor

%Define true functions
beta = 0.95;
reward = @(x,y) -(y-x).^2;
v_true = @(x) 0;
pi_true = @(x) x;
Q_true = @(x,y) -(y-x).^2;
reward_obs = @(x,y) -((y-x).^2)+0*randn;

pi_belief = @(theta,x) theta(1)+theta(2)*x;

grad_Q_y = @(x,y) -2*(y-x);
grad_x_theta = @(x,theta) [1;x];

%Parameterize our functions
    theta_true = [0;1];
    theta_belief = [0.5;2]; 

%Now, get a draw for x and y (and x next period, because we need it for
%algorithm, though irrelevant in this problem)
Tmax = 300;
plot([0:Tmax],theta_true(1).*ones(1,length([0:Tmax])),'--r')
hold on
plot([0:Tmax],theta_true(2).*ones(1,length([0:Tmax])),'--b')

counter = 0;
while counter < Tmax
    counter = counter+1;
        x_sim = rand;
        xprime_sim = 2;
        y_sim = pi_belief(theta_belief,x_sim);
       
    %Update the actor
        dtheta = grad_Q_y(x_sim,y_sim).*grad_x_theta(x_sim,theta_belief);
    
        theta_belief = theta_belief+0.1*dtheta;
        
        scatter(counter,theta_belief(1),'r')
        hold on
        scatter(counter,theta_belief(2),'b')
        drawnow
end


