function [err,choice,Y] = gmmmom(theta,x,Y)

%Note the different random number generator
    rng(1)
    
    psi_1 = theta(1);
    psi_2 = theta(2);
    psi_3 = theta(3);
    sigma2 = theta(4);

    error = sqrt(sigma2).*randn(length(x),4);
    U = @(P_1,P_2) psi_1*P_1+x(:,1).*psi_2*P_2+psi_3.*x(:,2).*P_1.*P_2;
    
    U_choices = [U(0,0),U(1,0)+error(:,2),U(0,1)+error(:,3),U(1,1)+error(:,4)];
    best = max(U_choices')';
    choice = 1.*(U_choices(:,1)==best)+2.*(U_choices(:,2)==best)+3.*(U_choices(:,3)==best)+4.*(U_choices(:,4)==best);

    W = eye(length(choice));
    err = ((choice==Y)-1)'*W*((choice==Y)-1);
    
end