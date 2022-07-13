clear

x_space = [0:0.01:5];

%Method 1
    %Write in your own points, then smooth
    X = [0,1,2,3,4,5];
    Y = [0,1,1.9,2.5,1,0.1]

    plot(x_space,interp1(X,Y,x_space,'spline'))
    hold on
    scatter(X,Y)
    set(gca,'XtickLabel',[],'YtickLabel',[])

%Method 2
    %You have the statistical distribution, use it
        plot(x_space,pdf('F',x_space,100,1))
        hold on
        plot(x_space,pdf('F',x_space,20,20))
        plot(x_space,pdf('F',x_space,40,40))
        set(gca,'XtickLabel',['\beta_1',[],'x'],'YtickLabel',[])
        title('Sampling Distributions')
        
%Method 3
    %You have the function, graph it
        mu = 3
        f = @(x) 1./(sqrt(2*pi*1)).*exp(-((x-mu).^2)./(2.*1));
        plot(x_space,f(x_space))
