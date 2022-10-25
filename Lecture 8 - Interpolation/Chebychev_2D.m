for nn = 1:10
    clear -nn
    close all
    % f = @(x,y) cos(3*x)+x+y.^2-2.*y+x.*y;
%     f = @(x,y) 2+x-1/3.*y+x.*y+10.*sin(x)
    f = @(x,y) (1./(((x.^2+1)).*(1+y.^2)))
 a = -3;
b = 3;
c = -3;
d = 3;


    n = nn;

    T_0 = @(x) 1.*isnan(x./x)+1.*(1-isnan(x./x));
    T_1 = @(x) x;

    for x = 2:n+1
        eval(['T_',num2str(x),' = @(x) 2.*x.*T_',num2str(x-1),'(x)- T_',num2str(x-2),'(x)'])
    end

    %First, define Chebychev nodes (roots)
        k = [1:n];
        z1_space = -cos((2.*k-1)./(2.*n)*pi)';
        z2_space = -cos((2.*k-1)./(2.*n)*pi)';

        [z1_grid,z2_grid] = meshgrid(z1_space,z2_space);

        x_space = a+(b-a).*(z1_space+1)./2;
        y_space = c+(d-c).*(z2_space+1)./2;

        x_grid = a+(b-a).*(z1_grid+1)./2;
        y_grid = c+(d-c).*(z2_grid+1)./2;

    %     [x_grid,y_grid] = meshgrid(x_space,y_space);

        x_space_enhanced = linspace(a,b,100);
        y_space_enhanced = linspace(c,d,100);

        [x_grid_enhanced,y_grid_enhanced] = meshgrid(x_space_enhanced,y_space_enhanced);

    %     a(0+1,0+1) = sum(sum(f(x_grid,y_grid).*T_0(z1_grid).*T_0(z2_grid)))./((sum(T_0(z1_space).^2).*sum(T_0(z2_space).^2)));
    %     a(1+1,0+1) = sum(sum(f(x_grid,y_grid).*T_1(z1_grid).*T_0(z2_grid)))./((sum(T_1(z1_space).^2).*sum(T_0(z2_space).^2)));
    %     a(0+1,1+1) = sum(sum(f(x_grid,y_grid).*T_0(z1_grid).*T_1(z2_grid)))./((sum(T_0(z1_space).^2).*sum(T_1(z2_space).^2)));
    %     a(1+1,1+1) = sum(sum(f(x_grid,y_grid).*T_1(z1_grid).*T_1(z2_grid)))./((sum(T_1(z1_space).^2).*sum(T_1(z2_space).^2)));
    %     f_approx = @(z1,z2) a(1,1).*T_0(z1).*T_0(z2)+a(1,2).*T_0(z1).*T_1(z2)+a(2,1).*T_1(z1).*T_0(z2)+a(2,2).*T_1(z1).*T_1(z2)
    %     f_approx(z1_grid,z2_grid)
    %     f(z1_grid,z2_grid)

        for i = 0:n-1
            for j = 0:n-1
    %             eval(['a(i+1,j+1) = sum(sum(f(x_grid,y_grid).*T_',num2str(i),'(z1_grid).*T_',num2str(j),'(z2_grid)))./((sum(sum(T_',num2str(i),'(z1_space).^2)).*sum(sum(T_',num2str(j),'(z2_space).^2))))']);
                  eval(['coe(i+1,j+1) = sum(sum(f(x_grid,y_grid).*T_',num2str(i),'(z1_grid).*T_',num2str(j),'(z2_grid)))./((sum(T_',num2str(i),'(z1_space).^2).*sum(T_',num2str(j),'(z2_space).^2)))'])
            end
        end




    f_approx = @(x,y) 0;
        for i = 0:n-1
            for j = 0:n-1
                 eval(['f_approx = @(x,y) f_approx(x,y) + coe(i+1,j+1).*T_',num2str(i),'(2.*(x-a)./(b-a)-1).*T_',num2str(j),'(2.*(y-c)./(d-c)-1)']);
            end
        end
    % 
        f_approx(z1_grid,z2_grid)
        f(x_grid,y_grid)

    figure(1)
    surf(x_grid_enhanced,y_grid_enhanced,f_approx(x_grid_enhanced,y_grid_enhanced))
    shading flat
    alpha(0.4)
    hold on
    surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced))
    shading flat
    alpha(0.4)
    scatter3(reshape(x_grid,[],1),reshape(y_grid,[],1),reshape(f_approx(x_grid,y_grid),[],1),'k','filled')
    shading flat
    eval(['title(''(1./(((x.^2+1)).*(1+y.^2))) and Chebychev fit: n=',num2str(n),' '') '])
    eval(['print(''Cheby_2D_',num2str(n),''',''-dpng'')'])

    figure(2)
    surf(x_grid_enhanced,y_grid_enhanced,f(x_grid_enhanced,y_grid_enhanced)-f_approx(x_grid_enhanced,y_grid_enhanced))
    shading flat
    eval(['title(''Chebychev fit errors for (1./(((x.^2+1)).*(1+y.^2))): n=',num2str(n),''')'])
    eval(['print(''Cheby_2D_Err',num2str(n),''',''-dpng'')'])

end