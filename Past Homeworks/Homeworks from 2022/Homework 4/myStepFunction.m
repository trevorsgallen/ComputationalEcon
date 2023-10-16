function [NextObs,Reward,IsDone,LoggedSignal] = myStepFunction(Action,State)

    %Import state and action variables
        w = State(1);

    %Actions
        accept = Action(1);
%         accept = Action(1)>0  %Use if continuous actor, rather than
%         discrete

    %Determine if person dies this period
        die = (rand<0.067);

    %If accept and don't die
        if accept == 1 & die == 0
            utility = w./(1-0.95*(1-0.067));
            Reward = utility;
            IsDone = 1;
            NextObs = w;
            LoggedSignal=NextObs;
        end
    %If don't accept and don't die
        if accept == 0 & die == 0
            Reward = 0;
%               NextObs= random('Uniform',0,200);
            NextObs = random('lognormal',1,3);
            LoggedSignal=NextObs;
            IsDone = 0;
        end
    %If die
        if die == 1
            Reward = 0;
            IsDone = 1;
            NextObs = 0;
            LoggedSignal = 0;
        end

end