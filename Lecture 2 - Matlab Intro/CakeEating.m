%CakeEating.m solves and graphs a simple discrete "cake eating" Value 
% Function iteration problem numerically

%Clear out data, window, and graphs
    clear;
    clc;
    close all;

%Choose a stepsize
    stepsize = 0.1
    
%Create a vector denoting all the possible cake values
    Cake = [0:stepsize:100]';
    
%Discount factor
    beta = 0.95;

%Make sure we enter a while loop
    error = 1;
%Create a Vold vector
    V_0 = zeros(length(Cake),1);
    
%For fun, a counter
    t = 0;
%Loop until the error is small
    while error > 1e-20
        t = t+1;
        %For each INDEX of cake (representing a value)
        for cakeind = 1:length(Cake)
            %Look up the current VALUE of cake
                currentcake = Cake(cakeind);
            %From the current value, define all possible choices
                currentchoices = [0:stepsize:currentcake]';

        %Basic income, or basic utility?
            basicinc = 1;
            basicut = 0;
            %For every choice, define the vector of values
                ut = log(basicinc+currentchoices)+beta.*interp1(Cake,V_0,currentcake-currentchoices);
            %If/when we run out of cake, how happy are we?
                if basicut == 1 & basicinc == 0
                    ut(find(currentchoices==0)) = 0;
                end

            %Store the best possible choice as our utility
                [temp1,temp2] = max(ut);
                V_1(cakeind,1) = temp1;
                Policy(cakeind,1) = currentchoices(temp2);
                Policy_save(cakeind,1) = currentcake-currentchoices(temp2);
        end
        %Define new error
            error = max(abs(V_1-V_0))
        %For fun, plot the current value function
            figure(1)
            subplot(1,3,1)
            plot(Cake,V_0')
            hold all
            drawnow
            title('Value Function')
            xlabel('Cake Size')
            ylabel('Value')
            
            subplot(1,3,2)
            plot(Cake,Policy)
            hold all
            drawnow
            title('Policy Function')
            xlabel('Cake Size')
            ylabel('How much to eat')

            subplot(1,3,3)
            plot(Cake,1-Policy./Cake)
            hold all
            drawnow
            title('Percent to Save')
            xlabel('Cake Size')
            ylabel('Percent Saved')

            
        %Replace the old with the new
            V_0 = V_1;
    end
    
    %Plot the value function, policy, and savings rate
            figure(2)
            subplot(1,3,1)
            plot(Cake,V_0')
            hold all
            drawnow
            title('Value Function')
            xlabel('Cake Size')
            ylabel('Value')
            
            subplot(1,3,2)
            plot(Cake,Policy)
            hold all
            drawnow
            title('Policy Function')
            xlabel('Cake Size')
            ylabel('How much to eat')

            subplot(1,3,3)
            plot(Cake,1-Policy./Cake)
            hold all
            drawnow
            title('Percent to Save')
            xlabel('Cake Size')
            ylabel('Percent Saved')
