clear

%Call Data Preparation Step
    Data_Preparation

%Store parameters
    clear parms
    parms.A = A_t;
    parms.delta = delta;
    parms.beta = beta_avg;
    parms.alpha = alpha;
    parms.psi = psi_avg;

%Set up initial guess for K and L
    k0 = K_t(1);
    T = 108;
    L = 0.15.*ones(T,1);
    K =   k0.*exp(0.0218.*[0:149]')
          K = K(1:109);
        
%FOC feeder
    focs_temp = @(x) focs_NCGTrend(x(1:T),[k0;x(T+1:end)],parms);

%Start out my initial guess of L's and k's using the actual L's and k's!
    x0 = [L;K(2:end)];
    focs_temp(x0)
    fopts = optimset('Display','iter','MaxFunEval',1e20,'MaxIter',1e20,'TolX',1e-20,'TolFun',1e-8)
    %Solve the system
        x0 = fsolve(focs_temp,x0,fopts)

%Grab the solutions, check the error
    [focerr,sol]= focs_temp(x0)

    A = sol(:,1);
    L = sol(:,2);
    K = sol(:,3);
    Y = sol(:,4);
    w = sol(:,5);
    r = sol(:,6);
    i = sol(:,7);
    C = sol(:,8);

t = [1967:1967+length(Y)-1];
ind = find(t <= 2022);
t2 = [1967:2022];


figure(1) 
[hAx,hLine1,hLine2] = plotyy(t2',((L_t.*5200).*N_t)./1000000000,[t2',t2',t2'],[(Y_t.*N_t),(C_t.*N_t),((I_t.*N_t))]./1000000000000);
legend('Labor hours (LH)','GDP (RH)','Consumption (RH)','Investment (RH)','Location','NorthWest')
title('Aggregate Y,C,I,L')
set(hAx,{'ycolor'},{'k';'k'})
xlabel('Year')
ylabel(hAx(1),'Billions of Labor Hours')
ylabel(hAx(2),'Trillions of Dollars')
print('../Figures/Figure_1.png','-dpng')

