clear
load('myagent.mat','agent')
    clear vsto actionsto

load('../Discrete_VFI/discrete.mat')

    for k_ind = 1:numel(unique(k_grid))
            [k_ind./numel(unique(k_grid))]
        for A_ind = 1:numel(unique(A_grid))
            k = k_grid(A_ind,k_ind);
            A = A_grid(A_ind,k_ind);
            vsto(A_ind,k_ind)=getValue(getCritic(agent),{[k,A,1]},getAction(getActor(agent),{[k,A,1]}));
            Actionsto(A_ind,k_ind)=(1-cell2mat(getAction(getActor(agent),{[k,A,1]}))).*((1-delta)*k+A*k^alpha);
        end
    end

%     ind = (k_grid >= 200 & k_grid< 300 & A_grid >= 0.9 & A_grid <= 1.05)
figure(1)
surf(k_grid,A_grid,vsto)
hold on
surf(k_grid,A_grid,V_0)
title('VFI and RL Value Functions')
xlabel('k')
ylabel('A')
zlabel('Value')

figure(2)
surf(k_grid,A_grid,Actionsto)
shading flat
hold on
surf(k_grid,A_grid,k_best)
shading flat
title('VFI and RL Policy Functions')
xlabel('k')
ylabel('A')
zlabel('Savings Rate')


figure(3)
surf(k_grid,A_grid,(Actionsto-k_best)./k_best)
shading flat
title('Pct Diff Between VFI and RI Policies')
xlabel('k')
ylabel('A')
zlabel('Pct Diff')

%Now simulate
    %Simulate RL
        rho = 0.95;
        k = 144;
        alpha=0.7;
        delta = 0.07;
        rng(1)
        A = 1;
        for t = 2:5000
            sav = cell2mat(getAction(getActor(agent),{[k(t-1),A(t-1),1]}));
            totinc = (1-delta)*k(t-1)+A(t-1)*k(t-1)^alpha;
            cons = sav.*totinc;
            k(t) = (1-sav).*totinc;
            A(t) = (1-rho)*1+rho*A(t-1)+0.02*randn;
        end
        k_RL = k;

    %Simulate VFI
        for t = 2:5000
            k(t) = interp2(k_grid,A_grid,k_best,k(t-1),A(t));
            totinc = (1-delta)*k(t-1)+A(t-1)*k(t-1)^alpha;
        end


fcn = @(x)interp2(k_grid,A_grid,(Actionsto-k_best)./k_best,x(:,1),x(:,2))
figure(3)
surf(k_grid,A_grid,(Actionsto-k_best)./k_best)
shading flat
hold on
scatter3(k_RL,A,fcn([k_RL',A']),20,'r','filled')
scatter3(k_RL,A,fcn([k',A']),20,'g','filled')
xlabel('k')
ylabel('A')

figure(4)
plot(k_RL)
hold on
plot(k)
legend('RL Simulation','VFI Simulation')
xlabel('Time')
ylabel('Capital')

figure(8)
plot(100*(k_RL./mean(k_RL)-1))
hold on
plot(100*(k./mean(k)-1))
legend('RL Simulation','VFI Simulation')
xlabel('Time')
ylabel('Percent Deviation from Mean')


figure(9)
scatter(100*(k_RL./mean(k_RL)-1),100*(k./mean(k)-1))
xlabel('K Deviation (RL)')
ylabel('K Deviation (VFI)')


