function error = calibrator(psi,w,nu,Ltarget)
    [L_star,ut_star] = fminunc(@(L)utilityfxn(L,w,nu,psi),0.3)
    [utility,C_star] = utilityfxn(L_star,w,nu,psi)
    error = (L_star-Ltarget).^2;
end