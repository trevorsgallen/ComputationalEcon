clear;
clc;
close all;

f = @(x) (x>=0 & x<1).*0.5./(1-0) + (x>=-1 & x<2).*0.25./(2--1) + (x>=0.5 & x<0.75).*0.25./(0.75-0.5)

figure(1)
plot([-1.5:0.01:2.5],f([-1.5:0.01:2.5]))
xlabel('X')
ylabel('f(x)')
title('PDF of Distribution')
print('MH_1' ,'-dpng')

x = 0;
fignum = 1;
%Starting point: 0
    for t = 2:1000000
        xprop(t) = x(t-1)+sqrt(0.1)*randn;
        accpr = min(1,f(xprop(t))./f(x(t-1)));
        temp = rand;
        if temp < accpr
            x(t) = xprop(t);
        elseif temp >= accpr
            x(t) = x(t-1);
        end
%         
%         if mod(t,500) == 0 & t < 10000
%             fignum = fignum+1;
%             figure(fignum)
%             plot([-1.5:0.01:2.5],f([-1.5:0.01:2.5]))
%             hold on
%             ksdensity(x)
%             xlabel('X')
%             ylabel('f(x)')
%             eval(['title(''PDF of Distribution and Sample: ',num2str(t),' points'')'])
%             eval(['print(''','MH_',num2str(fignum),''' ,''-dpng'' )'])
%         end
%         if mod(t,100000) == 0 & t > 10000
%             fignum = fignum+1;
%             figure(fignum)
%             plot([-1.5:0.01:2.5],f([-1.5:0.01:2.5]))
%             hold on
%             ksdensity(x)
%             xlabel('X')
%             ylabel('f(x)')
%             eval(['title(''PDF of Distribution and Sample: ',num2str(t),' points'')'])
%             eval(['print(''','MH_',num2str(fignum),''' ,''-dpng'' )'])
%         end

    end
    
