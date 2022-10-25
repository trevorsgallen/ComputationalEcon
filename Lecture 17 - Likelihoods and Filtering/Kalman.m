clear;
close all;
clc;


H = 1;
PHI = 3;
SIGMA = 10;

F = 1;

T = 100;
xi_true(1) = 0;
for t = 2:T
    if t >= 2
        xi_true(t) = F.*xi_true(t-1)+random('normal',0,PHI);
%         xi_true(t) = 0;
    end
    Y(t) = H.*xi_true(t)+random('normal',0,SIGMA);
end

%% Kalman filter
    %Initial beliefs and certainty:
        xihat_tgtm1 = 0;
        omega_tgtm1 = 0;
    for t = 1:T
        %First step: forecasts
            %Forecast Y_t
                Yhat(t) = H.*xihat_tgtm1(t);
            %Calculate S_yygt
                S_yygt(t) = H*omega_tgtm1(t)*H+SIGMA;
        
        %Second step: update
            %Find mean beliefs today
                S_xiygt(t) = omega_tgtm1(t)*H;
                G_t(t) = S_xiygt(t)*inv(S_yygt(t));
                epsilon(t) = Y(t)-Yhat(t);
                xihat_tgt(t) = xihat_tgtm1(t)+G_t(t)*epsilon(t)';
                omega_tgt(t) = omega_tgtm1(t)-S_xiygt(t)*inv(S_yygt(t))*S_xiygt(t);
                
        %Forecast step
            xihat_tgtm1(t+1) = F*xihat_tgt(t);
            omega_tgtm1(t+1) = F*omega_tgt(t)*F+PHI;
    end

plot([1:length(xi_true)],xi_true,'-r')
hold on
plot([1:length(xi_true)],Y,'-ob')
plot([1:length(xi_true)],xihat_tgt,'-xk')
scatter([1:length(xi_true)],Y,'ob')
legend('Hidden State','Signal','Belief','Location','Best')
title('Filtering a Noisy Process')
xlabel('Time')
ylabel('\xi_t,y_t')
hgf
sum(abs(xi_true-xihat_tgt))
sum(abs(xi_true-Y))