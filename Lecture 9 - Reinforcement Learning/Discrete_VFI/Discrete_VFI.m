%Preliminaries
    clc;
    clear;
    close all;

%Define parameters
    beta = 0.95;
    alpha = 0.7; 
    delta = 0.07; 
    rho=0.95;
    Abar=1;
    sig_A=0.02;
    
%Define state space (grid of states)
    k_min = 1;
    k_max = 500; 
    k_num = 1000;
    k_vec = linspace(k_min,k_max,k_num); 

    A_min = 0.75;
    A_max = 1.25; 
    A_num = 30;
    A_vec = linspace(A_min,A_max,A_num); 

%Make a grid
    [k_grid,A_grid]=meshgrid(k_vec,A_vec)

    
%Initialize value function for each point on grid
    V_1 = 40+0.01.*k_grid;
    V_0 = V_1;
    
%Iterate on the value function
error = Inf;
while error > 1e-10 
    %Loop over each state (index)
    for k_index = 1:k_num
        for A_index = 1:A_num
            %Given index, look up k value
            k = k_vec(k_index);
            %Look up A value
            A = A_vec(A_index);
            %Find the indicies of all the k's we can afford next period
                kchoice_index = find(k_vec < (1-delta)*k+A*k.^alpha);
            %Using their indicies, store the possible k choices
                k_choices = k_vec(kchoice_index);
            %Given k now and our choice of k, we can see the consumption today
            %from the budget constraint
                c_choices = (1-delta)*k+A*k.^alpha-k_choices;
            %Given consumption and value function, we can find the RHS of the
            %Bellman for each possible choice
                %But to do so, we need to find the probability of every
                %next A
                pdf_A=pdf('norm',A_vec,(1-rho)*Abar+rho*A,sig_A);
                pdf_A=pdf_A./sum(pdf_A);
                utility = log(c_choices) + beta*pdf_A*V_0(:,kchoice_index); 
            %The RHS chooses the best of all choices
                [V,ind] = max(utility);
            %Store the utility of the best choice for this state as the value
            %of that state
                V_1(A_index,k_index) = V;
            %Store the policy function
                k_best(A_index,k_index) = k_choices(ind);
        end
    end
    %Calculate how much we changed functions
        error = max(abs(reshape(V_1-V_0,[],1))) 
    %Once we have all of the new values sorted out, we store V_1 becomes
    %the new V_0, so we can iterate again.
%     figure(3)
        V_0 = V_1;
%         figure(1)
%         plot(V_0(1,:))
%         hold on
%         drawnow
end

%Now, we simulate
num_i = 1;
num_t = 5000;
k_sim = k_vec(500);
rng(1)
A_sim = A_vec(min(find(abs(A_vec-1)==min(abs(A_vec-1)))));
for i = 1:1
    i
    for t = 1:num_t
        A_cts = (1-rho)*Abar+rho*A_sim(t)+sig_A*randn;
        A_sim(t+1)=A_vec(min(find(abs(A_vec-A_cts)==min(abs(A_vec-A_cts)))));
        ind=find(A_vec==A_sim(t));
        k_sim(i,t+1) = k_best(ind,find(k_vec==k_sim(i,t)));     
    end
end

figure(2)
plot(k_sim')

save discrete.mat