%Example using ChebFull to find nodes, get interpolation weights and
%integration weights

clear

f = @(x) x.^2 - x+5;
lb = 0;
ub = 1;

[z_k,a_k,w_k,x_k]=chebfull(f,4,lb,ub)

%Integrate the function from 0 to 1
    %Chebyshev
        sum(w_k.*f(x_k))
    %Matlab
        integral(f,lb,ub)
    %Closed-form
        temp = @(x) (x.^3)/3-(x.^2)/2+5.*x;
        temp(ub)-temp(lb)
    
%Interpolate function from 0 to 1 (I wrote this out only four a
%fourth-degree polynomial)
    f_cheb = @(x) a_k(1).*chebyshevT(0,x) + a_k(2).*chebyshevT(1,x) + a_k(3).*chebyshevT(2,x) + a_k(4).*chebyshevT(3,x)
    
%Graph the two interpolations
    x = linspace(0,1,100);
    plot(x,f_cheb(x),'-k')
    hold on
    plot(x,f(x),'--r')
    scatter(x_k,f_cheb(x_k))

    
