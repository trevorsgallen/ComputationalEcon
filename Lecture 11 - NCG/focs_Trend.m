function [focerr,sol] = focs(L,K)

    alpha = 0.7;
    delta = 0.023;
    beta = 0.95;
    psi = 1.75;

    T = length(L);
    A_trend = exp(0.01.*[0:99]');
    A = 1;
    A = [1.01;1.04;1.06;1.08;1.10;1.12;1.14;1.16;1.18;1.2;1.18;1.16;1.14;1.12;1.10;1.08;1.06;1.04;1.02];
    A = [ones(30,1);A;ones(length(L)-length(A)-30,1)];

    A = A.*A_trend;
    
%     K = [0.1.*ones(T+1,1)];
%     L = 0.5.*ones(T,1);

    %Get the choice in the last period and keep it going
        for tt = 1:40
            A = [A;A(end).*(A(end)./A(end-1))];
            L = [L;L(end)];
            K = [K;K(end).*(K(end)./K(end-1))];
        end
        
    %Now create the other series
        Y = A.*(L.^alpha).*(K(1:end-1).^(1-alpha));
        w = alpha.*Y./L;
        r = (1-alpha).*Y./K(1:end-1);
        i = K(2:end)-(1-delta).*K(1:end-1);
        C = Y-i;

        
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