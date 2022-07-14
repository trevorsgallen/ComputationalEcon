%Rather than iterating on a grid (flexible function) I'll iterate on
%polynomial coefficients (cubic)

clear
close all
%Define parameters
    beta = 0.95;
    alpha = 0.7; 
    delta = 0.07; 
    theta = [40 ; 0 ; 0 ; 0; ];
    theta = [         -997.517935223723
          1792.90298802022
         -1011.70290297174
          341.951986240249
         -46.1849843311097
           35.240701102546
          -81.223883440285
          73.1941877681351
         -34.6407569344636
          7.66621518640968]
%Define state space (grid of states)
    k_min = 1;
    k_max = 500; 
    k_num = 10;
%     k_space = linspace(k_min,k_max,k_num); 
    k_space = k_min+sort((k_max-k_min)*(cos((2*[1:k_num]-1)/(2*k_num)*pi)/2+0.5))
%Initialize value function for each point on grid
    V_1_fit = 40.*k_space;
    V_1_fit_old = V_1_fit;
    
    load temp.mat V_0
    k_space_save= linspace(k_min,k_max,size(V_0,2));
    V_0_save = V_0;
    plot(k_space_save,V_0,'-k','Linewidth',5)
    hold on
    clear V_0 
    
%Iterate on the value function
error = Inf;
counter = 0;

while error > 1e-10 
    counter = counter+1;
    %Loop over each state (index)
    
      V_0 = @(x0) sum(cell2mat(arrayfun(@(x) chebyshevT([0, 1, 2, 3, 4 , 5 , 6 , 7 , 8 , 9], x),x0,'UniformOutput',false)).*repmat(theta',size(x0,1),1),2)

    for k_index = 1:k_num
        k_index
        %Given index, look up k value
        k = k_space(k_index);
        %Find the indicies of all the k's we can afford next period
            kchoice_index = find(k_space < 0.93*k+k.^0.7);
        %Using their indicies, store the possible k choices
            k_choices = k_space(kchoice_index);
        %Given k now and our choice of k, we can see the consumption today
        %from the budget constraint
            c_choices = 0.93*k+k.^0.7-k_choices;
        %Given consumption and value function, we can find the RHS of the
        %Bellman for each possible choice
            utility = log(c_choices) + beta*V_0(k_choices'/500)' ;
        %The RHS chooses the best of all choices
            [V,ind] = max(utility);
        %Store the utility of the best choice for this state as the value
        %of that state
            V_1(k_index) = V;
        %Store the policy function
            k_best(k_index) = k_choices(ind);
    end
    %Now re-estimate the polynomial that represents V
    
      V_0 = @(x0,theta) sum(cell2mat(arrayfun(@(x) chebyshevT([0, 1, 2, 3, 4 , 5 , 6 ,7 , 8 , 9], x),x0,'UniformOutput',false)).*repmat(theta',size(x0,1),1),2)

      fitfcn = @(thetahat) sum((V_0(k_space'/500,thetahat)-V_1').^2)
      foptions = optimset('Display','iter')
      thetanew = fminunc(fitfcn,theta,foptions)

        
            figure(3)
        plot(k_space,V_0(k_space'/500,thetanew),'b')
        scatter(k_space,V_0(k_space'/500,thetanew),'b')
        hold on
        plot(k_space,V_1,'r')
        hold on
        plot(k_space_save,V_0_save,'-k','Linewidth',5)
        drawnow
        
        theta = thetanew;
        
% theta= thetanew;
end
asdf

%Now, we simulate
num_i = k_num;
num_t = 200;
k_sim = NaN(num_i,num_t);
k_sim(:,1) = k_space(round(0.5+(k_num-2)*(rand(num_i,1))));
for i = 1:100
    i
    for t = 1:num_t
        k_sim(i,t+1) = k_best(find(k_space==k_sim(i,t)));     
    end
end

figure(2)
plot(k_sim')
