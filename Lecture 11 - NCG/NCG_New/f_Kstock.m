function [error,K,dky,ky] = f_Kstock(K_0,delta,I_t,Y_t,dK_t) 
    for t = 1:length(I_t)+1
        if t == 1
            K(t,1) = K_0;
        else
            K(t,1) = K(t-1,1)*(1-delta)+I_t(t-1);
        end
    end
    error(1) = abs(mean(dK_t./Y_t) - mean(delta.*K(1:end-1)./Y_t));
    error(2) = abs(mean(K(1)./Y_t(1)) - mean(K(2:10)./Y_t(2:10)));
end