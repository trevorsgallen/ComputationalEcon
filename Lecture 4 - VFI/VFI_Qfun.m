%This file solves a simple NCG-style model using value function iteration
%We take choices as discrete, and maximize all the possible values of the
%state variable simultaneously, in matrix form, rather than looping over
%state variables.

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
    k_num = 50;
    k_space = linspace(k_min,k_max,k_num); 

    knext_min = 1;
    knext_max = 500; 
    knext_num = 1000;
    knext_space = linspace(knext_min,knext_max,knext_num); 

    [k_grid,knext_grid]=meshgrid(k_space,knext_space);
    
%Initialize value function for each point on grid
    V_1 = 40+0.01.*k_space;
    V_0 = V_1;
    
%Iterate on the value function
error = Inf;
counter = 0;
tic
while error > 1e-10 
    counter = counter+1;
    %Solve all states jointly
        c_choices = (1-delta)*k_grid+k_grid.^alpha-knext_grid;
        %Given consumption and value function, we can find the RHS of the
        %Bellman for each possible choice
            utility = log(c_choices) + beta*interp1(k_space,V_0,knext_grid); 
        %Set imaginary utilities to -Inf;
            utility(imag(utility)~=0)=-Inf;
        %The RHS chooses the best of all choices
            [V,ind] = max(utility,[],1);
        %Store the utility of the best choice for this state as the value
        %of that state
            V_1 = V;
        %Store the policy function
            k_best = knext_space(ind);
    %Calculate how much we changed functions
        error = max(abs(V_1-V_0));
    %Once we have all of the new values sorted out, we store V_1 becomes
    %the new V_0, so we can iterate again.
%     figure(3)
%         V_0 = V_1;
%         figure(1)
%         plot(V_0)
%         hold on
%         drawnow
        V_0=V_1;
    [counter,error,toc]
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