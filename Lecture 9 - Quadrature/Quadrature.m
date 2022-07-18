% clear
% close all
% 
% x=[0:0.001:pi]';
% pts = [1*pi/6,3*pi/6,5*pi/6];
% 
% figure(1)
% plot(x,sin(x))
% title('Sin(x)')
% xlabel('x')
% ylabel('Sin(x)')
% xlim([0,pi])
% print('Riemann_1','-dpng')
% hold on
% scatter(pts,sin(pts))
% print('Riemann_2','-dpng')
% % ylim([-1,1.1])
% hold on
% ph=patch([0  0 2*pi/6 2*pi/6],...
%          [0 1 1        0],zeros(1,4));
%      alpha(0.4)
% set(ph,'facecolor',.95*[1 0 0]);
% set(ph,'edgecolor',.95*[0 0 0]);
% print('Riemann_3','-dpng')
% ph=patch([2*pi/6 2*pi/6 4*pi/6 4*pi/6],...
%          [0 1 1        0],zeros(1,4));
%      alpha(0.4)
% set(ph,'facecolor',.95*[0 1 0]);
% set(ph,'edgecolor',.95*[0 0 0]);
% print('Riemann_4','-dpng')
% ph=patch([4*pi/6 4*pi/6 6*pi/6 6*pi/6],...
%          [0 1 1        0],zeros(1,4));
%      alpha(0.4)
% set(ph,'facecolor',.95*[0 0 1]);
% set(ph,'edgecolor',.95*[0 0 0]);
% print('Riemann_5','-dpng')
% plot([0,0,2*pi/6,2*pi/6,0],[0,sin(pts(1)),sin(pts(1)),0,0],'-y')
% temp1 = (2*pi/6-0)*sin(1*pi/6);
% text(1*pi/6-0.1,0.2,num2str(temp1))
% print('Riemann_6','-dpng')
% plot([2*pi/6,2*pi/6,4*pi/6,4*pi/6,0],[0,sin(pts(2)),sin(pts(2)),0,0],'-y')
% temp2 = (2*pi/6-0)*sin(3*pi/6);
% text(3*pi/6-0.1,0.4,num2str(temp1))
% print('Riemann_7','-dpng')
% plot([4*pi/6,4*pi/6,6*pi/6,6*pi/6,0],[0,sin(pts(3)),sin(pts(3)),0,0],'-y')
% temp3 = (2*pi/6-0)*sin(5*pi/6);
% text(5*pi/6-0.1,0.2,num2str(temp1))
% print('Riemann_8','-dpng')
% title(['Int_0^{\pi} sin(x)dx\approx',num2str(temp1+temp2+temp3),' (truth=2)'])
% print('Riemann_9','-dpng')

%Gauss-Chebyshev
    for nn = 1:20
        f = @(x) sin(x)
        n=nn
        b = pi;
        a = 0;
        i = [1:n]
        xi = cos(pi*(2.*i-1)./(2.*n))
        nn_sto(nn) = nn;
        int_sto(nn) = (pi*(b-a)./(2.*n)).*sum(f(a+(1+xi).*(b-a)./2).*sqrt(1-xi.^2))
    end

figure(1)
plot(nn_sto,int_sto)
hold on
plot(nn_sto,2*ones(length(nn_sto),1),'--r')
xlim([1,20])
title('Integral as a function of approximation order')
xlabel('Order of Approximation')
ylabel('Integral')
print('Quad_1','-dpng')

figure(2)
plot(nn_sto,log10(abs(int_sto-2)./2))
xlim([1,20])
title('Order of Absolute Percent Error as a function of approximation order')
xlabel('Order of Approximation')
ylabel('Order of Absolute Percent Error')
print('Quad_2','-dpng')

