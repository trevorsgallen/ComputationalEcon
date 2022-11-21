clear

    theta_init = [0.95,0]
tic
    EstFun(theta_init)
    toc

    %This is time-consuming, so it's nice to save your place with
    %surrogateopt.  (Could do this manually with other solvers, by storing the input and
    %output in a file, opening the file each call and skipping the solution
    %if we already have it).
    opts = optimoptions('surrogateopt','CheckpointFile','checkfile.mat','InitialPoints',[0.8,0.01;0.97,0.01;0.8,0.3;0.97,0.3;0.8,0.5;0.97,0.5],'PlotFcn','surrogateoptplot');
    ans = surrogateopt(@(theta)EstFun(theta),[0.8,0],[0.999,0.5],opts)
    
    sto = sto(2:end,:)

    figure(1)
    subplot(2,2,1)
    scatter3(sto(:,1),sto(:,2),sto(:,3))
    xlabel('Beta')
    ylabel('Savings Variance')
    zlabel('Total Squared Error')
    subplot(2,2,2)
    scatter3(sto(:,1),sto(:,2),sto(:,4))
    xlabel('Beta')
    ylabel('Savings Variance')
    zlabel('Error in First Moment')
    subplot(2,2,3)
    scatter3(sto(:,1),sto(:,2),sto(:,5))
    xlabel('Beta')
    ylabel('Savings Variance')
    zlabel('Error in Second Moment')
    saveas(gcf,'IdentificationFig.png')
