clear

beta = 0.95;
reward = @(x,y) (y-x).^2;
v_true = @(x) 0;
pi_true = @(x) x;
Q_true = @(x,y) (y-x).^2;

reward_obs = @(x,y) ((y-x).^2)+randn;

pi_belief = @(theta,x) theta(1)+theta(2)*x;
Q_belief = @(phi,x,y) (phi(1).*y-(phi(2)+phi(3)*x)).^2;
V_belief = @(theta,phi,x) Q_belief(phi,x,pi_belief(theta,x));


%Parameterize our functions
    theta_true = [0,1];
    theta_belief = [1,0.5]; 
    phi_true = [0,0,1];
    phi_belief = [2,0.5,2]; 

%Now, get a draw for x and y (and x next period, because we need it for
%algorithm, though irrelevant in this problem)
    x_sim = 3;
    xprime_sim = 4;
    y_sim = 2;

%Get observation of reward
    reward_obs(x_sim,y_sim)
   
%Get disappointment/advantage
    D = @(phi) reward_obs(x_sim,y_sim)+beta.*V_belief(theta_belief,phi,xprime_sim);
%Find the gradient (I use finite differences, though we could close form)
    gradD_phi = ([D(phi_belief+[0.001,0,0]);
                D(phi_belief+[0,0.001,0]);
                D(phi_belief+[0,0,0.001])]-D(phi_belief))./0.001;


