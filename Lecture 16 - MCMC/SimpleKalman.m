clear
x = 0;
rho = 0.95;
sigma2_x = 1;
sigma2_z = 5;
T = 100;
rng(0)

for t = 1:T-1
    x(t+1) = rho*x(t)+sqrt(sigma2_x)*randn;
    z(t) = x(t)+sqrt(sigma2_z)*randn;
end

figure(1)
plot(x)
hold on
plot(z)

x_belief_mu = 0;
x_belief_std = 1;

kappa = sigma2_x./(sigma2_x+sigma2_z);

for t = 2:T-1
    x_belief_mu(t) = rho*x_belief_mu(t-1)+kappa*(z(t)-rho*x_belief_mu(t-1));
    x_belief_std(t) = (1-kappa)*sigma2_z;
end

figure(2)
plot(x,'k')
hold on
plot(z,'--r')
plot(x_belief_mu,'-b')
legend('Truth','Data','Belief')
