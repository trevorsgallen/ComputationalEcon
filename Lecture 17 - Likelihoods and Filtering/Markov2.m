clear
close all
rng(0)
%First, let's make the data
    p = [0.9 , 0.1 ; 0.05 , 0.95];

    mu_1 = 5;
    mu_2 = 10;
    sigma_1 = 2;
    sigma_2 = 10;
    
    T = 100;
    x_sim(1) = 1;
    for t = 1:T
        temp = rand;
        if x_sim(t) == 1 & temp < p(1,1)
            x_sim(t+1) = 1;
        elseif x_sim(t) == 1 & temp >= p(1,1)
            x_sim(t+1) = 2;
        end

        if x_sim(t) == 2 & temp < p(2,2)
            x_sim(t+1) = 2;
        elseif x_sim(t) == 2 & temp >= p(2,2)
            x_sim(t+1) = 1;
        end
        
        if x_sim(t) == 1
            y_sim(t) = mu_1+sqrt(sigma_1)*randn;
        elseif x_sim(t) == 2
            y_sim(t) = mu_2+sqrt(sigma_2)*randn;
        end
    end;
    
%Plot the data

%Estimate the likelihoods, given beliefs
    x_belief = [1;0];
    %pr(X|Y) = pr(X)*pr(Y|X)/pr(Y)

for t = 2:T
        %Pr in state 1:
            pr1 = x_belief(1,t-1).*p(1,1)+x_belief(2,t-1).*p(2,1);
        %Pr in state 2:
            pr2 = x_belief(1,t-1).*p(1,2)+x_belief(2,t-1).*p(2,2);
            
        %Bayes Rule
            x_belief(1,t) = pr1*pdf('norm',y_sim(t),mu_1,sigma_1)./(pr1*pdf('norm',y_sim(t),mu_1,sigma_1)+pr2*pdf('norm',y_sim(t),mu_2,sigma_2));
            x_belief(2,t) = pr2*pdf('norm',y_sim(t),mu_2,sigma_2)./(pr1*pdf('norm',y_sim(t),mu_1,sigma_1)+pr2*pdf('norm',y_sim(t),mu_2,sigma_2));
end
    
figure(1)
    subplot(2,1,1)
    %plot(x_sim(1:T)-1)
    hold on
    plot(x_belief(2,:),'--r')
    ylim([-0.1,1.1])
    title('Beliefs')
    xlabel('Period')
    subplot(2,1,2)
    plot(y_sim)
    title('Data')
    xlabel('Period')
    kjhg
   print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/Markov1.png','-dpng')

figure(2)
    subplot(2,1,1)
    %plot(x_sim(1:T)-1)
    hold on
    %plot(x_belief(2,:),'--r')
    ylim([-0.1,1.1])
    title('Beliefs')
    xlabel('Period')
    subplot(2,1,2)
    plot(y_sim)
    hold on
    plot([0,100],[5,5],'-r')
    hold on
    plot([0,100],[10,10],'-b')
   print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/Markov2.png','-dpng')

figure(3)
    subplot(2,1,1)
    %plot(x_sim(1:T)-1)
    hold on
    %plot(x_belief(2,:),'--r')
    ylim([-0.1,1.1])
    title('Beliefs')
    xlabel('Period')
    subplot(2,1,2)
    plot(y_sim)
    title('Data')
    xlabel('Period')
    hold on
    plot([0,100],[5,5],'-r')
    plot([0,100],[5+sqrt(4),5+sqrt(4)],'--r')
    plot([0,100],[5-sqrt(4),5-sqrt(4)],'--r')
    hold on
    plot([0,100],[10,10],'-b')
    plot([0,100],[10-sqrt(20),10-sqrt(20)],'--b')
    plot([0,100],[10+sqrt(20),10+sqrt(20)],'--b')
   print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/Markov3.png','-dpng')

figure(4)
   subplot(2,1,1)
    plot(x_sim(1:T)-1)
    hold on
    plot(x_belief(2,:),'--r')
    ylim([-0.1,1.1])
    title('Beliefs')
    xlabel('Period')
    subplot(2,1,2)
    plot(y_sim)
    title('Data')
    xlabel('Period')
    hold on
    plot([0,100],[5,5],'-r')
    plot([0,100],[5+sqrt(4),5+sqrt(4)],'--r')
    plot([0,100],[5-sqrt(4),5-sqrt(4)],'--r')
    hold on
    plot([0,100],[10,10],'-b')
    plot([0,100],[10-sqrt(20),10-sqrt(20)],'--b')
    plot([0,100],[10+sqrt(20),10+sqrt(20)],'--b')
   print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/Markov4.png','-dpng')

figure(5)
   subplot(2,1,1)
    hold on
    plot(x_belief(2,:),'--r')
    ylim([-0.1,1.1])
    title('Beliefs')
    xlabel('Period')
    subplot(2,1,2)
    plot(y_sim)
    title('Data')
    xlabel('Period')
   print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/Markov5.png','-dpng')
   
figure(6)
   subplot(2,1,1)
    plot(x_sim(1:T)-1)
    hold on
    plot(x_belief(2,:),'--r')
    ylim([-0.1,1.1])
    title('Beliefs')
    xlabel('Period')
    subplot(2,1,2)
    plot(y_sim)
    title('Data')
    xlabel('Period')
   print('~/Dropbox/Econ_641/Fall_2018/Lecture 17 - Likelihoods and Filtering/Markov6.png','-dpng')


    