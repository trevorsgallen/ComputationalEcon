function [focerr,sol] = focs(L,K,A,alpha,delta,beta,psi)

    L = real(L);
    K = real(K);
    
%     alpha = 0.7;
%     delta = 0.042975457000307;
%     beta = 0.962771519961167;
%     psi = 4.58250412801473;
    
    T = length(L);

  %Find long-difference trend and continue for 80 more periods
      A_trend = (A(end)./A(end-20)).^(1./20);
      for ind = 1:80
          A(end+1,1) = A(end).*A_trend;
%           psi(end+1,1) = psi(end);
%           beta(end+1,1) = beta(end).*A_trend;
      end
      
  %True data lasts for 48 periods.  Fill in for 52 more periods and allow
  %agents to solve for all 100 periods.  Then, add 40 more periods to
  %ensure that the 52 periods converge to a SS growth path.

    %Get the choice in the last period and keep it going for 40 more
        for tt = 1:80
            L = [L;L(end)];
            K = [K;K(end).*(K(end)./K(end-1))];
        end
        
    %Now create the other series
        Y = A.*((L).^alpha).*(K(1:end-1).^(1-alpha));
        w = alpha.*Y./(L);
        r = (1-alpha).*Y./K(1:end-1);
        i = (K(2:end)-(1-delta).*K(1:end-1));
        C = (Y-i);

        
    %Now take the FOC's for all periods (141 periods)
        foc_L = psi - (1-L).*(w./C);
        foc_C = (C(2:end)./C(1:end-1)) - beta.*(1-delta+r(2:end));

        focerr = [foc_C;foc_L];
        sum(focerr.^2);

    sol = [[A;NaN],[L;NaN],K(1:end),[Y;NaN],[w;NaN],[r;NaN],[i;NaN],[C;NaN]];

end