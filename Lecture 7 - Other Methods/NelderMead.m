clear
close all

f = @(x,y) (1-x).^2 + 100.*(y-x.^2).^2;
alpha = 0.4;
gamma = 0.8;
rho = -0.2;
sigma = 0.5;

[X,Y] = meshgrid(-2:.01:2);
FY = f(X,Y)

figure(1)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
title('Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2')
xlabel('X')
ylabel('Y')
print('Nelder_Mead_1','-dpng')


%Step 1:  Create the simplex

xval = [-1.5,-0.5 ; -0.5,1.5 ; 0,0]

figure(2)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
scatter(xval(:,1),xval(:,2),'G','Filled')
line([xval(:,1);xval(1,1)],[xval(:,2);xval(1,2)])
title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Initial Points'})
xlabel('X')
ylabel('Y')
print('Nelder_Mead_2','-dpng')



ptval = f(xval(:,1),xval(:,2));
temp = sortrows([ptval,xval]);
ptval = temp(:,1);
xval = temp(:,2:3);

figure(3)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
scatter(xval(1,1),xval(1,2),'G','Filled')
scatter(xval(2,1),xval(2,2),'G','Filled')
scatter(xval(3,1),xval(3,2),'Y','Filled')
line([xval(:,1);xval(1,1)],[xval(:,2);xval(1,2)])
title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Worst Point'})
xlabel('X')
ylabel('Y')
print('Nelder_Mead_3','-dpng')


x0 = mean(xval(1:2,:))
xr = x0+alpha*(x0-xval(3,:))

figure(4)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
scatter(xval(1,1),xval(1,2),'G','Filled')
scatter(xval(2,1),xval(2,2),'G','Filled')
scatter(xval(3,1),xval(3,2),'Y','Filled')
scatter(xr(1),xr(2),'W','Filled')
line([xval(:,1);xval(1,1);xr(1);xval(1,1);xr(1);xval(2,1);xr(1);xval(3,1)],[xval(:,2);xval(1,2);xr(2);xval(1,2);xr(2);xval(2,2);xr(2);xval(3,2)])
title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Reflected Point'})
xlabel('X')
ylabel('Y')
print('Nelder_Mead_4','-dpng')

x0 = mean(xval(1:2,:))
xe = x0+gamma*(x0-xval(3,:))

figure(5)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
scatter(xval(1,1),xval(1,2),'G','Filled')
scatter(xval(2,1),xval(2,2),'G','Filled')
scatter(xval(3,1),xval(3,2),'Y','Filled')
scatter(xe(1),xe(2),'W','Filled')
line([xval(:,1);xval(1,1);xe(1);xval(1,1);xe(1);xval(2,1);xe(1);xval(3,1)],[xval(:,2);xval(1,2);xe(2);xval(1,2);xe(2);xval(2,2);xe(2);xval(3,2)])
title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Reflected Point, Expanded'})
xlabel('X')
ylabel('Y')
print('Nelder_Mead_5','-dpng')

x0 = mean(xval(1:2,:))
xc = x0+rho*(x0-xval(3,:))

figure(6)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
scatter(xval(1,1),xval(1,2),'G','Filled')
scatter(xval(2,1),xval(2,2),'G','Filled')
scatter(xval(3,1),xval(3,2),'Y','Filled')
scatter(xc(1),xc(2),'W','Filled')
line([xval(:,1);xval(1,1);xc(1);xval(1,1);xc(1);xval(2,1);xc(1);xval(3,1)],[xval(:,2);xval(1,2);xc(2);xval(1,2);xc(2);xval(2,2);xc(2);xval(3,2)])
title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Contracted Point'})
xlabel('X')
ylabel('Y')
print('Nelder_Mead_6','-dpng')


x0 = mean(xval(1:2,:))
xd = [xval(1,:);xval(1,:)]+sigma*(xval(2:3,:)-[xval(1,:);xval(1,:)])


figure(7)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
scatter(xval(1,1),xval(1,2),'G','Filled')
scatter(xval(2,1),xval(2,2),'G','Filled')
scatter(xval(3,1),xval(3,2),'Y','Filled')
scatter(xd(:,1),xd(:,2),'W','Filled')
line([xval(:,1);xval(1,1);xval(1,1)],[xval(:,2);xval(1,2);xval(1,2)])
plot([xval(1,1);xd(:,1);xval(1,1)],[xval(1,2);xd(:,2);xval(1,2)],'-r')
title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Reduction (all but best)'})
xlabel('X')
ylabel('Y')
print('Nelder_Mead_7','-dpng')