figure(2) 
[hAx,hLine1,hLine2] = plotyy(t2',(L_t),[t2',t2',t2'],[(Y_t),(C_t),((I_t))]);
legend('Labor hours (LH)','GDP (RH)','Consumption (RH)','Investment (RH)','Location','NorthWest')
title('Per-capita Y,C,I,L')
set(hAx,{'ycolor'},{'k';'k'})
xlabel('Year')
ylabel(hAx(1),'Fraction of Free Time Worked')
ylabel(hAx(2),'Dollars')
% mtit('The Neoclassical Growth Model & Data: 1967-2014',[yoff',.025])
print('../Figures/Figure_2.png','-dpng')

figure(7)
subplot(3,3,1)
plot(t(ind),Y(ind))
hold on
plot([1967:2022],Y_t,'-r')
title('Y')
subplot(3,3,2)
plot(t(ind),C(ind))
hold on
plot([1967:2022],C_t,'-r')
title('C')
subplot(3,3,3)
plot(t(ind),K(ind))
hold on
plot([1967:2022],K_t(1:end-1),'-r')
title('K')
subplot(3,3,4)
plot(t(ind),i(ind))
hold on
plot([1967:2022],I_t,'-r')
title('i')
subplot(3,3,5)
plot(t(ind),L(ind))
hold on
plot([1967:2022],L_t,'-r')
title('L')
subplot(3,3,6)
plot(t(ind),w(ind))
hold on
plot([1967:2022],w_t,'-r')
title('w')
subplot(3,3,7)
plot(t(ind),r(ind))
hold on
plot([1967:2022],r_t,'-r')
title('r')
subplot(3,3,8)
plot(t(ind),A(ind))
hold on
title('A')
subplot(3,3,9)
plot(t(ind),K(ind)./Y(ind))
hold on
title('K/Y')
plot([1967:2022],K_t(1:end-1)./Y_t,'-r')
p=mtit('The Neoclassical Growth Model & Data: 1967-2022','fontsize',14,'xoff',0,'yoff',.03)
print('../Figures/Figure_7.png','-dpng')

t2 = [1967:2022];
ind_1 = find(t >= 1978 & t <= 1986);
ind_2 = find(t2 >= 1978 & t2 <= 1986);

figure(8)
subplot(3,3,1)
plot(t(ind_1),Y(ind_1)./Y(ind_1(1)))
hold on
plot(t2(ind_2),Y_t(ind_2)./Y_t(ind_2(1)),'-r')
title('Y')
subplot(3,3,2)
plot(t(ind_1),C(ind_1)./C(ind_1(1)))
hold on
plot(t2(ind_2),C_t(ind_2)./C_t(ind_2(1)),'-r')
title('C')
subplot(3,3,3)
plot(t(ind_1),K(ind_1)./K(ind_1(1)))
hold on
plot(t2(ind_2),K_t(ind_2)./K_t(ind_2(1)),'-r')
title('K')
subplot(3,3,4)
plot(t(ind_1),i(ind_1)./i(ind_1(1)))
hold on
plot(t2(ind_2),I_t(ind_2)./I_t(ind_2(1)),'-r')
title('i')
subplot(3,3,5)
plot(t(ind_1),L(ind_1)./L(ind_1(1)))
hold on
plot(t2(ind_2),L_t(ind_2)./L_t(ind_2(1)),'-r')
title('L')
subplot(3,3,6)
plot(t(ind_1),w(ind_1)./w(ind_1(1)))
hold on
plot(t2(ind_2),w_t(ind_2)./w_t(ind_2(1)),'-r')
title('w')
subplot(3,3,7)
plot(t(ind_1),r(ind_1)./r(ind_1(1)))
hold on
plot(t2(ind_2),r_t(ind_2)./r_t(ind_2(1)),'-r')
title('r')
subplot(3,3,8)
plot(t(ind_1),A(ind_1)./A(ind_1(1)))
hold on
plot(t(ind_1),A(ind_1)./A(ind_1(1)),'-r')
hold on
title('A')
subplot(3,3,9)
plot(t(ind_1),(K(ind_1)./Y(ind_1))./(K(ind_1(1))./Y(ind_1(1))))
hold on
title('K/Y')
plot(t2(ind_2),(K_t(ind_2)./Y_t(ind_2))./(K_t(ind_2(1))./Y_t(ind_2(1))),'-r')
p=mtit('The Neoclassical Growth Model & Data: 1978-1986','fontsize',14,'xoff',0,'yoff',.03)
print('../Figures/Figure_8.png','-dpng')


t2 = [1967:2022];
ind_1 = find(t >= 2005 & t <= 2022);
ind_2 = find(t2 >= 2005 & t2 <= 2022);

figure(9)
subplot(3,3,1)
plot(t(ind_1),Y(ind_1)./Y(ind_1(1)))
hold on
plot(t2(ind_2),Y_t(ind_2)./Y_t(ind_2(1)),'-r')
title('Y')
subplot(3,3,2)
plot(t(ind_1),C(ind_1)./C(ind_1(1)))
hold on
plot(t2(ind_2),C_t(ind_2)./C_t(ind_2(1)),'-r')
title('C')
subplot(3,3,3)
plot(t(ind_1),K(ind_1)./K(ind_1(1)))
hold on
plot(t2(ind_2),K_t(ind_2)./K_t(ind_2(1)),'-r')
title('K')
subplot(3,3,4)
plot(t(ind_1),i(ind_1)./i(ind_1(1)))
hold on
plot(t2(ind_2),I_t(ind_2)./I_t(ind_2(1)),'-r')
title('i')
subplot(3,3,5)
plot(t(ind_1),L(ind_1)./L(ind_1(1)))
hold on
plot(t2(ind_2),L_t(ind_2)./L_t(ind_2(1)),'-r')
title('L')
subplot(3,3,6)
plot(t(ind_1),w(ind_1)./w(ind_1(1)))
hold on
plot(t2(ind_2),w_t(ind_2)./w_t(ind_2(1)),'-r')
title('w')
subplot(3,3,7)
plot(t(ind_1),r(ind_1)./r(ind_1(1)))
hold on
plot(t2(ind_2),r_t(ind_2)./r_t(ind_2(1)),'-r')
title('r')
subplot(3,3,8)
plot(t(ind_1),A(ind_1)./A(ind_1(1)))
hold on
plot(t(ind_1),A(ind_1)./A(ind_1(1)),'-r')
title('A')
subplot(3,3,9)
plot(t(ind_1),(K(ind_1)./Y(ind_1))./(K(ind_1(1))./Y(ind_1(1))))
hold on
title('K/Y')
plot(t2(ind_2),(K_t(ind_2)./Y_t(ind_2))./(K_t(ind_2(1))./Y_t(ind_2(1))),'-r')
p=mtit('The Neoclassical Growth Model & Data: 2005-2022','fontsize',14,'xoff',0,'yoff',.03)
print('../Figures/Figure_9.png','-dpng')


max(abs(focerr))
