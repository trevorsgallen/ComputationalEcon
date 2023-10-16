clear
close all

rng(0,'twister')
clearvars -global

%Observation info
    obsInfo = rlNumericSpec([1 1]);
    obsInfo.Name = 'State';    
    obsInfo.Description = ['w'];

%Act Info (capital choices, via savings)
    actInfo = rlFiniteSetSpec([0,1]); %This is a discrete action
%     actInfo = rlNumericSpec([1,1]); %This is a continuous action
    actInfo.Name = 'accept';

%Create the environment
    env = rlFunctionEnv(obsInfo,actInfo,'myStepFunction','myResetFunction');

%Create the agent (I choose a discrete actor, though my code is set up to accept a 
%continuous actor if need be.  I also don't define the nets, I take the
%default ones.
    agent = rlDQNAgent(obsInfo,actInfo,rlDQNAgentOptions('DiscountFactor',0.95));

%Options
    trainStats = train(agent,env,rlTrainingOptions('MaxEpisodes',1000000)); 

    wdraw = linspace(0,1000,1000);
    act = reshape(cell2mat(arrayfun(@(x)getAction(agent,x),wdraw)),[],1);
    values = cell2mat(arrayfun(@(x)getValue(getCritic(agent),{x}),wdraw,'UniformOutput',false));

        subplot(2,1,1)
        plot(wdraw,act)
        title('Action')
        xlabel('Wage Draw')
        ylabel('Accept')
        ylim([-0.1,1.1])
        drawnow
        hold on
        subplot(2,1,2)
        plot(wdraw,values(1,:))
        hold on
        plot(wdraw,values(2,:))
        legend('Reject','Accept')
        title('Values')
        xlabel('Wage Draw')
        ylabel('Value')
        drawnow
        hold on

