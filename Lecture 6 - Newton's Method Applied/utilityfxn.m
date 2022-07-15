function [utility,C] = utilityfxn(L,w,nu,psi)
    L
    C = w*L+nu;    
    %Or change the budget constraint
        w*L+nu;
        %If I give it a vector of L's I need to check for each L
        if length(L) == 1 & w*L+nu > 0.36
            Lumptax = 0.15
             C = w*L+nu-Lumptax
        elseif length(L) ~= 1 
            Lumptax = 0.15;
            C = w*L+nu-(w*L+nu>0.3)*Lumptax
        end
        utility = (log(C)+psi*log(1-L));
 end