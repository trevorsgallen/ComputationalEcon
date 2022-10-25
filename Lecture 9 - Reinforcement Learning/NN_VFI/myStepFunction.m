function [NextObs,Reward,IsDone,LoggedSignal] = myStepFunction(Action,LoggedSignal)

    endStep = 200;
    Knew = Action;
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
    normalize = 1;
    if normalize == 1
        Action = 0.05;
        totinc = (1-delta)*Kinit+A*Kinit^alpha;
        cons = 0.05.*totinc;
        Knew = (1-0.05).*totinc;
        Reward = log(cons)-(Action-0.05).^2;
    end
    if normalize == 0
        totinc = (1-delta)*Kinit+A*Kinit^alpha;
        cons = Action.*totinc;
        Knew = (1-Action).*totinc;
        Reward = log(cons);
    end
    
%     cons = A*Kinit^alpha*0.2;
%     Knew = Kinit;
%     Reward = log(A*Kinit^alpha*0.2);
    
    %New Logged signals (get shocked and moved)
        % New K
        state = [Knew;(1-rho)*1+rho*A+randn*0.02;step+1];
        
        LoggedSignal = state;

    %Pass these on as the next observation as well
        NextObs = LoggedSignal;
        

    %Done after T obs
        IsDone = (step==endStep);

end