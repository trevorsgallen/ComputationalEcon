clear
close all
delta = 0.07;
alpha = 0.7;

rng(0,'twister')
clearvars -global

%Observation info
    obsInfo = rlNumericSpec([3 1]);
    obsInfo.Name = 'State';    
    obsInfo.Description = ['K,A,step'];

%Act Info (capital choices, via savings)
    actInfo = rlNumericSpec([1 1],'LowerLimit',0.001,'UpperLimit',0.999);
    actInfo.Name = 'Knext';

%Create the environment
    env = rlFunctionEnv(obsInfo,actInfo,'myStepFunction','myResetFunction');

%Define a three-layer critic network (400 x 400)
    criticNetwork = layerGraph(featureInputLayer([obsInfo.Dimension(1)],'Normalization','none','Name','state'));
    criticNetwork = addLayers(criticNetwork,featureInputLayer([numel(actInfo)],'Normalization','none','Name','action'));
    criticNetwork = addLayers(criticNetwork,concatenationLayer(1,2,'Name','concat'))
    criticNetwork = connectLayers(criticNetwork,'state','concat/in1');
    criticNetwork = connectLayers(criticNetwork,'action','concat/in2');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(400,'Name','fc1'));
    criticNetwork = connectLayers(criticNetwork,'concat','fc1');
    criticNetwork = addLayers(criticNetwork, tanhLayer('Name','tan1'));
    criticNetwork = connectLayers(criticNetwork,'fc1','tan1');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(400,'Name','fc2'));
    criticNetwork = connectLayers(criticNetwork,'tan1','fc2');
    criticNetwork = addLayers(criticNetwork, scalingLayer('Name','tan2'));
    criticNetwork = connectLayers(criticNetwork,'fc2','tan2');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(1,'Name','StateValue','BiasLearnRateFactor', 0, 'Bias', 0))
    criticNetwork = connectLayers(criticNetwork,'tan2','StateValue');

    plot(criticNetwork)
    %Options for critics
        criticOpts = rlRepresentationOptions('LearnRate',0.0001,'GradientThreshold',1);
    
    % create the critic based on the network approximator
        critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,...
            'Observation',{'state'},'Action',{'action'},criticOpts);


%Create the actor
    actorNetwork = [
        featureInputLayer([obsInfo.Dimension(1)],'Normalization','none','Name','state')
        fullyConnectedLayer(400,'Name','fc1')
        swishLayer('Name','tan1')
        fullyConnectedLayer(400,'Name','fc2');
        swishLayer('Name','tan2')
        fullyConnectedLayer(400,'Name','fc4');
        swishLayer('Name','relu1')
        fullyConnectedLayer(numel(actInfo),'Name','action','BiasLearnRateFactor',1,'Bias',0)];
    
    % set some options for the actor
    actorOpts = rlRepresentationOptions('LearnRate',0.0001,'GradientThreshold',1);
    
    % create the actor based on the network approximator
    actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,...
        'Observation',{'state'},'Action',{'action'},actorOpts);

%Create the agent
    agentOpts = rlDDPGAgentOptions(...
        'SampleTime',env.LoggedSignals(3),...
        'TargetSmoothFactor',0.0001,...
        'ExperienceBufferLength',1e6,...
        'DiscountFactor',0.95,...
        'MiniBatchSize',32,...
        'TargetUpdateFrequency',1,...
        'SaveExperienceBufferWithAgent',false, ...
        'ResetExperienceBufferBeforeTraining',true);


    agent = rlDDPGAgent(actor,critic,agentOpts);
    agentOpts.NoiseOptions.StandardDeviationDecayRate=0;
    agentOpts.NoiseOptions.StandardDeviation =0.01;    
    agent.AgentOptions.NumStepsToLookAhead=10;

%Training Options
    opt = rlTrainingOptions(...
        'MaxEpisodes',1000000,...
        'MaxStepsPerEpisode',10000,...
        'StopTrainingCriteria',"AverageReward",...
        'StopTrainingValue',480,...
        'ScoreAveragingWindowLength',500, ...
        'SaveAgentDirectory', pwd + "/agents/",...
        'UseParallel',0,'Verbose',0);

        rng(1)
        AgentOptions.NumStepsToLookAhead=1;

        %Train the agent (load for speed or to restart)
        load('myagent.mat','agent');
        trainStats = train(agent,env,opt);
        save('myagent.mat','agent');

    %Now we have a trained agent!  We can do all sorts of things.

    %Simulate (use step to simulate, will also simulate by hand)
    rng(1)
    simOpts = rlSimulationOptions(...
        'MaxSteps',10000,...
        'NumSimulations',1,'UseParallel',0);
    experience = sim(env,agent,simOpts);

%     %
%     temp3=squeeze(experience.Observation.State.Data(1,1,1:end));
%     temp4=squeeze(experience.Observation.State.Data(2,1,1:end));
% 
%     %Plot k
%     figure(2)
%     hold on
%     plot(temp3)

    
%Simulate by hand
    rho = 0.95;
    k = 144;
    alpha=0.7;
    delta = 0.07;
    rng(1)
    A = 1;
    for t = 2:5000
        sav = cell2mat(getAction(getActor(agent),{[k(t-1),A(t-1),1]}));
        totinc = (1-delta)*k(t-1)+A(t-1)*k(t-1)^alpha;
        cons = sav.*totinc;
        k(t) = (1-sav).*totinc;
        A(t) = (1-rho)*1+rho*A(t-1)+0.02*randn;
    end

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

