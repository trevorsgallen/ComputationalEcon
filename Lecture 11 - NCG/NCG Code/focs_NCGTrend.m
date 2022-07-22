function [focerr,sol] = focs(L,K)

    alpha = 0.7;
    delta = 0.042975457000307;
    beta = 0.962771519961167;
    psi = 4.58250412801473;
    
    T = length(L);

    %Bad code!  Directly put in A's.  BAD!
          A = [          3048.59278816936
          3133.10876150464
          3149.74144907733
          3146.36806336292
          3227.64223486176
          3304.69562568644
          3380.96241571386
          3325.47189243272
          3341.90812123793
          3422.33504985642
          3460.22091092843
          3523.29218702785
          3534.64171387178
          3496.43169438213
          3541.63062310667
          3466.56783327249
          3545.36617832305
          3645.76764610857
          3709.55453954436
          3751.53531192788
          3767.01514205009
          3820.85647035981
          3849.93696203358
          3876.29566778789
          3877.58379150967
          3962.73444148618
          3984.36199275952
          4030.62859844643
          4047.72512433445
          4133.52084916331
          4190.16877069208
          4281.39972487728
          4377.46316153559
          4437.21686603442
            4457.075419752
          4501.87594840429
          4567.94313291228
          4651.68610090303
          4702.63898217375
          4707.84144514755
          4706.04843991339
          4670.60687201699
          4669.63588262134
          4766.87172977585
          4781.19278868699
          4794.25070119148
          4803.61730478896
          4819.99724968175];

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