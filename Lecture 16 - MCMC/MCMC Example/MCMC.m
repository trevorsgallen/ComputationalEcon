function out = MCMC(init,prdata,prtheta,transition,data)
    t = 1;
    if t == 1
        theta_t = init;
    end
    for t = 2:100000
        %Draw a new theta
        thetahat = transition(theta_t(t-1,:));

        %Find log likelihood of data given thetahat
        num_1 = sum(log(prdata(thetahat(1),thetahat(2),data(:,1),data(:,2))));
        %Prior of thetahat
        num_2 = log(prtheta(thetahat(1),thetahat(2)));
        %Find log likelihood of data given theta
        den_1 = sum(log(prdata(theta_t(t-1,1),theta_t(t-1,2),data(:,1),data(:,2))));
        %Prior of theta
        den_2 = log(prtheta(theta_t(t-1,1),theta_t(t-1,2)));

        %MH Threshold
        logr = num_1+num_2-den_1-den_2;
        if log(rand) < min(log(1),logr)
            theta_t(t,:) = thetahat;
        else
            theta_t(t,:) = theta_t(t-1,:);
        end

    end
    out = theta_t;
end