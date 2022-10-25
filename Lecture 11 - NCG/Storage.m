asdf
%Foc's
%     T = length([L_t;L_t(end).*ones(30,1)])
%     x0 = [L_t;L_t(end).*ones(30,1);K_t];
%     for t = 1:30
%         x0 = [x0;x0(end).*(x0(end)./x0(end-1))];
%     end

    x0 = [L_t;K_t(2:end)]
    T = length(L_t);
    focs_temp = @(x) NCG_FOCs(x0(1:T),[k0;x0(T+1:end)],alpha,delta,beta_full,psi_full,A_t,N_t,k0);

    fsolve(focs_temp,x0)
    
    
    for z = 1:10
        [fval,Jval]=focs_temp(x0);
        x0 = x0-0.0001.*diag(Jval);
        sum(abs(fval))
    end

