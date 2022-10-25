function LLik = BR(beta,alpha,gamma,lambda,TIRE,P_1,P_2,P_3,P_4,P_5,P_6);
        
    ind_0 = find(TIRE==0);
    ind_1 = find(TIRE==1);
    ind_2 = find(TIRE==2);
    ind_3 = find(TIRE==3);
    ind_4 = find(TIRE==4);
    ind_5 = find(TIRE>=5);

    temp0 = P_1(beta,alpha,gamma,lambda);
    temp1 = P_2(beta,alpha,gamma,lambda);
    temp2 = P_3(beta,alpha,gamma,lambda);
    temp3 = P_4(beta,alpha,gamma,lambda);
    temp4 = P_5(beta,alpha,gamma,lambda);
    temp5 = P_6(beta,alpha,gamma,lambda);
    
    temp0(isinf(temp0)) = -1e7;
    temp1(isinf(temp1)) = -1e7;
    temp2(isinf(temp2)) = -1e7;
    temp3(isinf(temp3)) = -1e7;
    temp4(isinf(temp4)) = -1e7;
    temp5(isinf(temp5)) = -1e7;

    LLik = -(sum(temp0(ind_0))+sum(temp1(ind_1)) + sum(temp2(ind_2)) + sum(temp3(ind_3)) +...
        +sum(temp4(ind_4)) + sum(temp5(ind_5)))
end
