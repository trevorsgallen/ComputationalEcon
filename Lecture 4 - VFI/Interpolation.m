clear

f = @(x) 0.5+-x+8.*sin(x)+x.^2

x_space = [-0.05:0.001:5.05]

x_space_1 = linspace(0,5,2);
x_space_2 = linspace(0,5,3);
x_space_3 = linspace(0,5,4);
x_space_4 = linspace(0,5,5);
x_space_5 = linspace(0,5,6);
x_space_6 = linspace(0,5,7);
x_space_7 = linspace(0,5,8);
x_space_8 = linspace(0,5,9);
x_space_9 = linspace(0,5,10);
x_space_10 = linspace(0,5,11);


figure(1)
plot(x_space,f(x_space))
ylim([0,14])
xlim([-0.05,5.05])
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)','location','northwest')
print('interpfig_1','-dpng')

figure(2)
lh = plot(x_space,f(x_space),'--b')
ylim([0,14])
xlim([-0.05,5.05])
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)','location','northwest')
print('interpfig_2','-dpng')


figure(3)
plot(x_space,f(x_space),'--b')
hold on
scatter(x_space_1,zeros(1,length(x_space_1)))
ylim([0,14])
xlim([-0.05,5.05])
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)','interpolating space','location','northwest')
print('interpfig_3','-dpng')

figure(4)
plot(x_space,f(x_space),'--b')
hold on
scatter(x_space_1,zeros(1,length(x_space_1)))
scatter(x_space_1,f(x_space_1))
plot([x_space_1(1),x_space_1(1)],[0,f(x_space_1(1))],'--r')
plot([x_space_1(2),x_space_1(2)],[0,f(x_space_1(2))],'--r')
ylim([0,14])
xlim([-0.05,5.05])
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)','interpolating space','location','northwest')
print('interpfig_4','-dpng')

figure(5)
plot(x_space,f(x_space),'--b')
hold on
scatter(x_space_1,zeros(1,length(x_space_1)))
plot([x_space_1],[f(x_space_1)],'-r')
scatter(x_space_1,f(x_space_1))
plot([x_space_1(1),x_space_1(1)],[0,f(x_space_1(1))],'--r')
plot([x_space_1(2),x_space_1(2)],[0,f(x_space_1(2))],'--r')
ylim([0,14])
xlim([-0.05,5.05])
title('f(x)=-x+8sin(x)+x^2')
xlabel('x')
ylabel('y')
legend('f(x)','interpolating space','fhat(x)','location','northwest')
print('interpfig_5','-dpng')

z = 5
for zz = 2:10
    z=z+1;
    figure(z)
    plot(x_space,f(x_space),'--b')
    hold on
    eval(['scatter(x_space_',num2str(zz),',zeros(1,length(x_space_',num2str(zz),')))'])
    eval(['plot(x_space_',num2str(zz),', f(x_space_',num2str(zz),'),''-r'')'])
    eval(['scatter(x_space_',num2str(zz),',f(x_space_',num2str(zz),'))'])
    temp = eval(['length(x_space_',num2str(zz),')'])
    for zzz = 1:temp
        eval(['plot([x_space_',num2str(zz),'(',num2str(zzz),'),x_space_',num2str(zz),'(',num2str(zzz),')],[0,f(x_space_',num2str(zz),'(',num2str(zzz),'))],''--r'')'])
    end
    ylim([0,14])
    xlim([-0.05,5.05])
    title('f(x)=-x+8sin(x)+x^2')
    xlabel('x')
    ylabel('y')
    legend('f(x)','interpolating space','fhat(x)','location','northwest')
    drawnow
    eval(['print(''interpfig_',num2str(z),'.png''',', ''-dpng'')'])
end
asdf
%     z=z+1;
%     figure(z)
%     plot(x_space,f(x_space),'--b')
%     hold on
%     scatter(x_space_2,zeros(1,length(x_space_2)))
%     plot(x_space_2,f(x_space_2),'-r')
%     scatter(x_space_2,f(x_space_2))
%     plot([x_space_2(1),x_space_2(1)],[0,f(x_space_2(1))],'--r')
%     plot([x_space_2(2),x_space_2(2)],[0,f(x_space_2(2))],'--r')
%     plot([x_space_2(3),x_space_2(3)],[0,f(x_space_2(3))],'--r')
%     plot([x_space_2(4),x_space_2(4)],[0,f(x_space_2(4))],'--r')
%     plot([x_space_2(5),x_space_2(5)],[0,f(x_space_2(5))],'--r')
%     plot([x_space_2(6),x_space_2(6)],[0,f(x_space_2(6))],'--r')
%     plot([x_space_2(7),x_space_2(7)],[0,f(x_space_2(7))],'--r')
%     plot([x_space_2(8),x_space_2(8)],[0,f(x_space_2(8))],'--r')
%     plot([x_space_2(9),x_space_2(9)],[0,f(x_space_2(9))],'--r')
%     plot([x_space_2(10),x_space_2(10)],[0,f(x_space_2(10))],'--r')
%     ylim([0,14])
%     xlim([-0.05,5.05])
%     title('f(x)=-x+8sin(x)+x^2')
%     xlabel('x')
%     ylabel('y')
%     legend('f(x)','interpolating space','interpolated line')
% 
