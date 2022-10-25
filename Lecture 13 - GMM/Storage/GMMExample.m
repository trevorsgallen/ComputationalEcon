clear

rng(0)
%Simulate data
    psi_1 = 1.1;
    psi_2 = 1;
    psi_3 = -0.3
    sigma2 = 2;

    I = 10000;

    X1 = 5*randn(I,1);
    X2 = 5*randn(I,1);
    error = sqrt(sigma2).*randn(I,4);
    
    U = @(P_1,P_2) psi_1*P_1+X1.*psi_2*P_2+psi_3.*X2.*P_1.*P_2
    U_choices = [U(0,0),U(1,0)+error(:,2),U(0,1)+error(:,3),U(1,1)+error(:,4)]
    max = max(U_choices')';
    choice = 1.*(U_choices(:,1)==max)+2.*(U_choices(:,2)==max)+3.*(U_choices(:,3)==max)+4.*(U_choices(:,4)==max);
    
    choice;
    
%Now create function that calculates simulated outcomes
    gmmmom([psi_1;psi_2;psi_3;sigma2],[X1,X2],choice)
    
    gmmmom_temp = @(theta) gmmmom(theta,[X1,X2],choice)
    
    gaoptions = gaoptimset('InitialPopulation',[psi_1;psi_2;psi_3;sigma2]','PlotFcns',@gaplotbestf,'Generations',20,'PopulationSize',20)
    
    x0 = ga(gmmmom_temp,4,[],[],[],[],[],[],[],[],gaoptions)
    [error_est,choice_est,Y_est] = gmmmom_temp(x0)
    [error_tru,choice_tru,Y_tru] = gmmmom_temp([psi_1;psi_2;psi_3;sigma2])
    
    [mean(choice_est==Y_est),mean(choice_tru==Y_tru)]
    
    [x0 ; psi_1 , psi_2 , psi_3 , sigma2]