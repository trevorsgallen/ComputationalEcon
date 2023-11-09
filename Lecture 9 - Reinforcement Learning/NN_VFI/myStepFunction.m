function [NextObs,Reward,IsDone,LoggedSignal] = myStepFunction(Action,LoggedSignal)

    endStep = 200;
    alpha=0.7;
    delta = 0.07;
    rho = 0.95;
    %Unpack the state
    State = LoggedSignal;
    Kinit = State(1);
    A = State(2);
    step = State(3);

    %Get reward
    if step==endStep;
        Action = 1;
    end
    totinc = (1-delta)*Kinit+A*Kinit^alpha;
    cons = Action.*totinc;
    Knew = (1-Action).*totinc;
    Reward = log(cons)+9.6;
    
    %New Logged signals (get shocked and moved)
        % New K
        state = [Knew;(1-rho)*1+rho*A+randn*0.02;step+1];
        
        LoggedSignal = state;

    %Pass these on as the next observation as well
        NextObs = LoggedSignal;

    %Done after T obs
        IsDone = (step==endStep);

end