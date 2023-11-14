clear
close all
Q_space = [0:0.01:7];

S_curve = @(Q) 0+Q;
D_curve = @(Q) 10-Q;
MC = @(Q) S_curve(Q)-D_curve(Q)
pclear = fzero(MC,5)
qclear = S_curve(pclear);

figure(1)
plot(Q_space,S_curve(Q_space),'-r')
hold on
plot(Q_space,D_curve(Q_space),'-b')
scatter(qclear,pclear,'k')
plot([qclear;qclear;0],[0;pclear;pclear],'--k')
xlabel('Quantity')
ylabel('Price')
legend('Supply','Demand','Equilibrium')
title('Supply and Demand, \tau_S=0, \tau_D=0')
print('TI_Fig1.png','-dpng')

S_curve_tau = @(Q) (1+0.0765).*(0+Q);
D_curve_tau = @(Q) (1-0.0765).*(10-Q);
MC_tau = @(Q) S_curve_tau(Q)-D_curve_tau(Q)
qclear_tau = fzero(MC_tau,5)
pclear_tau = S_curve_tau(qclear_tau)
pclear_tau_S = pclear_tau.*(1-0.0765);
pclear_tau_D = pclear_tau.*(1+0.0765);

figure(2)
plot(Q_space,S_curve(Q_space),'-r')
hold on
plot(Q_space,D_curve(Q_space),'-b')
plot(Q_space,S_curve_tau(Q_space),'--r')
hold on
plot(Q_space,D_curve_tau(Q_space),'--b')
scatter(qclear,pclear,[],[0.5 0.5 0.5])
scatter(qclear_tau,pclear_tau,'kx')
scatter(qclear_tau,pclear_tau_S,'r')
scatter(qclear_tau,pclear_tau_D,'b')
plot([qclear;qclear;0],[0;pclear;pclear],'--k')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau;pclear_tau],'--g')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau_S;pclear_tau_S],'--r')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau_D;pclear_tau_D],'--b')
xlabel('Quantity')
ylabel('Price')
legend('Old Supply','Old Demand','New Supply','New Demand','Old Equilibrium','New Market Price','New Supply Price','New Demand Price')
title('Supply and Demand, \tau_S=0.0765, \tau_D=0.0765')
print('TI_Fig2.png','-dpng')

S_curve_tau = @(Q) (1+0.16567406605306).*(0+Q);
D_curve_tau = @(Q) (1).*(10-Q);
MC_tau = @(Q) S_curve_tau(Q)-D_curve_tau(Q)
qclear_tau = fzero(MC_tau,5)
pclear_tau = S_curve_tau(qclear_tau)
pclear_tau_S = pclear_tau.*(1-0.16567406605306);
pclear_tau_D = pclear_tau;

figure(3)
plot(Q_space,S_curve(Q_space),'-r')
hold on
plot(Q_space,D_curve(Q_space),'-b')
plot(Q_space,S_curve_tau(Q_space),'--r')
hold on
plot(Q_space,D_curve_tau(Q_space),'--b')
scatter(qclear,pclear,[],[0.5 0.5 0.5])
scatter(qclear_tau,pclear_tau,'kx')
scatter(qclear_tau,pclear_tau_S,'r')
scatter(qclear_tau,pclear_tau_D,'b')
plot([qclear;qclear;0],[0;pclear;pclear],'--k')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau;pclear_tau],'--g')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau_S;pclear_tau_S],'--r')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau_D;pclear_tau_D],'--b')
xlabel('Quantity')
ylabel('Price')
legend('Old Supply','Old Demand','New Supply','New Demand','Old Equilibrium','New Market Price','New Supply Price','New Demand Price')
title('Supply and Demand, \tau_S=0.1657, \tau_D=0.0')
print('TI_Fig3.png','-dpng')

S_curve_tau = @(Q) (0+Q);
D_curve_tau = @(Q) (1-0.142127264282397).*(10-Q);
MC_tau = @(Q) S_curve_tau(Q)-D_curve_tau(Q)
qclear_tau = fzero(MC_tau,5)
pclear_tau = S_curve_tau(qclear_tau)
pclear_tau_S = pclear_tau;
pclear_tau_D = pclear_tau./(1-0.142127264282397);

figure(4)
plot(Q_space,S_curve(Q_space),'-r')
hold on
plot(Q_space,D_curve(Q_space),'-b')
plot(Q_space,S_curve_tau(Q_space),'--r')
hold on
plot(Q_space,D_curve_tau(Q_space),'--b')
scatter(qclear,pclear,[],[0.5 0.5 0.5])
scatter(qclear_tau,pclear_tau,'kx')
scatter(qclear_tau,pclear_tau_S,'r')
scatter(qclear_tau,pclear_tau_D,'b')
plot([qclear;qclear;0],[0;pclear;pclear],'--k')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau;pclear_tau],'--g')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau_S;pclear_tau_S],'--r')
plot([qclear_tau;qclear_tau;0],[0;pclear_tau_D;pclear_tau_D],'--b')
xlabel('Quantity')
ylabel('Price')
legend('Old Supply','Old Demand','New Supply','New Demand','Old Equilibrium','New Market Price','New Supply Price','New Demand Price')
title('Supply and Demand, \tau_S=0.0, \tau_D=0.142')
print('TI_Fig4.png','-dpng')
