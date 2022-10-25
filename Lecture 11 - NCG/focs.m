function [focerr,sol] = focs(L,K)

%     alpha = 0.7;
%     delta = 0.023;
%     beta = 0.95;
%     psi = 1.75;

    T = length(L);
%     A = [1.01;1.02;1.03;1.04;1.05;1.06;1.07;1.08;1.09;1.1;1.09;1.08;1.07;1.06;1.05;1.04;1.03;1.02;1.01];
% %     A = 1;
%     A = [ones(30,1);A;ones(length(L)-length(A)-30,1)];
    
%     K = [0.1.*ones(T+1,1)];
%     L = 0.5.*ones(T,1);

    %Get the choice in the last period and keep it going
        A = [A;A(end).*ones(40,1)];
        L = [L;L(end).*ones(40,1)];
        K = [K;K(end).*ones(40,1)];
        
    %Now create the other series
        Y = A.*(L.^alpha).*(K(1:end-1).^(1-alpha));
        w = alpha.*Y./L;
        r = (1-alpha).*Y./K(1:end-1);
        i = K(2:end)-(1-delta).*K(1:end-1);
        C = Y-i;

        
    %Labor gets a fraction of marginal product (markup)

        
    %Now take the FOC's
        foc_L = psi*C./(1-L) - w;
        foc_C = (C(2:end)./C(1:end-1)) - beta*(1-delta+r(1:end-1));

%         foc_C = (([w(2:end);w(end)].*[L(2:end);L(end)] + (1-delta+[r(2:end);r(end)]).*[K(2:end)] - [K(3:end);K(end)])./(w.*L + (1-delta+r).*K(1:end-1) - [K(2:end)])) - beta.*(1-delta+[r(2:end);r(end)]);
%         foc_L = psi./(1-L) - w./(w.*L + (1-delta+r).*K(1:end-1) - K(2:end));

        focerr = [foc_C;foc_L];
        sum(focerr.^2)
%         focerr = sum(focerr.^2)

    sol = [[A;NaN],[L;NaN],K(1:end),[Y;NaN],[w;NaN],[r;NaN],[i;NaN],[C;NaN]];

end