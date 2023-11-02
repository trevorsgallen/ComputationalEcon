clear

[x1_grid,x2_grid] = meshgrid(linspace(3.2-5,3.2+5,100),linspace(-0.2-5,-0.2+5,100));
f = @(x) 3*(x(:,1)-3).^2+0.5.*(x(:,2)-2).^2+x(:,1).*x(:,2)-x(:,1)-x(:,2);
grad = @(x) [2*3*(x(:,1)-3)+x(:,2)-1, ...
                 (x(:,2)-2)+x(:,1)-1]
fminunc(@(x)f(x),[1,1])


%Basic Figure
figure(1)
surf(x1_grid,x2_grid,reshape(f([reshape(x1_grid,[],1),reshape(x2_grid,[],1)]),100,100))
hold on

%Starting point, search direction
x0 = [6,-4];
g0 = grad(x0);

asdf
g0 = f(x0)-S0*x0';
% a1 = (g0'*g0)./

%New point, Newton's method
    
figure(1)
scatter3(x0(1),x0(2),f(x0),'r','filled')
hold on
scatter3(x0(1),x0(2),f(x0),'r','filled')

