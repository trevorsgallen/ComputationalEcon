function [InitialObservation, LoggedSignal] = myResetFunction()
    % Initial values [K,A,step]
%     state = [1+rand*499 ; 0.75+rand(1,1)*0.5 ; 1];
    state = [110+rand*370 ; 0.75+rand(1,1)*0.5 ; random('Discrete Uniform',200,1)];
    % Return initial environment state variables as logged signals.
    LoggedSignal = state;
    InitialObservation = state;
end
