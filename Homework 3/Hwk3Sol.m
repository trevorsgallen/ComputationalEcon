clear

[0.838617877293502 , 0.3203125]
[0.834545084301439         0.408177692184418]
[0.834545084301439         0.408177692184418]
[0.896666979950875         0.026759640395192]
[0.887917386685483         0.425294214000028]
[       0.8904      0.36511]

    theta_init = [0.95,0]
%     theta_init = [ 0.84                       0.3]
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

    ind = find(sto(:,1) >= 0.8904-0.05 & sto(:,1) <= 0.8904+0.05 & sto(:,2) >= 0.36511-0.05 & sto(:,2) <= 0.36511+0.05)
    figure(1)
    subplot(2,2,1)
    scatter3(sto(ind,1),sto(ind,2),sto(ind,3))
    xlabel('Beta')
    ylabel('Savings Variance')
    zlabel('Total Squared Error')
    subplot(2,2,2)
    scatter3(sto(ind,1),sto(ind,2),sto(ind,4))
    xlabel('Beta')
    ylabel('Savings Variance')
    zlabel('Error in First Moment')
    subplot(2,2,3)
    scatter3(sto(ind,1),sto(ind,2),sto(ind,5))
    xlabel('Beta')
    ylabel('Savings Variance')
    zlabel('Error in Second Moment')
    saveas(gcf,'IdentificationFig2.png')


    out=gamultiobj(@(Theta)EstFun(Theta),2,[],[],[],[],[0.7,0.001],[0.97,0.5],[],[],gaoptimset('Display','iter','PopulationSize',20,'TimeLimit',(12*3600)))
% asdf
theta1_vec = linspace(0.8,0.95,20);
theta2_vec = linspace(0.001,0.5,20);

[theta1_grid,theta2_grid]=ndgrid(theta1_vec,theta2_vec);
err_grid = NaN(size(theta1_grid));
err1_grid = NaN(size(theta1_grid));
err2_grid = NaN(size(theta1_grid));

counter=0
tic
for theta1_ind = 1:length(theta1_vec)
    for theta2_ind = 1:length(theta2_vec)
        theta1 = theta1_vec(theta1_ind);
        theta2 = theta2_vec(theta2_ind);
        counter = counter+1;
        [err,out]=EstFun([theta1,theta2]);
        err_grid(theta1_ind,theta2_ind)=err;
        err1_grid(theta1_ind,theta2_ind)=out(4);
        err2_grid(theta1_ind,theta2_ind)=out(5);
        [counter,toc]
    end
end

err1_fxn = griddedInterpolant(theta1_grid,theta2_grid,err1_grid);
err2_fxn = griddedInterpolant(theta1_grid,theta2_grid,err2_grid);
% 
err1_zeros = [];
err2_zeros = [];
for theta1_ind = 1:length(theta1_vec)
    theta1 = theta1_vec(theta1_ind);
    temp=fzero(@(x)err1_fxn(theta1,x),[0.03]);
    err1_zeros(end+1,:)=temp;
    temp=fzero(@(x)err2_fxn(theta1,x),[0.03]);
    err2_zeros(end+1,:)=temp;
end

plot(theta1_vec,err2_zeros)
