clear

run '/Users/tgallen/Downloads/rbc-2/Test'

T = 100;
L = 0.305635794540672.*ones(T,1);
K = [2.18816578930809; 2.18816578930809.*ones(T,1)];

focs_temp = @(x) focs(x(1:T),x(T+1:end));

x0 = [L;K];

focs_temp([L;K])
% x0 = lsqnonlin(focs_temp,[L;K])
fopts = optimset('MaxFunEval',1e4,'MaxIter',1e4,'TolX',1e-20,'TolFun',1e-8)
x0 = fsolve(focs_temp,x0,fopts)

[focerr,sol]= focs_temp(x0)

A = sol(:,1);
L = sol(:,2);
K = sol(:,3);
Y = sol(:,4);
w = sol(:,5);
r = sol(:,6);
i = sol(:,7);
C = sol(:,8);

load '/Users/tgallen/Downloads/rbc-2/temp.mat' simul

figure(1)
subplot(3,3,1)
plot(Y)
hold on
plot(simul(1,:),'--r');
title('Y')
ylim([0.5,0.65])
subplot(3,3,2)
plot(C)
hold on
plot(simul(2,:),'--r');
title('C')
ylim([0.5,0.55])
subplot(3,3,3)
plot(K)
hold on
plot(simul(3,:),'--r');
title('K')
ylim([2,2.5])
subplot(3,3,4)
plot(i)
hold on
plot(simul(4,:),'--r');
title('i')
ylim([0.02,0.12])
subplot(3,3,5)
plot(L)
hold on
plot(simul(5,:),'--r');
title('L')
ylim([0.29,0.33])
subplot(3,3,6)
plot(w)
hold on
plot(simul(6,:),'--r');
title('w')
ylim([1.25,1.4])
subplot(3,3,7)
plot(r)
hold on
plot(simul(8,:),'--r');
title('r')
ylim([0.065,0.085])
subplot(3,3,8)
plot(A)
hold on
plot(simul(7,:),'--r');
title('A')
ylim([1,1.15])

