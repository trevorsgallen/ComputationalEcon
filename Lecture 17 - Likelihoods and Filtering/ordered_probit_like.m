function objective = ordered_probit_like3...
    (g,eld,ffrac,landv,lnhdd,ngrw,octy,opop,pgrw,pinc,tpop,tire)

N = length(tire);
alpha = g(1:5);%5
beta = g(6:9);%4
gamma = g(10:15);%6
lambda = g(16:19);%4
l = zeros(6,1);

for k = 0:5
    if k == 0  
        i = find(tire==k); %find indeces for tire=0
        S = tpop(i)+lambda(1)*opop(i)+lambda(2)*ngrw(i)+lambda(3)*pgrw(i)+lambda(4)*octy(i);
        V1 = alpha(1)+ [eld(i), pinc(i), lnhdd(i), ffrac(i)]* beta;
        F1 = gamma(1)+gamma(6)*landv(i);
%         pi_bar1 = S.*V1-F1;
        l(k+1) = sum(log(1-normcdf(S.*V1-F1)));
        
    elseif k > 0 & k <5
        i = find(tire==k); %indeces for tire=k
        S = tpop(i)+lambda(1)*opop(i)+lambda(2)*ngrw(i)+lambda(3)*pgrw(i)+lambda(4)*octy(i);
        V1 = 2*alpha(1)+ [eld(i), pinc(i), lnhdd(i), ffrac(i)]* beta - sum(alpha(1:k));
        F1 = sum(gamma(1:k))+ gamma(6)*landv(i);
%         pi_bar1 = S.*V1-F1;
        
        V2 = 2*alpha(1)+ [eld(i), pinc(i), lnhdd(i), ffrac(i)]* beta -sum(alpha(1:k+1));
        F2 = sum(gamma(1:k+1)) +gamma(6)*landv(i);
%         pi_bar2 = S.*V2-F2;
        l(k+1) = sum(log(normcdf(S.*V1-F1)-normcdf(S.*V2-F2)));
        
    else
        i = find(tire>=k); %indeces for tire=k
        S = tpop(i)+lambda(1)*opop(i)+lambda(2)*ngrw(i)+lambda(3)*pgrw(i)+lambda(4)*octy(i);
        V1 = 2*alpha(1)+ [eld(i), pinc(i), lnhdd(i), ffrac(i)]* beta - sum(alpha);
        F1 = sum(gamma(1:k))+ gamma(6)*landv(i);
%         pi_bar1 = S.*V1-F1;
        l(k+1) = sum(log(normcdf(S.*V1-F1)));
            
    end
end
   
objective = -sum(l); %sum(l) is log likelihood function