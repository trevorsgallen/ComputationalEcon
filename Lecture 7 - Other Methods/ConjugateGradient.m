clear
close all
a=1;
b=2;
d = 1e-4;
gamma = 0.1;

f = @(x,y) (a-x).^2 + b.*(y-x.^2).^2;

f_x = @(x,y) -2.*(a-x) -2.*x.*2.*b.*(y-x.^2);
f_y = @(x,y) 2.*b.*(y-x.^2);

f_xx = @(x,y) 2 -4.*b.*(y-3.*x.^2);
f_xy = @(x,y) -2.*x.*2.*b
f_yy = @(x,y) 2.*b;


%f = @(x,y) (x-a).^2+(y-b).^2;

x0 = [1.99;-0.99];

x_NR = x0;

xval = x0;

for i = 1:100000
    i
    %Gradient Descent
        dX = [(f(xval(1,i)+d,xval(2,i))-f(xval(1,i),xval(2,i)))/d ; (f(xval(1,i),xval(2,i)+d)-f(xval(1,i),xval(2,i)))/d];
        gamma = 0.01;
        x0 = x0-gamma.*dX;
        xval = [xval,x0];
    
    
    %Newton-Raphson
        x = x_NR(:,end);
        (f(x(1)+d,x(2))-2.*f(x(1),x(2))+f(x(1)-d,x(2)))/(d.^2);
        
        H = [(f(x(1)+d,x(2))-2.*f(x(1),x(2))+f(x(1)-d,x(2)))/(d.^2)  , (f(x(1)+d,x(2)+d)-f(x(1)+d,x(2)-d)-f(x(1)-d,x(2)+d)+f(x(1)-d,x(2)-d))/(4.*(d.^2)) ;  (f(x(1)+d,x(2)+d)-f(x(1)+d,x(2)-d)-f(x(1)-d,x(2)+d)+f(x(1)-d,x(2)-d))/(4.*(d.^2)) , (f(x(1),x(2)+d)-2.*f(x(1),x(2))+f(x(1),x(2)-d))/(d.^2)];        
        G = [(f(x(1)+d,x(2))-f(x(1)-d,x(2)))/(2*d) ; (f(x(1),x(2)+d)-f(x(1),x(2)-d))/(2*d)];
        G_alt = [f_x(x(1),x(2));f_y(x(1),x(2))];

        H_alt = [f_xx(x(1),x(2)),f_xy(x(1),x(2)) ; f_xy(x(1),x(2)) , f_yy(x(1),x(2))];
        
        xnext = x-0.001.*inv(H)*G; 
        x_NR = [x_NR,xnext];
end
xval

x_space = linspace(-1,3,51);
y_space = linspace(0,3,50);
[Y,X] = meshgrid(x_space,y_space);
Z = f(X,Y);


contour(X,Y,Z,100)
hold on
plot(xval(1,:),xval(2,:))
hold on
plot(x_NR(1,:),x_NR(2,:))
scatter(a,sqrt(a),'r','filled')

    