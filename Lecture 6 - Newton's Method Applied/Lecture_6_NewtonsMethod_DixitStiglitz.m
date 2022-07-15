clear
sigma = 3.03;
rho = (sigma-1)./sigma;
I = 1;
nu = 1;
phi = 1;
    
%Dixit-Stiglitz: c C p P N pi
    %Idiosyncratic demand function
        f_1 = @(c,p,P,I,sigma) c    -    ((I.*(p.^(-sigma)))./(P.^(1-sigma)));
    %Profit function
        f_2 = @(pi,p,c,phi,nu) pi    -    (p.*c - phi.*c - nu);
    %Price markup
        f_3 = @(p,phi,rho) p    -    phi./rho;
    %Total quantity
        f_4 = @(C,c,N,rho) C    -    c.*N.^(1./rho);
    %Aggregate price
        f_5 = @(P,p,N,rho) P    -    p.*N.^((rho-1)./rho)
    %Profit is zero
        f_6 = @(pi) pi    -    0;
        
    f_focs = @(c,C,p,P,N,pi,sigma,I,rho,nu,phi) [f_1(c,p,P,I,sigma);f_2(pi,p,c,phi,nu);f_3(p,phi,rho);f_4(C,c,N,rho);f_5(P,p,N,rho);f_6(pi)];

    %Set some exogenous parameters
%         sigma_temp = 3;
%         rho_temp = (sigma_temp-1)./sigma_temp;
%         I_temp = 1;
%         nu_temp = 1;
%         phi_temp = 1;

    x0 = [                       1.8
         0.405720411922146
                       1.4
          2.46475150877325
         0.370370369893551
                         0];
                     
    %Define the function as an input of only exogneous parameters
        %Also, note that the FUNCTIONS are VERTICAL!
        f_temp = @(x) f_focs(x(1,:),x(2,:),x(3,:),x(4,:),x(5,:),x(6,:),sigma,I,rho,nu,phi)
    
    %Define Jacobian
        d = 1e-6;
        f_J = @(x) ((f_temp(repmat(x,1,6)+diag(ones(1,6).*d)))-(f_temp(repmat(x,1,6))))./d
        
    %Newton's Method
       error = 1
        while error > 1e-10
            x0 = x0-inv(f_J(x0))*f_temp(x0)
            error = max(abs(f_temp(x0)))
        end
    
    %Compare to the real solution
        x0_true = [    2.03
                    0.38805
                        1.4926
                    2.57698
                    1./3.03
                         0];
     %Newton vs. true error:
        [x0,x0_true,x0-x0_true]
        
        x0
        
    %Can alternatively use fsolve, which does all this for you!
    tic
        [fsol_x,fsol_fval,fsol_exitflag,~,fsol_jac] = fsolve(f_temp,[1.8 ; 0.405720411922146 ; 1.4 ; 2.46475150877325 ; 0.370370369893551 ; 0])
toc
    %Compare computer-generated jacobian (fsol_jac) to our own at solution
        fsol_jac-f_J(x0)

    %Could also square the problem and minimize it
        f_temp2 = @(x) sum(f_temp(x).^2)
        tic
        [fmin_x]=fminunc(f_temp2,[1.8 ; 0.405720411922146 ; 1.4 ; 2.46475150877325 ; 0.370370369893551 ; 0])
        toc
        table(x0,x0_true,fsol_x,fmin_x,'VariableNames',{'SelfSol','Truth','Fsolve','Fmin'})
        
