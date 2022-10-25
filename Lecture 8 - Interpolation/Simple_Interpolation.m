clear

f = @(x) exp(x)+10.*sin(x)-2.*x;

x_space = [0:0.01:5]';


%Linear regression
    X_0 = ones(length(x_space),1);
    X_1 = [X_0,x_space];
    X_2 = [X_1,x_space.^2];
    X_3 = [X_2,x_space.^3];
    X_4 = [X_3,x_space.^4];
    X_5 = [X_4,x_space.^5];
    
    beta_0 = inv(X_0'*X_0)*X_0'*f(x_space);
    beta_1 = inv(X_1'*X_1)*X_1'*f(x_space);
    beta_2 = inv(X_2'*X_2)*X_2'*f(x_space);
    beta_3 = inv(X_3'*X_3)*X_3'*f(x_space);
    beta_4 = inv(X_4'*X_4)*X_4'*f(x_space);
    beta_5 = inv(X_5'*X_5)*X_5'*f(x_space);
    
    figure(1)
    plot(x_space,f(x_space),'-k')
    hold on
%     scatter(x_space,f(x_space))
    title('f(x) = exp(x)+10.*sin(x)-2.*x')
    xlabel('x')
    ylabel('f(x)')
    print('Simple_m1','-dpng')


    figure(2)
    plot(x_space,f(x_space),'-k')
    hold on
    plot(x_space,X_0*beta_0,'--r')
    hold on
%     scatter(x_space,f(x_space))
    xlabel('x')
    ylabel('f(x)')
    title('f(x) = exp(x)+10.*sin(x)-2.*x')
    print('Simple_0','-dpng')

    figure(3)
    plot(x_space,f(x_space),'-k')
    hold on
    plot(x_space,X_1*beta_1,'--r')
    hold on
%     scatter(x_space,f(x_space))
    xlabel('x')
    ylabel('f(x)')
    title('f(x) = exp(x)+10.*sin(x)-2.*x')
    print('Simple_1','-dpng')

    figure(4)
    plot(x_space,f(x_space),'-k')
    hold on
    plot(x_space,X_2*beta_2,'--r')
    hold on
%     scatter(x_space,f(x_space))
    xlabel('x')
    ylabel('f(x)')
    title('f(x) = exp(x)+10.*sin(x)-2.*x')
    print('Simple_2','-dpng')

    figure(5)
    plot(x_space,f(x_space),'-k')
    hold on
    plot(x_space,X_3*beta_3,'--r')
    hold on
%     scatter(x_space,f(x_space))
    xlabel('x')
    ylabel('f(x)')
    title('f(x) = exp(x)+10.*sin(x)-2.*x')
    print('Simple_3','-dpng')


    figure(6)
    plot(x_space,f(x_space),'-k')
    hold on
    plot(x_space,X_4*beta_4,'--r')
    hold on
%     scatter(x_space,f(x_space))
    xlabel('x')
    ylabel('f(x)')
    title('f(x) = exp(x)+10.*sin(x)-2.*x')
    print('Simple_4','-dpng')

    figure(7)
    plot(x_space,f(x_space),'-k')
    hold on
    plot(x_space,X_5*beta_5,'--r')
    hold on
%     scatter(x_space,f(x_space))
    xlabel('x')
    ylabel('f(x)')
    title('f(x) = exp(x)+10.*sin(x)-2.*x')
    print('Simple_5','-dpng')

