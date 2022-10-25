clear
close all

% f = @(x1,x2) x1.^2+x2.^2+x1.*x2+(x1.*x2).^2
f = @(x,y) (1-x).^2 + 100.*(y-x.^2).^2;

[X,Y] = meshgrid([-4:.01:4],[-4:.01:4]);
FY = f(X,Y);

figure(1)
pcolor(X,Y,FY)
hold on
shading flat
scatter(0,0,'R','Filled')
title('f(x,y)=x^2+y^2+x*y')
xlabel('X')
ylabel('Y')
print('Conjugate_Gradient_1','-dpng')

x0 = [2,-1];
d = 1e-10;

% f_grad = @(x,y) [-2.*(1-x) + 2.*100.*(y-x.^2).*(-2.*x) , 2.*100.*(y-x.^2)]
f_grad = @(x,y) [(f(x+d,y)-f(x,y))./d , (f(x,y+d)-f(x,y))./d]

%Obtain search direction
    s = -f_grad(x0(1),x0(2))
    temp = [x0-100.*s ; x0+100.*s];
    figure(2)
    pcolor(X,Y,FY)
    hold on
    shading flat
    scatter(1,1,'R','Filled')
    scatter(x0(1),x0(2),'Y','Filled')
    title('f(x,y)=x^2+y^2+x*y')
    xlabel('X')
    ylabel('Y')
    print('Conjugate_Gradient_2','-dpng')
    plot(temp(:,1),temp(:,2))
    print('Conjugate_Gradient_3','-dpng')

%Minimize
    f_lambda = @(lambda) f(x0(1)+lambda.*s(1),x0(2)+lambda.*s(2))
    f_lambda_grad = @(lambda) f(x0(1)+lambda.*f_grad(x0(1),x0(2)),x0(2)+lambda.*f_grad(x0(1),x0(2)))
    %Find the best choice via line search
        lambda_0 = fminbnd(f_lambda,-5,5)
        lambda_0_alt = fminbnd(f_lambda_grad,-5,5)
        oldx0 = x0;
        oldx0_alt = 
        x0 = x0+lambda_0.*s;
        scatter(x0(1),x0(2),'R','Filled')
        print('Conjugate_Gradient_4','-dpng')
   
    z = 4;
    for t = 1:20
        z = z+1;
        %Compute search direction
            s = -f_grad(x0(1),x0(2)) + sum(f_grad(x0(1),x0(2)).^2)./sum(f_grad(oldx0(1),oldx0(2)).^2)*s       
        if t == 1 | t == 2 | t == 3 | t == 4
            s_alt = -f_grad(x0(1),x0(2));        
            %Plot search direction vs gradient 
            temp2 = [x0-100.*s_alt ; x0+100.*s_alt]
            plot(temp2(:,1),temp2(:,2),'--r')
        end
            temp = [x0-100.*s ; x0+100.*s];
            plot(temp(:,1),temp(:,2))
        scatter(1,1,'R','Filled')
        eval(['print(''Conjugate_Gradient_',num2str(z),''',''-dpng'')'])
        z = z+1;
        f_lambda = @(lambda) f(x0(1)+lambda.*s(1),x0(2)+lambda.*s(2))
        lambda_0 = fminunc(f_lambda,0)
        oldx0 = x0;
        x0 = x0+lambda_0.*s;
        scatter(x0(1),x0(2),'Y','Filled')
        scatter(1,1,'R','Filled')
        eval(['print(''Conjugate_Gradient_',num2str(z),''',''-dpng'')'])
    end
    


asdf
