function error = calibrator(psi,w,nu)
    target = 0.2;
    utilityfxn_temp = @(L) -utilityfxn(L,w,nu,psi)
    [L_star,ut_star] = fminunc(utilityfxn_temp,0.3)
    
    error = (L_star-target).^2 + (C_star-Ctarget).^2
end