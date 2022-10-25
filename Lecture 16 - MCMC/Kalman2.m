clear
x = 0;
rho = 0.95;
sigma2_x = 1;
sigma2_y = 5;
T = 100;
rng(0)

for t = 1:T-1
    x(t+1) = x(t)+sqrt(sigma2_x)*randn;
    y(t) = x(t)+sqrt(sigma2_y)*randn;
end

figure(1)
plot(x)
hold on
plot(y)

x_belief_mu = 0;
x_belief_var = 1;

kappa = sigma2_x./(sigma2_x+sigma2_y);

for t = 2:T-1
    x_belief_mu(t) = (x_belief_mu(t-1).*sigma2_x+y(t).*(sigma2_y+x_belief_var(t-1))./((sigma2_y+x_belief_var(t-1))+sigma2_x));
    x_belief_var(t) =((sigma2_y+x_belief_var(t-1))).*sigma2_x./((sigma2_y+x_belief_var(t-1))+sigma2_x);
end

figure(2)
plot(x,'k')
hold on
plot(y,'--r')
plot(x_belief_mu,'-b')
legend('Truth','Data','Belief')
