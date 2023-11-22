
clear

f = @(x) cos(3*x)+x
a = -5;
b = 5;
n = 20;

T_0 = @(x) ones(length(x),1);
T_1 = @(x) x;

for x = 2:n+1
    eval(['T_',num2str(x),' = @(x) reshape(2.*x.*T_',num2str(x-1),'(x),[],1)- reshape(T_',num2str(x-2),'(x),[],1)'])
end


%First, define Chebychev nodes (roots)
    k = [0:n-1];
    z_space = -cos((2*(n-1)+1-2*[0:n-1])./(2.*(n-1)+2)*pi)'
    
x_space = a+(b-a).*(z_space+1)./2;
x_space_enhanced = linspace(a,b,10000);
y = f(x_space);

% A different version of the same formula for coefficients
% c(:,1) = sum((1/(n)).*y.*T_0(z_space));
% for j = 1:n-1
%     eval(['c(:,',num2str(j+1),') = sum((2/(n)).*y.*T_',num2str(j),'(z_space))']);
% end

for j = 1:n

    eval(['c(',num2str(j),') = sum(y.*T_',num2str(j-1),'(z_space))./sum(T_',num2str(j-1),'(z_space).^2)']);
end


f_approx = @(x) c(1).*T_0(x);
for z = 2:n
    eval(['f_approx = @(x) f_approx(x)+c(z).*T_',num2str(z-1),'(x)'])
end

figure(4)
plot(x_space,f_approx(z_space),'-xk')
hold on
plot(x_space,f(x_space),'-o')

figure(1)
plot(x_space,f_approx(z_space),'-xk')
hold on
plot(x_space_enhanced,f(x_space_enhanced),'-or')

%Plot the bases
    x = [0:0.01:1];

    figure(2)
    subplot(3,3,1)
    plot(x_space,ones(length(x_space),1))
    title('1')
    subplot(3,3,2)
    plot(x_space,z_space)
    title('x')
    subplot(3,3,3)
    plot(x_space,z_space.^2)
    title('x^2')
    subplot(3,3,4)
    plot(x_space,z_space.^3)
    title('x^3')
    subplot(3,3,5)
    plot(x_space,z_space.^4)
    title('x^4')
    subplot(3,3,6)
    plot(x_space,z_space.^5)
    title('x^5')
    subplot(3,3,7)
    plot(x_space,z_space.^6)
    title('x^6')
    subplot(3,3,8)
    plot(x_space,z_space.^7)
    title('x^7')
    subplot(3,3,9)
    plot(x_space,z_space.^8)
    title('x^8')
    print('Bases_Monomial','-dpng')

    x = [-1:0.01:1]';


    figure(3)
    subplot(3,3,1)
    plot(x,T_0(x))
    title('1')
    subplot(3,3,2)
    plot(x,T_1(x))
    title('x')
    subplot(3,3,3)
    plot(x,T_2(x))
    title('x^2')
    subplot(3,3,4)
    plot(x,T_3(x))
    title('x^3')
    subplot(3,3,5)
    plot(x,T_4(x))
    title('x^4')
    subplot(3,3,6)
    plot(x,T_5(x))
    title('x^5')
    subplot(3,3,7)
    plot(x,T_6(x))
    title('x^6')
    subplot(3,3,8)
    plot(x,T_7(x))
    title('x^7')
    subplot(3,3,9)
    plot(x,T_8(x))
    title('x^8')
    print('Bases_Chebychev','-dpng')
