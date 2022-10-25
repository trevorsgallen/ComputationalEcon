clear;
clc;
close all;

mu_1 = 0;
mu_2 = 0;
sigma_1 = 1;
sigma_2 = 1;
rho = 0.6;

mu = [mu_1 mu_2]; 
sigma = [sigma_1 rho; rho sigma_2]; 

f = @(x) mvnpdf(x,mu,sigma);

[X1,X2] = meshgrid([-5:0.01:10],[-3:0.01:7]);

X1_temp = reshape(X1,[],1);
X2_temp = reshape(X2,[],1);
d1 = size(X1,1);
d2 = size(X1,2);

f_joint = reshape(f([X1_temp,X2_temp]),d1,d2);

figure(1)
pcolor(X1,X2,f_joint)
shading flat
xlabel('x1')
ylabel('x2')
title('Joint Distribution of x1 and x2')
print('Gibbs_1' ,'-dpng')

figure(2)
pcolor(X1,X2,f_joint)
hold on
scatter(7,-2,'r','filled')
shading flat
xlabel('x1')
ylabel('x2')
title('Joint Distribution of x1 and x2')
print('Gibbs_2' ,'-dpng')

fignum = 2;
x = [7,-2];
for t = 2:101
    x(t,1) = sqrt(1-rho.^2).*randn+rho.*x(t-1,2);
    x(t,2) = sqrt(1-rho.^2).*randn+rho.*x(t,1);
    
    if t < 10 | mod(t,10) == 0
        fignum = fignum+1;
        %Sample from 1 given 2
        figure(fignum)
        pcolor(X1,X2,f_joint)
        hold on
        if t < 10
            scatter(x(2:end,1),x(1:end-1,2),'r')
            scatter(x(1:end-1,1),x(1:end-1,2),'r','filled')
        end
        if t > 10
            scatter(x(:,1),x(:,2),'r')
        end
        shading flat
        xlabel('x1')
        ylabel('x2')
        title('Joint Distribution of x1 and x2')
        eval(['print(''','Gibbs_',num2str(fignum),''' ,''-dpng'' )'])
    end
end



