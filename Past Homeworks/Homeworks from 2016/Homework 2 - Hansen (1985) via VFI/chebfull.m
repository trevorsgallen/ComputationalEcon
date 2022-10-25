function [x_k,a_k,w_k] = chebfull(f,n)
    
    %Nodes
        x_k = cos(([n-1:-1:0]'+0.5).*pi./n);

    %Interpolation weights
        y = f(x_k);
        T = [zeros(n,1) ones(n,1)];
        c = [sum(y)/n zeros(1,n-1)];
        a = 1;
        for k = 2:n
            T = [T(:,2) a*x_k.*T(:,2)-T(:,1)];
            c(k) = sum( T(:,2).*y)*2/n;
            a=2;
        end
        a_k = c';
        
    %Weights
        N=[1:2:n-1]'; 
        l=length(N); 
        m=n-l; 
        K=[0:m-1]';
        v0=[2*exp(i*pi*K/n)./(1-4*K.^2); zeros(l+1,1)]; 
        v1=v0(1:end-1)+conj(v0(end:-1:2)); 
        w_k=ifft(v1);

end