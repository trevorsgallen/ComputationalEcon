function [InitialObservation, LoggedSignal] = myResetFunction()
    %Initial wage offer
%         InitialObservation= random('Uniform',0,200);
        InitialObservation= random('lognormal',1,3);
        LoggedSignal=InitialObservation;
end

 