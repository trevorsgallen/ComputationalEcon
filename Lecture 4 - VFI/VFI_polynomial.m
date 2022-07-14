%Rather than iterating on a grid (flexible function) I'll iterate on
%polynomial coefficients (cubic)

clear
close all
%Define parameters
    beta = 0.95;
    alpha = 0.7; 
    delta = 0.07; 
    theta = [40 ; 25 ; 0 ; 0; 0 ; 0 ; 0 ; 0 ; 0];

%Define state space (grid of states)
    k_min = 1;
    k_max = 500; 
    k_num = 10000;
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
    V_0 = @(kchoice) theta(1)+theta(2)*(kchoice/500)+theta(3)*((kchoice/500).^2)+theta(4)*((kchoice/500).^3)+theta(5)*((kchoice/500).^4)+theta(6)*((kchoice/500).^5)+theta(7)*((kchoice/500).^6)+theta(8)*((kchoice/500).^7)+theta(9)*((kchoice/500).^8);
%     V_0 = @(kchoice) theta(1)+theta(2)*(kchoice/500)+theta(3)*((kchoice/500).^2)+theta(4)*((kchoice/500).^3);

    for k_index = 1:k_num
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
            utility = log(c_choices) + beta*V_0(k_choices) ;
        %The RHS chooses the best of all choices
            [V,ind] = max(utility);
        %Store the utility of the best choice for this state as the value
        %of that state
            V_1(k_index) = V;
        %Store the policy function
            k_best(k_index) = k_choices(ind);
    end
    %Now re-estimate the polynomial that represents V
    
%     syms x0
%     chebyshevT([0, 1, 2, 3, 4], x0)

    
        X = [ones(length(k_space),1),k_space'/500,(k_space'/500).^2,(k_space'/500).^3,(k_space'/500).^4,(k_space'/500).^5,(k_space'/500).^6,(k_space'/500).^7,(k_space'/500).^8];
        Y = [reshape(V_1,[],1)]
        
        thetanew = inv(X'*X)*X'*Y;
        V_1_fit= X*thetanew;
        
        errorsto(counter)= abs(max(V_1_fit-V_0_save'));
        if counter > 200 & mod(counter,20)==0
            figure(10)
            scatter(counter,mean(errorsto(counter-200:counter)))
            hold all
        end

    
    %Calculate how much we changed functions
%         error = max(abs(theta-thetanew)) 
    %Once we have all of the new values sorted out, we store V_1 becomes
    %the new V_0, so we can iterate again.
        figure(3)
        plot([k_space'],V_1_fit)
        
        hold on
        plot(k_space_save,V_0_save,'-k','Linewidth',5)
        drawnow
        
        temp = (1/(counter^0.36));
        theta = temp*thetanew+(1-temp)*theta;
        
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
