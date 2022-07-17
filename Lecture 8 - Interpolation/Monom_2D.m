clear
close all

f = @(x,y) (1./(((x.^2+1)).*(1+y.^2)))
a = -3;
b = 3;
c = -3;
d = 3;

n = 20;

T_0 = @(x) 1.*isnan(x./x)+1.*(1-isnan(x./x));
T_1 = @(x) x;

for z = 2:n+1
    eval(['T_',num2str(z),' = @(x) x.^',num2str(z)])
end

%First, define Chebychev nodes (roots)
    x_space = linspace(a,b,n);
    y_space = linspace(c,d,n);
    [x_grid,y_grid] = meshgrid(x_space,y_space);
    
    x_grid = reshape(x_grid,[],1);
    y_grid = reshape(y_grid,[],1);
    
    x_space_enhanced = linspace(a,b,100);
    y_space_enhanced = linspace(c,d,100);
    [x_grid_enhanced,y_grid_enhanced] = meshgrid(x_space_enhanced,y_space_enhanced);
    
    %1-D
        X = [ones(length(x_grid),1)]
        Y = f(x_grid,y_grid);
        beta = inv(X'*X)*X'*Y;
%         Y_fit = reshape(beta*X,n,n);
        Y = reshape(Y,n,n);
        f_fit = @(x,y) beta.*ones(length(x),length(y));
        
        figure(1)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced));
        shading flat
        alpha(.4)
        hold on
        surf(x_grid_enhanced,y_grid_enhanced,f_fit(x_grid_enhanced,y_grid_enhanced))
        shading interp
        alpha(.4)
        scatter3(x_grid,y_grid,reshape(f_fit(reshape(x_grid,n,n),reshape(y_grid,n,n)),[],1),'k','filled')
        print('Monom_2D_1','-dpng')
        
        figure(2)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced)-f_fit(x_grid_enhanced,y_grid_enhanced));
        shading flat
        print('Monom_2D_1_err','-dpng')


    %2-D
        X = [ones(length(x_grid),1),x_grid,y_grid]
        Y = f(x_grid,y_grid);
        beta = inv(X'*X)*X'*Y;
        Y_fit = reshape(X*beta,n,n);
        Y = reshape(Y,n,n);
        f_fit = @(x,y) beta(1).*ones(length(x),length(y))+beta(2).*x + beta(3).*y;

        figure(3)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced));
        shading flat
        alpha(.4)
        hold on
        surf(x_grid_enhanced,y_grid_enhanced,f_fit(x_grid_enhanced,y_grid_enhanced))
        shading interp
        alpha(.4)
        scatter3(x_grid,y_grid,reshape(f_fit(reshape(x_grid,n,n),reshape(y_grid,n,n)),[],1),'k','filled')
        print('Monom_2D_2','-dpng')
        
        figure(4)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced)-f_fit(x_grid_enhanced,y_grid_enhanced));
        shading flat
        print('Monom_2D_2_err','-dpng')


    %3-D
        X = [ones(length(x_grid),1),x_grid,y_grid,x_grid.^2,x_grid.*y_grid,y_grid.^2]
        Y = f(x_grid,y_grid);
        beta = inv(X'*X)*X'*Y;
        Y_fit = reshape(X*beta,n,n);
        Y = reshape(Y,n,n);
        f_fit = @(x,y) beta(1).*ones(length(x),length(y))+beta(2).*x + beta(3).*y + beta(4).*x.^2+beta(5).*x.*y + beta(6).*y.^2;

        figure(5)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced));
        shading flat
        alpha(.4)
        hold on
        surf(x_grid_enhanced,y_grid_enhanced,f_fit(x_grid_enhanced,y_grid_enhanced))
        shading interp
        alpha(.4)
        scatter3(x_grid,y_grid,reshape(f_fit(reshape(x_grid,n,n),reshape(y_grid,n,n)),[],1),'k','filled')
        print('Monom_2D_3','-dpng')
        
        figure(6)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced)-f_fit(x_grid_enhanced,y_grid_enhanced));
        shading flat
        print('Monom_2D_3_err','-dpng')
        
    %4-D
        X = [ones(length(x_grid),1),x_grid,y_grid,x_grid.^2,x_grid.*y_grid,y_grid.^2 , x_grid.^3 , (x_grid.^2).*(y_grid.^1) , (x_grid.^1).*(y_grid.^2) , (x_grid.^0).*(y_grid.^3)];
        Y = f(x_grid,y_grid);
        beta = inv(X'*X)*X'*Y;
        Y_fit = reshape(X*beta,n,n);
        Y = reshape(Y,n,n);
        f_fit = @(x,y) beta(1).*ones(length(x),length(y))+beta(2).*x + beta(3).*y + beta(4).*x.^2+beta(5).*x.*y + beta(6).*y.^2  + beta(7).*x.^3 + beta(8).*x.^2.*y.^1 + beta(9).*x.^1.*y.^2 + beta(10).*y.^3;

        figure(7)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced));
        shading flat
        alpha(.4)
        hold on
        surf(x_grid_enhanced,y_grid_enhanced,f_fit(x_grid_enhanced,y_grid_enhanced))
        shading interp
        alpha(.4)
        scatter3(x_grid,y_grid,reshape(f_fit(reshape(x_grid,n,n),reshape(y_grid,n,n)),[],1),'k','filled')
        print('Monom_2D_4','-dpng')
        
        figure(8)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced)-f_fit(x_grid_enhanced,y_grid_enhanced));
        shading flat
        print('Monom_2D_4_err','-dpng')
        
    %5-D
        X = [ones(length(x_grid),1),x_grid,y_grid,x_grid.^2,x_grid.*y_grid,y_grid.^2 , x_grid.^3 , (x_grid.^2).*(y_grid.^1) , (x_grid.^1).*(y_grid.^2) , (x_grid.^0).*(y_grid.^3) , (x_grid.^4).*(y_grid.^0) , (x_grid.^3).*(y_grid.^1) , (x_grid.^2).*(y_grid.^2) , (x_grid.^1).*(y_grid.^3) , (x_grid.^0).*(y_grid.^4)]
        Y = f(x_grid,y_grid);
        beta = inv(X'*X)*X'*Y;
        Y_fit = reshape(X*beta,n,n);
        Y = reshape(Y,n,n);
        f_fit = @(x,y) beta(1).*ones(length(x),length(y))+beta(2).*x + beta(3).*y + beta(4).*x.^2+beta(5).*x.*y + beta(6).*y.^2  + beta(7).*x.^3 + beta(8).*x.^2.*y.^1 + beta(9).*x.^1.*y.^2 + beta(10).*y.^3 + beta(11).*x.^4.*y.^0  + beta(12).*x.^3.*y.^1  + beta(13).*x.^2.*y.^2  + beta(14).*x.^1.*y.^3  + beta(15).*x.^0.*y.^4;

        figure(9)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced));
        shading flat
        alpha(.4)
        hold on
        surf(x_grid_enhanced,y_grid_enhanced,f_fit(x_grid_enhanced,y_grid_enhanced))
        shading interp
        alpha(.4)
        scatter3(x_grid,y_grid,reshape(f_fit(reshape(x_grid,n,n),reshape(y_grid,n,n)),[],1),'k','filled')
        print('Monom_2D_5','-dpng')
        
        figure(10)
        surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced)-f_fit(x_grid_enhanced,y_grid_enhanced));
        shading flat
        print('Monom_2D_5_err','-dpng')


