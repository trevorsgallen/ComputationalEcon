for nn = 1:13
    clear -nn
    clc
    close all

    f = @(x) 1./(1+x.^2);

    n = nn;

    a = -6;
    b = 6;

    n_enhanced = 100;
    if n >= 2
        x_space = linspace(a,b,n)';
    elseif n == 1
        x_space = (a+b)./2
    end
    x_enhanced = linspace(a,b,n_enhanced)';

    plot(x_enhanced,f(x_enhanced))
    title('1./(1+x.^2)')
    xlabel('x')
    ylabel('y')
    print('Test_Function','-dpng')
    Y = f(x_space);

    X = [];
    for z = 0:n-1
        eval(['X = [X,ones(n,1).*x_space.^',num2str(z),']'])
    end

    beta = inv(X'*X)*X'*Y;
    Xfit = [];
    for z = 0:n-1
        eval(['Xfit = [Xfit,ones(n_enhanced,1).*x_enhanced.^',num2str(z),']'])
    end

    figure(1)
    plot(x_enhanced,f(x_enhanced))
    hold on
    plot(x_enhanced,Xfit*beta,'--r')
    eval(['title(''1./(1+x.^2) and ',num2str(n),' degree approximation'')'])
    xlabel('x')
    ylabel('f(x)')
    scatter(x_space,X*beta)
    eval(['print(''Monom_1D_',num2str(n),''',''-dpng'')'])

    figure(2)
    plot(x_enhanced,f(x_enhanced)-Xfit*beta)
    eval(['title(''Difference between 1./(1+x.^2) and ',num2str(n),' degree approximation'')'])
    xlabel('x')
    ylabel('f(x)')
    ylim([-3,6])
    eval(['print(''Monom_1D_err_',num2str(n),''',''-dpng'')'])
    
    figure(3)
    plot(x_enhanced,f(x_enhanced)-Xfit*beta)
    eval(['title(''Difference between 1./(1+x.^2) and ',num2str(n),' degree approximation'')'])
    xlabel('x')
    ylabel('f(x)')
    eval(['print(''Monom_1D_err_zoom',num2str(n),''',''-dpng'')'])

end
