clear
close all

%Data
    X = [1 , .9172657 ;
    1 ,.8182806  ;
    1 ,.0528158 ;
    1 ,.4792661 ;
    1 ,.7373222 ;
    1 ,.3800655 ;
    1 ,.1008018 ;
    1 ,.1574548 ;
    1 ,.1021647 ;
    1 ,.008968]

    Y = [6.79301;
    7.491111;
    5.170376;
    8.427786;
    7.07075;
    4.827225;
    6.429296;
    4.598952;
    5.446826;
    6.298986];

%We have a closed-form solution to compare our numerical one to
    betatrue = inv(X'*X)*X'*Y
    
%Define our "infintesimally small" step and two-dimensional steps for
%convienience
    d = 1e-7;
    d1 = [d;0];
    d2 = [0;d];
    d3 = [d;d];


%Define the sum of squared errors
    f = @(b) sum((Y-X*b).^2)
%Define the gradient as a function of beta (central step finite differences)
    f_grad =  @(b) [f(b+d1)-f(b-d1) ; f(b+d2)-f(b-d2)]/(2*d)
%Define the Hessian as a function of beta
    f_hess =  @(b) [(f(b+d1)-2.*f(b)+f(b-d1)) , f(b+d3)-f(b+d1-d2)-f(b-d1+d2)+f(b-d3) ; f(b+d3)-f(b+d1-d2)-f(b-d1+d2)+f(b-d3) , (f(b+d2)-2.*f(b)+f(b-d2))]/(4*(d^2))

%Get an idea of the values at the truth
    f(betatrue)
    f_grad(betatrue)
    f_hess(betatrue)

% beta = betatrue*1.1
beta = [0;0]
z=0
error = Inf;

figure(1)
scatter(X(:,2),Y)
title('Scatterplot and Fits of Data')
xlabel('Crack')
ylabel('Crime')

while error > 1e-10
    'Enter'
    z = z+1;
%     if z < 30
%         figure(z)
%         scatter(X(:,2),Y)
%         hold on
%         plot(X(:,2),X*beta)
%         hold on
%         plot(X(:,2),X*betatrue)
%         title('Scatterplot and Fits of Data')
%         xlabel('Crack')
%         ylabel('Crime')
%         ylim([0,9])
%         legend('Data','Best Fit','True Fit')
%         drawnow
%         eval(['print(''','Newton_OLS_Figure_',num2str(z),'.png''',', ''-dpng'' )'])
%     end
        
    beta_sto(:,z) = beta;
    error = max(abs(f_grad(beta)));;
    error_sto(z) = error;
    beta = beta-inv(f_hess(beta)+100*eye(2))*f_grad(beta);
end

% inv(f_hess(betatrue))

        figure(z+1)
        scatter(X(:,2),Y)
        hold on
        plot(X(:,2),X*beta)
        hold on
        plot(X(:,2),X*betatrue)
        title('Scatterplot and Fits of Data')
        xlabel('Crack')
        ylabel('Crime')
        ylim([0,9])
        legend('Data','Best Fit','True Fit')
        drawnow
        print('Newton_OLS_Figure_30','-dpng')

Table = cell(3,3);
Table{1,1} = 'Variable';
Table{2,1} = 'Beta 1';
Table{3,1} = 'Beta 2';
Table{1,2} = '(XTX)^(-1)XTY';
Table{1,3} = 'Newtons Method';
Table{2,2} = betatrue(1);
Table{3,2} = betatrue(2);
Table{2,3} = beta(1);
Table{3,3} = beta(2);
Table


