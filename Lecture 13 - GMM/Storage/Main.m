clear
rng(0)
thetaguess = [5 5 5 5 5 5 0 ]

psoptions = psoptimset('PlotFcns',@psplotbestf,'SearchMethod',@MADSPositiveBasisNp1,'PollingOrder','success')
x0 = patternsearch(@Estimation,thetaguess,[],[],[],[],[],[],[],psoptions)

thetatrue = [2 3 10 20  3  4  2]

gaoptions = gaoptimset('InitialPopulation',[thetaguess;x0],'Plotfcns',@gaplotbestf)
x0 = ga(@Estimation,7,[],[],[],[],[],[],[],gaoptions)

thetatrue = [2 3 10 20  3  4  2]