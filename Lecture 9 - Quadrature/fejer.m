function [wf1,wf2,wcc] = fejer(n)

f = @(x) x.^2;

n = 5
% Weights of the Fejer2, Clenshaw-Curtis and Fejer1 quadratures by DFTs % n>1. Nodes: x_k = cos(k*pi/n)
    x_k = cos([0:n]'*pi/n)
    N=[1:2:n-1]'; 
    l=length(N); 
    m=n-l; 
    K=[0:m-1]';

% Fejer2 nodes: k=0,1,...,n; weights: wf2, wf2_n=wf2_0=0 
    v0=[2./N./(N-2);  1/N(end); zeros(m,1)]; 
    v2=-v0(1:end-1)-v0(end:-1:2); 
    wf2=ifft(v2);

%Clenshaw-Curtis nodes: k=0,1,...,n; weights: wcc, wcc_n=wcc_0 
    g0=-ones(n,1); 
    g0(1+l)=g0(1+l)+n; 
    g0(1+m)=g0(1+m)+n; 
    g=g0/(n^2-1+mod(n,2)); 
    wcc=ifft(v2+g);
    
% Fejer1 nodes: k=1/2,3/2,...,n-1/2; vector of weights: wf1 
    v0=[2*exp(i*pi*K/n)./(1-4*K.^2); zeros(l+1,1)]; 
    v1=v0(1:end-1)+conj(v0(end:-1:2)); 
    wf1=ifft(v1);

end