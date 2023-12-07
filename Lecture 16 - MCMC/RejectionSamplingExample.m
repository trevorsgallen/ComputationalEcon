clear

mu = 0;
sigma = 5;

x_vec = -20:0.1:20
f = pdf('Normal',mu,sigma,x_vec)

Urand_x = random('Uniform',-20,20,10000,1);
Urand_y = random('Uniform',1,10000,1);

insample=Urand_y<=pdf('Normal',0,5,Urand_x)

plot(x_vec,f,'-k')
hold on
scatter(Urand_x(insample==1),Urand_y(insample==1),'-r')
hold on
scatter(Urand_x(insample==1),Urand_y(insample==1),'-b')
title('Rejection Sampling')
xtitle('x')
ytitle('Density')


