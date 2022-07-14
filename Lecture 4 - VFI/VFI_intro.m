%Preliminaries
    clc;
    clear;
    close all;

%Define parameters
    beta = 0.95;
    alpha = 0.7; 
    delta = 0.07; 
    
%Define state space (grid of states)
    k_min = 1;
    k_max = 500; 
    k_num = 1000;
    k_space = linspace(k_min,k_max,k_num); 
    
%Initialize value function for each point on grid
    V_1 = 40+0.01.*k_space;
    V_0 = V_1;
    
%Iterate on the value function
error = Inf;
while error > 1e-10 
    %Loop over each state (index)
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
            utility = log(c_choices) + beta*V_0(find(kchoice_index)); 
        %The RHS chooses the best of all choices
            [V,ind] = max(utility);
        %Store the utility of the best choice for this state as the value
        %of that state
            V_1(k_index) = V;
        %Store the policy function
            k_best(k_index) = k_choices(ind);
    end
    %Calculate how much we changed functions
        error = max(abs(V_1-V_0)) 
    %Once we have all of the new values sorted out, we store V_1 becomes
    %the new V_0, so we can iterate again.
    figure(3)
        V_0 = V_1;
        figure(1)
        plot(V_0)
        hold on
        drawnow
end

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