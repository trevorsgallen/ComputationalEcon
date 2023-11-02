clear

x1_space = linspace(-10,10,100);
x2_space = linspace(-10,10,100);

f1 = @(x1,x2) x1^2+x2^2-x1*x2-3
f2 = @(x1,x2) x1^0.5+x2-x2.^2-1

x2_f1_eq_zero = unique([0.5*(x1_space-sqrt(3)*sqrt(4-x1.^2)),0.5*(x1_space+sqrt(3)*sqrt(4-x1.^2))]);
x2_f2_eq_zero = unique([0.5*(1-sqrt(4*sqrt(x1_space)-3)),0.5*sqrt(4*sqrt(x1_space)-3)+1]);

f1_val = f1(x1_space,x2_space);
f2_val = f2(x1_space,x2_space);

surf(x1_space,x2_space,f1_val);
hold on
surf(x1_space,x2_space,f2_val);
hold on
plot3(x1_space,x2_f1_eq_zero,zeros(1,100),'-r');
hold on
plot3(x1_space,x2_f2_eq_zero,zeros(1,100),'-r');

%Find the planes that are tangent to starting point




