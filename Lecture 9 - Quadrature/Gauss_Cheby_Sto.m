    %Gauss-Chebyshev Quadrature
%             ivec = [1:n]';
%             f_x = @(x) f(x).*sqrt(1-x.^2);
%             x_i = cos(pi.*(2.*ivec-1)./(2.*n));
%             w_i = pi./n;
%             'Gauss-Chebyshev'
%             temp2 = (sum(w_i.*f_x(x_i)));
