%CakeGrowth.m solves and graphs a stochastic discrete "cake eating" Value 
% Function iteration problem numerically.

clear
    close all

%Parameters
    beta = 0.95;
    cakestep = 0.01;

%Cake sizes and steps
    cake_min = 0;
    cake_max = 100;
    cake_space = [cake_min:cakestep:cake_max];

%Transition probabilities
    pr_lo_lo = 0.99;
    pr_hi_hi = 0.99;
    pr_lo_hi = 1-pr_lo_lo;
    pr_hi_lo = 1-pr_hi_hi;

%Zero out the value functions
    V_0 = zeros(2,length(cake_space));
    V_1 = V_0;

%Enter the loop
error = 10;
while error > 1e-20
    for cake_ind = 1:length(cake_space)
        for growth_ind = 1:2
            %We have two states: cake size, and growth regime.  Look both up.
            currentcake = cake_space(cake_ind);
            choices = [0:cakestep:currentcake];
            %If we're in the low growth state, use low-growth probabilities
            
            %Have a list of feasible choices C
            
            for c_choice in feasible c_choices 
                c_choices
                %From this, can get all of the incoming (not including y)
                %assets next period (Anext)
                A_next = (1+r)*(A+y-c_choices)

                V(y,A)

                V(y,A) = u(c_choices) + beta*pi_yislo*interp1(A_space,V_0(1,:),A_next) + ...
                                        beta*pi_yishi*interp1(A_space,V_0(2,:),A_next)
                                
            end
            pr(ylo|ylo)*interp1(y_space,V_0(1,:),Anext)
            
           if growth_ind == 1
               utility = log(1+choices) + ...
                         pr_lo_lo.*beta*interp1(cake_space,V_0(1,:),min(max(currentcake-choices-cakestep,0),100)) + ...
                         pr_lo_hi.*beta*interp1(cake_space,V_0(2,:),min(max(currentcake-choices+5*cakestep,0),100));
                utility(find(isinf(utility)==1)) = -10000;
            %Otherwise, high-growth
           elseif growth_ind == 2
               utility = log(1+choices) + ...
                         pr_hi_lo.*beta*interp1(cake_space,V_0(1,:),min(max(currentcake-choices-cakestep,0),100)) + ...
                         pr_hi_hi.*beta*interp1(cake_space,V_0(2,:),min(max(currentcake-choices+5*cakestep,0),100));
               utility(find(isinf(utility)==1)) = -10000;
           end
           %After calculating utility for all possible cake-eating choices,
           %find the best and store it (and our policies)
           [temp_1,temp_2] = max(utility);
           V_1(growth_ind,cake_ind) = temp_1;
           Policy_Eat(growth_ind,cake_ind) = choices(temp_2);
           Policy_Save(growth_ind,cake_ind) = currentcake-choices(temp_2);
           Policy_PctSave(growth_ind,cake_ind) = (currentcake-choices(temp_2))./currentcake;
        end
    end
    %Find error
        error = max(max(abs(V_1-V_0)))
    %Replace vold with vnew 
        V_0 = V_1;

    %Graph things
        figure(1)
        subplot(1,3,1)
        plot(cake_space(2:end),V_1(1,2:end))
        hold all
        plot(cake_space(2:end),V_1(2,2:end))
        title('Value')
        xlabel('Cake Size')
        ylabel('Utility')
        drawnow

        subplot(1,3,2)
        plot(cake_space,Policy_Save(1,:))
        hold all
        plot(cake_space,Policy_Save(2,:))
        title('Savings')
        xlabel('Cake Size')
        ylabel('Saving')
        drawnow

        subplot(1,3,3)
        plot(cake_space,Policy_PctSave(1,:))
        hold all
        plot(cake_space,Policy_PctSave(2,:))
        title('Savings as Fraction of Cake')
        xlabel('Cake Size')
        ylabel('Saving Rate')
        drawnow
end


%Graph final policy and value functions
    figure(2)
    plot(cake_space,V_1(1,:))
    hold on
    plot(cake_space,V_1(2,:))

    figure(3)
    plot(cake_space,Policy_Save(1,:))
    hold on
    plot(cake_space,Policy_Save(2,:))

    figure(4)
    plot(cake_space,Policy_Save(1,:)./cake_space)
    hold on
    plot(cake_space,Policy_Save(2,:)./cake_space)

% Simulation
    clear sim* tempsto
    rng(0,'twister');
    sim_cake = 2;
    sim_growth = 2;
    t=0;
    while t < 500
        t = t+1;

        temp = rand;
        tempsto(t) = rand;
        %Here, I'm looking up policy from the "closest" cake space (that
        %between wherever I am minus a half step and plus a half step,
        %which means it should only look up exactly where I am).  
       if sim_growth(t) == 1 & temp < pr_lo_lo
            sim_eat(t) = Policy_Eat(1,find(cake_space>sim_cake(t)-cakestep./2 & cake_space<sim_cake(t)+cakestep./2));
            sim_growth(t+1) = 1;
            sim_cake(t+1) = min(max(sim_cake(t) - sim_eat(t) - cakestep,0),100);
       elseif sim_growth(t) == 1 & temp >= pr_lo_lo
            sim_eat(t) = Policy_Eat(1,find(cake_space>sim_cake(t)-cakestep./2 & cake_space<sim_cake(t)+cakestep./2));
            sim_growth(t+1) = 2;
            sim_cake(t+1) = min(max(sim_cake(t) - sim_eat(t) + 5,0),100);
       elseif sim_growth(t) == 2 & temp < pr_hi_lo
            sim_eat(t) = Policy_Eat(2,find(cake_space>sim_cake(t)-cakestep./2 & cake_space<sim_cake(t)+cakestep./2));
            sim_growth(t+1) = 1;
            sim_cake(t+1) = min(max(sim_cake(t) - sim_eat(t) - cakestep,0),100);
       elseif sim_growth(t) == 2 & temp >= pr_hi_lo
            sim_eat(t) = Policy_Eat(2,find(cake_space>sim_cake(t)-cakestep./2 & cake_space<sim_cake(t)+cakestep./2));
            sim_growth(t+1) = 2;
            sim_cake(t+1) = min(max(sim_cake(t) - sim_eat(t) + 5,0),100);
       else 
           'nothing happened! (debug!)'
           asdf
       end
    end
    
    figure(5)
    subplot(3,1,1)
    plot(sim_cake)
    title('Cake')
    subplot(3,1,2)
    plot(sim_growth)
    title('Growth Regime')
    subplot(3,1,3)
    plot(sim_eat)
    title('Eating')
    