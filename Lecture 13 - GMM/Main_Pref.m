clear

%First simulate true DGS
    thetatrue = [5 5 5 5 5 5 1 ]
    [error,moment]=Estimation_Pref(thetatrue)
    
    moment(:,2) = moment(:,1);
    moment(:,1) = NaN(length(moment(:,1)),1)
    save moment.mat moment;

thetaguess = [4.9 5.1 4.9 5.1 4.9 5.1 0.9 ]
[error,moment]=Estimation_Pref(thetaguess)

% foptions = optimset('Display','iter','DiffMinChange',0.01)
% x0 = fminsearch(@Estimation_Pref,thetaguess,foptions)
% asdf
% x0 = fmincon(@Estimation_Pref,thetaguess,[],[],[],[],[],[],[],foptions)
% 
% psoptions = psoptimset('Display','iter','PlotFcns',@psplotbestf,'SearchMethod',@MADSPositiveBasisNp1,'PollingOrder','success')
% x0 = patternsearch(@Estimation_Pref,x0,[],[],[],[],[],[],[],psoptions)
% 
tic
gaoptions = gaoptimset('InitialPopulation',[thetaguess],'Plotfcns',@gaplotbestf,'PopulationSize',200,'PopInitRange',[thetaguess.*0.9;thetaguess.*(1./0.9)],'Display','iter')
x0 = ga(@Estimation_Pref,7,[],[],[],[],[],[],[],gaoptions)
toc