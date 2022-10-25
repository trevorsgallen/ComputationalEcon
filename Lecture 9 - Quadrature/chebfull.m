function [z_k,a_k,w_k,x_k] = chebfull(f,n,lb,ub)
    %This function takes in some function f and finds interpolation and
    %integration weights for n Chebyshev nodes, between bounds lb and ub.  

    %Nodes (see course notes)
        z_k = cos(([n-1:-1:0]'+0.5).*pi./n);
        x_k = lb + (ub-lb).*((z_k+1)/2);

    %Interpolation weights (see course notes)
        y = f(z_k);
        
        T = [zeros(n,1) ones(n,1)];
        c = [sum(y)/n zeros(1,n-1)];
        a = 1;
        for k = 2:n
            T = [T(:,2) a*z_k.*T(:,2)-T(:,1)];
            c(k) = sum( T(:,2).*y)*2/n;
            a=2;
        end
        a_k = c';
        
    %Integration Weights (from Waldvogel 2006, BIT Numerical Mathematics)
        N=[1:2:n-1]'; 
        l=length(N); 
        m=n-l; 
        K=[0:m-1]';
        v0=[2*exp(i*pi*K/n)./(1-4*K.^2); zeros(l+1,1)]; 
        v1=v0(1:end-1)+conj(v0(end:-1:2)); 
        w_k=ifft(v1);
        
        %Adjust the weights, which are for an x of length 2. 
            w_k = ((ub-lb)./2).*w_k;

end
