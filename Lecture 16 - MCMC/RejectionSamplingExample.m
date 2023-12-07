clear

mu = 0;
sigma = 5;

x_vec = -20:0.1:20
f = pdf('Normal',x_vec,mu,sigma)

Urand_x = random('Uniform',-20,20,10000,1);
Urand_y = random('Uniform',0,0.2,10000,1);

insample=Urand_y<=pdf('Normal',Urand_x,0,5)

plot(x_vec,f,'-k')
hold on
scatter(Urand_x(insample==1),Urand_y(insample==1),'r')
hold on
scatter(Urand_x(insample==0),Urand_y(insample==0),'b')
title('Rejection Sampling')
xlabel('x')
ylabel('Density')
legend('pdf','Sampled','Rejected')


