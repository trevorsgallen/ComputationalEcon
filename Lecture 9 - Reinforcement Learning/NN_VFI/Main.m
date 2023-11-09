clear
close all
delta = 0.07;
alpha = 0.7;

rng(0,'twister')
clearvars -global

%Observation info (takes in 3 states)
    obsInfo = rlNumericSpec([3 1]);
    obsInfo.Name = 'State';    
    obsInfo.Description = ['K,A,step'];

%Act Info (capital choices, via savings)
    actInfo = rlNumericSpec([1 1],'LowerLimit',0.001,'UpperLimit',0.999);
    actInfo.Name = 'Knext';

%Create the environment
    env = rlFunctionEnv(obsInfo,actInfo,'myStepFunction','myResetFunction');

%Define a simple 2-layer critic network (5x5) takes in states and action,
%concatenates them, then feeds them through the network to spit out 1x1 
%state value
    criticNetwork = layerGraph(featureInputLayer([obsInfo.Dimension(1)],'Normalization','none','Name','state'));
    criticNetwork = addLayers(criticNetwork,featureInputLayer([numel(actInfo)],'Normalization','none','Name','action'));
    criticNetwork = addLayers(criticNetwork,concatenationLayer(1,2,'Name','concat'))
    criticNetwork = connectLayers(criticNetwork,'state','concat/in1');
    criticNetwork = connectLayers(criticNetwork,'action','concat/in2');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(5,'Name','fc1'));
    criticNetwork = connectLayers(criticNetwork,'concat','fc1');
    criticNetwork = addLayers(criticNetwork, tanhLayer('Name','tanh1'));
    criticNetwork = connectLayers(criticNetwork,'fc1','tanh1');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(5,'Name','fc2'));
    criticNetwork = connectLayers(criticNetwork,'tanh1','fc2');
    criticNetwork = addLayers(criticNetwork, tanhLayer('Name','tanh2'));
    criticNetwork = connectLayers(criticNetwork,'fc2','tanh2');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(1,'Name','StateValue','BiasLearnRateFactor', 0, 'Bias', 0))
    criticNetwork = connectLayers(criticNetwork,'tanh2','StateValue');
    plot(criticNetwork)

    %Options for critics
        % criticOpts = rlRepresentationOptions('LearnRate',0.001,'GradientThreshold',1);
        criticOpts = rlRepresentationOptions();

    % create the critic based on the network approximator
        critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,...
            'Observation',{'state'},'Action',{'action'},criticOpts);


%Create the actor (because I don't have to concatenate state+action, I can define the
%network in a matrix more easily)
    actorNetwork = [
        featureInputLayer([obsInfo.Dimension(1)],'Normalization','none','Name','state')
        fullyConnectedLayer(5,'Name','fc1')
        sigmoidLayer('Name','sig1')
        fullyConnectedLayer(5,'Name','fc2');
        sigmoidLayer('Name','sig2')
        fullyConnectedLayer(numel(actInfo),'Name','action','BiasLearnRateFactor',1,'Bias',0)];
    
    % set some options for the actor
    actorOpts = rlRepresentationOptions('LearnRate',1e-3);
    
    % create the actor based on the network approximator
    actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,...
        'Observation',{'state'},'Action',{'action'},actorOpts);

%Create the agent
    agent = rlDDPGAgent(actor,critic);

%Training Options
    opt = rlTrainingOptions(...
        'MaxEpisodes',1000,...
        'MaxStepsPerEpisode',200,...
        'StopTrainingCriteria',"AverageReward",...
        'StopTrainingValue',Inf,...
        'ScoreAveragingWindowLength',500, ...
        'SaveAgentDirectory', pwd + "/agents/",...
        'UseParallel',0,'Verbose',0);

        %Train the agent (load for speed or to restart)
        rng(1)
        trainStats = train(agent,env,opt);

    %Now we have a trained agent!  We can do all sorts of things.

    %Simulate (use step to simulate, will also simulate by hand)
    rng(1)
    simOpts = rlSimulationOptions(...
        'MaxSteps',10000,...
        'NumSimulations',1,'UseParallel',0);
    experience = sim(env,agent,simOpts);


%Q function slice 
    clear vsto actionsto
    kvec = linspace(1,5000,100);
    knext_vec=linspace(1,5000,100);
    for k_ind = 1:numel(kvec)
        for knext_ind = 1:numel(knext_vec)
            k=kvec(k_ind);
            knext=knext_vec(knext_ind);
            vsto(k_ind,knext_ind)=getValue(getCritic(agent),{[k,1,1]},{knext});
            actionsto(k_ind,knext_ind)=cell2mat(getAction(getActor(agent),{[k,1,1]}));
        end
    end
    for k_ind = 1:numel(kvec)
        for t = 1:5
            k=kvec(k_ind);
            actionsto(k_ind,t)=cell2mat(getAction(getActor(agent),{[k,1,t]}));
        end
    end

%Plot Q-function slice
        figure(3)
        surf(vsto)
        drawnow

