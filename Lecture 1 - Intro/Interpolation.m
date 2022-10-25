clear

f = @(x) 0.5+-x+8.*sin(x)+x.^2

x_space = [0:0.001:5]

x_space_1 = linspace(0,5,2);

figure(1)
plot(x_space,f(x_space))
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)')


figure(2)
lh = plot(x_space,f(x_space),'--b')
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)')


figure(3)
plot(x_space,f(x_space),'--b')
hold on
scatter(x_space_1,zeros(1,length(x_space_1)))
ylim([0,14])
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)','interpolating space')

figure(4)
plot(x_space,f(x_space),'--b')
hold on
scatter(x_space_1,zeros(1,length(x_space_1)))
scatter(x_space_1,f(x_space_1))
plot([x_space_1(1),x_space_1(1)],[0,f(x_space_1(1))],'--r')

ylim([0,14])
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)','interpolating space')
