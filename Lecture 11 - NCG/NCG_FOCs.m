function [focerr,J,sol] = focs(L,K,alpha,delta,beta,psi,A_t,N_t,k0)
        T = length(L);
        A = A_t;
        
    %Now create the other series
        Y = A.*(L.^alpha).*(K(1:end-1).^(1-alpha));
        w = alpha.*Y./L;
        r = (1-alpha).*Y./K(1:end-1);
        i = K(2:end)-(1-delta).*K(1:end-1);
        C = Y-i;
        
        Y(end+1) = A(end).*(L(end-1).^alpha).*(K(end).^(1-alpha));
        C(end+1) = Y(end) - delta.*K(end);
        r(end+1) = (1-alpha).*Y(end)./K(end-1);

        
    %Now take the FOC's
        foc_L = w.*(1-L./N_t)./C(1:end-1) - psi;
        foc_C = (1./(1-delta+r(2:end)).*(C(2:end)./C(1:end-1))) - [beta;beta(end)];

        focerr = [foc_C;foc_L];
        
        
    d = 1e-7;
    for ind = 1:(length([L;K])-1)
        ind;
        L_alt = L;
        K_alt = K;
        if ind <= T
            L_alt(ind) = L_alt(ind) + d;
        elseif ind > T
            K_alt(ind+1-T) = K_alt(ind+1-T) + d;
        end
        
        T = length(L);
        A_alt = A_t;
        
    %Now create the other series
        Y_alt = A_alt.*(L_alt.^alpha).*(K_alt(1:end-1).^(1-alpha));
        w_alt = alpha.*Y_alt./L_alt;
        r_alt = (1-alpha).*Y_alt./K_alt(1:end-1);
        i_alt = K_alt(2:end)-(1-delta).*K_alt(1:end-1);
        C_alt = Y_alt-i_alt;

        Y_alt(end+1) = A_alt(end).*(L_alt(end-1).^alpha).*(K_alt(end).^(1-alpha));
        C_alt(end+1) = Y_alt(end) - delta.*K_alt(end);
        r_alt(end+1) = (1-alpha).*Y_alt(end)./K_alt(end-1);

    %Now take the FOC's
        foc_L_alt = w_alt.*(1-L_alt./N_t)./C_alt(1:end-1) - psi;
        foc_C_alt = (1./(1-delta+r_alt(2:end)).*(C_alt(2:end)./C_alt(1:end-1))) - [beta;beta(end)];

        focerr_alt = [foc_C_alt;foc_L_alt];
        J(:,ind) = [focerr - focerr_alt]./d;
    end
sol = NaN;
%     sol = [[A;A(end);NaN],[L;L(end);NaN],K(1:end),[Y;NaN],[w;alpha.*Y(end)./K(end-1);NaN],[r;NaN],[i;delta.*K(end);NaN],[C;NaN]];
end