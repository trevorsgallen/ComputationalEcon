%This file solves a simple NCG-style model using value function iteration
%We take choices as discrete, and loop over all possible states
%individually.

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
    k_num = 10;
    k_space = linspace(k_min,k_max,k_num); 
    
%Initialize value function for each point on grid
    V_1 = 40+0.01.*k_space;
    V_0 = V_1;
    k_best = NaN(size(k_space));
    c_best = 0.01*ones(size(k_space));

%Iterate on the value function
error = Inf;
counter = 0;
tic
while error > 1e-10 
    %Loop over each state (index)
    for k_index = 1:k_num
        %Given index, look up k value
        k = k_space(k_index);

        %knext+c=(1-delta)*k+k.^alpha
        c_lb = max((1-delta)*k+k.^alpha-max(k_space),0.01);
        c_ub = (1-delta)*k+k.^alpha-min(k_space);

        f_knext = @(c) max(min((1-delta)*k+k.^alpha-c,max(k_space)),min(k_space));
        %Given a (continuous!) choice of c, find utility
        %Given consumption and value function, we can find the RHS of the
        %Bellman for each possible choice
            [temp1,temp2]=fmincon(@(c) -(log(c)+beta*interp1(k_space,V_0,f_knext(c))),[c_best(k_index)],[],[],[],[],c_lb,c_ub,[],optimset('Display','off'));

        %Store the utility of the best choice for this state as the value
        %of that state
            V_1(k_index) = -temp2;
        %Store the policy function
            c_best(k_index) = temp1;
            k_best(k_index) = f_knext(c_best(k_index));
    end
    %Calculate how much we changed functions
        error = max(abs(V_1-V_0));
    %Once we have all of the new values sorted out, we store V_1 becomes
    %the new V_0, so we can iterate again.
%     figure(3)
        V_0 = V_1;
        figure(1)
        plot(V_0)
        hold on
        drawnow
    [counter,error,toc]
end

%Now, we simulate
num_i = k_num;
num_t = 2000;
k_sim = NaN(num_i,num_t);
k_sim(:,1) = random('Uniform',min(k_space),max(k_space),num_i,1)
for i = 1:num_i
    i
    for t = 1:num_t
        k_sim(i,t+1) = interp1(k_space,k_best,k_sim(i,t));     
    end
end

figure(2)
plot(k_sim')