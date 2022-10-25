function out = utility_temp(x,ut_fxn,lambda_now) 
    gamma = 0.95;
    sigma_e = 0.007;
    lambda_min = 0.9;
    lambda_max = 1.1;
    
    utility = ut_fxn;
    out = integral(@(lambdanext) utility(x(1),x(2),lambdanext)*pdf('Normal',lambdanext,(1-gamma)*1+gamma*lambda_now,sigma_e),lambda_min,lambda_max,'ArrayValued',1);
end
