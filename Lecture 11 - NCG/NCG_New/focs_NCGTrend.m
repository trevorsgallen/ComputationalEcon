function [focerr,sol] = focs(L,K,parms)

%Unpack parameters and A series
    A = parms.A;
    alpha = parms.alpha;
    delta = parms.delta;
    beta = parms.beta;
    psi = parms.psi;
    
    T = length(L);

  %Find long-difference trend and continue for many periods
      A_trend = (A(end)./A(end-20)).^(1./20);
      for ind = 1:100-48
          A(end+1) = A(end).*A_trend;
      end
      
  %True data lasts for 48 periods.  Fill in for 52 more periods and allow
  %agents to solve for all 100 periods.  Then, add 40 more periods to
  %ensure that the 52 periods converge to a SS growth path.

    %Get the choice in the last period and keep it going for 40 more
        for tt = 1:40
            A = [A;A(end).*(A(end)./A(end-1))];
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
        foc_C = (C(2:end)./C(1:end-1)) - beta*(1-delta+r(1:end-1));

        focerr = [foc_C;foc_L];
        sum(focerr.^2);

    sol = [[A;NaN],[L;NaN],K(1:end),[Y;NaN],[w;NaN],[r;NaN],[i;NaN],[C;NaN]];

end