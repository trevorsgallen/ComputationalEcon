clear

%Lognormal parameters
    mu = 0.1;
    sigma = 0.75;

%Bounds
    a = 0;
    b = 5;
    
%Number of points
    n = 10;
    
%Translate x to z and back again
    xtoz_fxn = @(x) 2.*(x-a)./(b-a)-1;
    ztox_fxn = @(z) (1./2).*(a+b-a.*z+b.*z);
        
%Function in terms of z and x, for convenience
    f_z = @(x) ztox_fxn(x).*pdf('lognormal',ztox_fxn(x),mu,sigma);
    f_x = @(x) x.*pdf('lognormal',x,mu,sigma);

%Find the points, interpolation weights, integration weights
    [z_k,a_k,w_k] = chebfull(f_z,n,a,b)
    x_k = ztox_fxn(z_k)

%Define approximating function (interpolation weights & values)
    f_approx = @(x) (a_k(1) + sum(repmat(a_k(2:end),1,length(x)).*cos((repmat([1:n-1]',1,length(x)).*repmat(acos(xtoz_fxn(x)),n-1,1)))));

%Graph it out
    x_enh = [a:0.001:b];

    figure(1)
    plot(x_enh,f_x(x_enh))
    hold on
    plot(x_k,f_approx(x_k'),'--r')
    hold on
    plot(x_enh,f_approx(x_enh),'--k')
    scatter(x_k,f_x(x_k))

%Fejer's rule/Clenshaw-Curtis type
    temp1 = sum(f_x(x_k).*w_k);

%Matlab's built-in integrator (adaptive quadrature...keep adding points).
    %For more, see Shampine 2006, Journal of Computational and Applied
    %Economics
    temp3 = integral(f_x,a,b);

    [temp1,temp3]
        
        