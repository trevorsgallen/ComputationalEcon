%     A_trend = (A_t(end)./A_t(1)).^(1./(length(A_t)-1));
%     N_trend = (N_t(end)./N_t(1)).^(1./(length(N_t)-1));

    %Give them 30 periods to reach the steady state, then lock in for 30
    %more
    
    %Get the choice in the last period and keep it going
%         for tt = 1:60
%             A_t = [A_t;A_t(end).*A_trend];
%             N_t = [N_t;N_t(end).*N_trend];
%         end
%         for tt = 1:30
%             L = [L;L(end)];
%             K = [K;K(end).*(K(end)./K(end-1))];
%         end


T = length(L_t)
    x0_sto = x0;
x0 = x0.*((exp(rand(length(x0),1))-1)./1000+1)
x0_alt = x0;
for propavg = 1
    psi = [(1-propavg).*psi_full'+propavg.*psi_avg*ones(1,length(psi_full))]';
    beta = [(1-propavg).*beta_full'+propavg.*beta_avg*ones(1,length(beta_full))]';

    focs_temp = @(x) NCG_FOCs(x0(1:T),x0(T+1:end),alpha,delta,beta,psi,A_t,N_t,k0);

    focs_temp(x0);

    x0 = lsqnonlin(focs_temp,x0);
    fopts = optimset('MaxFunEval',1e4,'MaxIter',1e4,'TolX',1e-20,'TolFun',1e-20,'Jacobian','on');
    [x0,FVAL,EXITFLAG] = fsolve(focs_temp,x0,fopts);
%     if EXITFLAG ~= 1
%         asdf
%     end
    max(abs(x0-x0_sto))
end

    focs_temp(x0)
    f_grad


    