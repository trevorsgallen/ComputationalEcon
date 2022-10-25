clear pi
for nn = 2:15
    clear -nn
    close all
    
    f = @(x) 1./(1+x.^2);
    a = -5;
    b = 5;
    n = nn;

    T_0 = @(x) ones(length(x),1);
    T_1 = @(x) x;

    for x = 2:n+1
        eval(['T_',num2str(x),' = @(x) 2.*x.*T_',num2str(x-1),'(x)- T_',num2str(x-2),'(x)'])
    end


    %First, define Chebychev nodes (roots)
        k = [0:n-1];
        z_space = -cos((2*(n-1)+1-2*[0:n-1])./(2.*(n-1)+2)*pi)'

    x_space = a+(b-a).*(z_space+1)./2;
    x_space_enhanced = linspace(a,b,10000);
    y = f(x_space);

    % A different version of the same formula for coefficients
%     c(:,1) = sum((1/(n)).*y.*T_0(z_space));
%     for j = 1:n-1
%         eval(['c(:,',num2str(j+1),') = sum((2/(n)).*y.*T_',num2str(j),'(z_space))']);
%     end

    for j = 1:n
        eval(['c(',num2str(j),') = sum(y.*T_',num2str(j-1),'(z_space))./sum(T_',num2str(j-1),'(z_space).^2)']);
    end


    f_approx = @(x) c(1).*T_0(x);
    for z = 2:n
        eval(['f_approx = @(x) f_approx(x)+c(z).*T_',num2str(z-1),'(x)'])
    end

    figure(1)
    plot(x_space_enhanced',f_approx(2*(x_space_enhanced'-a)./(b-a)-1),'-k')
    hold on
    plot(x_space_enhanced,f(x_space_enhanced),'--r')
    eval(['title(''1./(1+x.^2) and ',num2str(n),' degree approximation'')'])
    xlabel('x')
    ylabel('f(x)')
    scatter(x_space,f_approx(2*(x_space-a)./(b-a)-1))
    eval(['print(''Cheby_1D_',num2str(n),''',''-dpng'')'])

    figure(2)
    plot(x_space_enhanced',f(x_space_enhanced')-f_approx(2*(x_space_enhanced'-a)./(b-a)-1),'-k')
    hold on
    xlabel('x')
    ylabel('f(x)-fhat(x)')
    ylim([-0.75,1])
    scatter(x_space,f(x_space)-f_approx(2*(x_space-a)./(b-a)-1))
    eval(['title(''Error and ',num2str(n),' degree approximation'')'])
    eval(['print(''Cheby_1D_err_',num2str(n),''',''-dpng'')'])
end