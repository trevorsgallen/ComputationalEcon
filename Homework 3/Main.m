clear
close all

%Pretrain option
    pretrain = 0;

%Parameterization
    myparms.phi = 0.1;
    myparms.sigma=0.01;
    myparms.beta = 0.95;
    myparms.rho = 0.95;


%State bounds (K,A)
    myparms.smin = [-0.13,-0.13];
    myparms.smax=[0.13,0.13];

%Action bounds (% consumed)
    myparms.amin = [-0.13];
    myparms.amax=[0.13];

%Number of parameters
    myparms.Nnodes_C = 10;
    myparms.Nnodes_A = 10;

%Number of simulations
    myparms.Nsim = 100000;
    myparms.Tsim = 3;


%%Define all options
    myoptions=optionmaker(myparms)

%Fake dataset to pre-train the networks on (use datastores, used when you
%don't want to hold all data in memory (or in this case, if you're feeding
%in different cells becuase the critic has two cell inputs)
if pretrain == 1
    simdata = policysim(myparms);

    %States and Values
    ds_state=transform(arrayDatastore(simdata.strain'),@(x) x{1}')
    ds_act=arrayDatastore(simdata.acttrain')
    ds_value=arrayDatastore(simdata.Vtrain')

    %Combine for the critic: two inputs and an output
    ds_critic = combine(ds_state,ds_act,ds_value);
    
    %Train actor to set price equal to 90% of pbar, 10% of ptm1
    % ds_act_pol=arrayDatastore(0.91*simdata.strain(1,:)'+0.09*simdata.strain(2,:)');
    ds_act_pol=arrayDatastore(simdata.strain(1,:)');

    %Actor datastore
    ds_actor = combine(ds_state,ds_act_pol)
end
    rng(0,'twister')
    clearvars -global

%Observation info
    obsInfo = rlNumericSpec([2 1],'LowerLimit',myparms.smin','UpperLimit',myparms.smax');
    obsInfo.Name = 'State';    
    obsInfo.Description = ['Pbar,Pt'];

%Act Info (capital choices, via savings)
    actInfo = rlNumericSpec([1 1],'LowerLimit',myparms.amin,'UpperLimit',myparms.amax);
    actInfo.Name = 'Knext';

%% Critic
    %Define the critic network
        criticNetwork = defCritic(myparms.Nnodes_C,obsInfo,actInfo)

    %Then add a regression layer at the end for fitting
    if pretrain == 1
        criticNetwork = addRegLayer(criticNetwork)

        %Train the critic network on fake data
        myoptions.nntrainopt.Verbose=1 ;
        myoptions.nntrainopt.VerboseFrequency=2000 ;
        criticNetwork = trainNetwork(ds_critic,criticNetwork,myoptions.nntrainopt);

        %Remove regression layer
        criticNetwork = removeRegLayer(criticNetwork)
    end
    %Now define the critic with pre-trained network
            critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,...
                'Observation',{'state'},'Action',{'action'});

%% Actor 
    actorNetwork = defActor(myparms.Nnodes_A,obsInfo,actInfo,myparms);
    if pretrain == 1
        %Then add a regression layer at the end for fitting
        actorNetwork = addRegLayer(actorNetwork)
        %Train
        actorNetwork = trainNetwork(ds_actor,actorNetwork,myoptions.nntrainopt);
        %Remove regression layer
        actorNetwork = removeRegLayer(actorNetwork)
    end
%    Now define the actor
    actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,...
        'Observation',{'state'},'Action',{'action'});
% 
%% Agent
    agent = rlDDPGAgent(actor,critic,myoptions.agentOpts);
    agent.AgentOptions.NoiseOptions.StandardDeviation=0.01;
    % agent.AgentOptions.ExplorationModel.StandardDeviation=0.01;

%% Set up the environment
    %Pass the parameters to the functions
    ResetHandle = @() myResetFunction(myparms);
    StepHandle = @(Action,Info) myStepFunction(Action,Info,myparms);
    %Define environment
    env = rlFunctionEnv(obsInfo,actInfo,StepHandle,ResetHandle);
    myoptions.rlopt.MaxStepsPerEpisode=myparms.Tsim;

%% Training 
    %First train with three periods
    rng(1,'twister')
    trainStats = train(agent,env,myoptions.rlopt);

    %Then train with 200 periods, once we get the policy function right
    myparms.Tsim = 200;
    StepHandle = @(Action,Info) myStepFunction(Action,Info,myparms);
    trainStats = train(agent,env,myoptions.rlopt);


    %Graph the post-trained networks
    pbar_ind = 0;
        for pbar = [-0.15:0.01:0.15]
            ptm1_ind = 0;
            pbar_ind=pbar_ind+1;
            for ptm1 = [-0.15:0.01:0.15]
                ptm1_ind = ptm1_ind+1;
                pbarsto(ptm1_ind,pbar_ind)=pbar;
                ptm1sto(ptm1_ind,pbar_ind)=ptm1;
                vsto(ptm1_ind,pbar_ind)=getValue(getCritic(agent),{[pbar;ptm1]},{ptm1});
                actsto(ptm1_ind,pbar_ind)=cell2mat(getAction(getActor(agent),{[pbar;ptm1]}));
            end
        end
        
    %Value and Policy Function Surfaces
        figure(4)
        subplot(1,2,1)
        surf(pbarsto,ptm1sto,vsto);
        title('Value')
        xlabel('pbar')
        ylabel('ptm1')
        hold on
        subplot(1,2,2)
        surf(pbarsto,ptm1sto,actsto);
        title('Action')
        xlabel('pbar')
        ylabel('ptm1')
        hold on

    %Compare with results for VFI
        VFI_res=load('VFI.mat');

        figure(4)
        subplot(1,2,1)
        surf(VFI_res.pbar_grid,VFI_res.ptm1_grid,VFI_res.V_0)
        shading flat
        subplot(1,2,2)
        surf(VFI_res.pbar_grid,VFI_res.ptm1_grid,VFI_res.ptstar)
        title('Action')
        xlabel('pbar')
        ylabel('ptm1')


        %Check to see if we're roughly on the mark
        figure(5)
        pbarspace = linspace(-0.15,0.15,100);
        plot(pbarspace,cell2mat(cellfun(@(x)getAction(getActor(agent),{[x;0]}),num2cell(pbarspace))),'DisplayName','Reinforcement Learning')
        hold on
        plot(pbarspace,pbarspace,'--r','DisplayName','45 Degree Line')
        hold on
        plot(pbarspace,interp2(VFI_res.pbar_grid,VFI_res.ptm1_grid,VFI_res.ptstar,pbarspace,0),'DisplayName','Value Function Iteration')
        legend('Location','Best')
        title('Policy Functions')
        xlabel('Pbar')
        ylabel('Pt(Pbar;P_{t-1}=0)')


        
function [InitialObservation, LoggedSignal] = myResetFunction(myparms)
    % Initial values [K,A,step]
    state = [myparms.smin(1)+rand*(myparms.smax(1)-myparms.smin(1)) ; myparms.smin(2)+rand*(myparms.smax(2)-myparms.smin(2))];
    state = min([state,myparms.smax'],[],2);
    state = max([state,myparms.smin'],[],2);

    % Return initial environment state variables as logged signals.
    LoggedSignal = state;
    InitialObservation = state;
end

function [NextObs,Reward,IsDone,LoggedSignal] = myStepFunction(Action,Obs,myparms)

    Action = max(min(Action,myparms.amax),myparms.amin);
    Reward = 100*(-(Obs(1)-Action).^2-myparms.phi.*(Action-Obs(2)).^2);
    NextObs = [myparms.rho.*Obs(1)+randn.*myparms.sigma;Action];
    
    NextObs = min([NextObs,myparms.smax'],[],2);
    NextObs = max([NextObs,myparms.smin'],[],2);

    IsDone = 0;
    LoggedSignal=NextObs;
end


function mynet = addRegLayer(mynet)
    try
        temp = mynet.Layers(end).Name;
    catch
        mynet = layerGraph(mynet)
        temp = mynet.Layers(end).Name;
    end
    mynet=addLayers(mynet,regressionLayer('Name','regout'))
    mynet = connectLayers(mynet,temp,'regout'     );
end

function mynet = removeRegLayer(mynw)
    mynet=removeLayers(layerGraph(mynw),'regout');
end

%Define the critic network
function criticNetwork = defCritic(Nnodes,obsInfo,actInfo)
    criticNetwork = layerGraph(featureInputLayer([obsInfo.Dimension(1)],'Normalization','none','Name','state'));
    criticNetwork = addLayers(criticNetwork,featureInputLayer([numel(actInfo)],'Normalization','none','Name','action'));
    criticNetwork = addLayers(criticNetwork,concatenationLayer(1,2,'Name','concat'))
    criticNetwork = connectLayers(criticNetwork,'state','concat/in1');
    criticNetwork = connectLayers(criticNetwork,'action','concat/in2');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(Nnodes,'Name','fc1'));
    criticNetwork = connectLayers(criticNetwork,'concat','fc1');
    criticNetwork = addLayers(criticNetwork, reluLayer('Name','relu'));
    criticNetwork = connectLayers(criticNetwork,'fc1','relu');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(Nnodes,'Name','fc2'));
    criticNetwork = connectLayers(criticNetwork,'relu','fc2');
    criticNetwork = addLayers(criticNetwork, reluLayer('Name','relu2'));
    criticNetwork = connectLayers(criticNetwork,'fc2','relu2');
    criticNetwork = addLayers(criticNetwork, fullyConnectedLayer(1,'Name','StateValue'))
    criticNetwork = connectLayers(criticNetwork,'relu2','StateValue');
end


%Define the actor network
function actorNetwork = defActor(Nnodes,obsInfo,actInfo,myparms)
    actorNetwork = [
        featureInputLayer([obsInfo.Dimension(1)],'Normalization','none','Name','state')
        fullyConnectedLayer(Nnodes,'Name','fc1')
        reluLayer('Name','relu')
        fullyConnectedLayer(Nnodes,'Name','fc2')
        reluLayer('Name','relu2')
        fullyConnectedLayer(actInfo.Dimension(1),'Name','fc3')
        tanhLayer('Name','tanh')
        scalingLayer('Name','action','Scale',myparms.amax,'Bias',0)]
end

%Simulate a dataset using a simple rule after first random action
function simdataset = policysim(myparms)
    %Set random seed
        rng(1)
    %Create empty grids of states
        N = myparms.Nsim;
        T = myparms.Tsim;
        sim_Pbar = NaN(T,N);
        sim_pt = NaN(T,N);

    %Initialize states and action
        sim_Pbar(1,:) = myparms.smin(1)+rand(1,N).*(myparms.smax(1)-myparms.smin(1));
        sim_ptm1(1,:) = myparms.smin(2)+rand(1,N).*(myparms.smax(2)-myparms.smin(2));
        sim_pt(1,:) = random('Uniform',myparms.amin,myparms.amax,1,N);
    for t = 1:T
        if t > 1
            %Afterwards, just go 90% toward pbar each time
            % sim_pt(t,:) = 0.91*sim_Pbar(t,:)+0.09*sim_ptm1(t,:);
            sim_pt(t,:) = sim_Pbar(t,:);
        end
        Reward(t,:) = -(sim_pt(t,:)-sim_Pbar(t,:)).^2-myparms.phi*((sim_pt(t,:)-sim_ptm1(t,:)).^2);
        sim_Pbar(t+1,:) = min(max(sim_Pbar(t,:)+myparms.sigma*randn,myparms.smin(1)),myparms.smax(1));
        sim_ptm1(t+1,:) = min(max(sim_pt(t,:),myparms.smin(2)),myparms.smax(2));
    end
    simdataset.V = sum(Reward.*repmat(myparms.beta.^[0:myparms.Tsim-1]',1,N),1);
    simdataset.s = [sim_Pbar(1,:);sim_ptm1(1,:)];
    simdataset.act = sim_pt(1,:);

    simdataset.Vtrain = simdataset.V(:,1:end-1000);
    simdataset.strain = simdataset.s(:,1:end-1000);
    simdataset.acttrain = simdataset.act(:,1:end-1000);

    simdataset.Vval = simdataset.V(:,end-1000+1:end);
    simdataset.sval = simdataset.s(:,end-1000+1:end);
    simdataset.actval = simdataset.act(:,end-1000+1:end);

end

function out = optionmaker(myparms)
        out.nntrainopt = trainingOptions("adam", ...
        MaxEpochs=10, ...
        MiniBatchSize=128,...
        InitialLearnRate=0.001,...
        Shuffle="every-epoch", ...
        GradientThreshold=Inf, ...
        Verbose=false, ...
        Plots="training-progress");

        out.agentOpts = rlDDPGAgentOptions(...
        'SampleTime',1,...
        'ExperienceBufferLength',1e6,...
        'DiscountFactor',myparms.beta,...
        'MiniBatchSize',128,...
        'TargetUpdateFrequency',2,...
        'SaveExperienceBufferWithAgent',false, ...
        'ResetExperienceBufferBeforeTraining',true,...
        'NumStepsToLookAhead',1, ...
        'DiscountFactor',0.95,...
        'TargetSmoothFactor',1,...
        'MiniBatchSize',128);


        out.rlopt = rlTrainingOptions(...
        'MaxEpisodes',7000,...
        'MaxStepsPerEpisode',myparms.Tsim,...
        'StopTrainingCriteria',"AverageReward",...
        'StopTrainingValue',Inf,...
        'ScoreAveragingWindowLength',500, ...
        'SaveAgentDirectory', pwd + "/agents/",...
        'SaveAgentCriteria','EpisodeFrequency',...
        'SaveAgentValue',1000,...
        'UseParallel',0,...
        'Verbose',0,...
        'Plots','training-progress');
end
