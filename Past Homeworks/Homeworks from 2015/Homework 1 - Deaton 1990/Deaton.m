clear

%Parameters
    rho = 2;
    beta = 0.9;
    r = 0.02;
    mu = 100;
    sigma = 10;
    phi = 0.0;

asset_min = 0;
asset_max = 140;
asset_num = 10;
asset_space = linspace(asset_min,asset_max,asset_num);

y_min = 20;
y_max = 200;
y_num = 15;
y_space = linspace(y_min,y_max,y_num);


[asset_grid,y_grid]= ndgrid(asset_space,y_space)

Vold = zeros(asset_num,y_num);
Vnew = zeros(asset_num,y_num);

error = 1;
z = 0;
while error > 1e-10
    z = z+1;
    %Create an interpolating polynomial...this is like creating a function
    %to interpolate, rather than always using the interp command
        Vold_F = griddedInterpolant(asset_grid,y_grid,Vold,'spline');
    for asset_ind = 1:asset_num
        for y_ind = 1:y_num
            tic
            yt = y_space(y_ind);
            At = asset_space(asset_ind);
            
            %Gauss-Hermite quadrature (points and weights) 
                %Note: this uses the compecon toolbox of Miranda and
                %Fackler...we could have used my Chebfull as well.
                %For shocks between a -50 shock and a +50 shock, find 21
                %points and weights
                [x,w]=qnwcheb(21,-50,50);
            %For each state, find all (21) possible new states to evaluate
                ynext = (mu+phi*(yt-mu))+x;
            %The probability of each new state
                yprob = (1./sqrt(2*pi*(sigma.^2))).*exp(-((ynext-(mu+phi*(yt-mu))).^2)./(2.*(sigma.^2)));
            %Here I cutoff my new states (I didn't have to do this, but I
            %expected you would do this too).
                ynext = max([ynext,ones(length(ynext),1)*y_min]')';
                ynext = min([ynext,ones(length(ynext),1)*y_max]')';
                
            %Calculate expected utility given choice of c.  I have 21
            %different sample points of f(y_{t+1})*u(.).  I want the
            %integral of that function, which I do by multiplying the
            %function by my weights w.
                if rho == 1
                    ut = @(c) -sum(w.*yprob.*(log(c) + beta*Vold_F(min([ones(length(ynext),1)*((1+r)*At+yt - c),ones(length(ynext),1)*asset_max]')',ynext )));
                else
                    ut = @(c) -sum(w.*yprob.*((c.^(1-rho))./(1-rho) + beta*Vold_F(min([ones(length(ynext),1)*((1+r)*At+yt - c),ones(length(ynext),1)*asset_max]')',ynext )));
                end
            %Choose the best c
                [temp1,temp2]=fminbnd(ut,0,(1+r)*At+yt);
                if isnan(temp2) == 1
                    asdf
                end
            %Store the policy function
                c_choice(asset_ind,y_ind) = temp1;
                s_choice(asset_ind,y_ind) = (1+r)*At+yt-temp1;
            %Store the value function
                Vnew(asset_ind,y_ind) = -temp2;
        end
    end
    %Find the error
        error = max(abs(reshape(Vold,[],1)-reshape(Vnew,[],1)))
        error_sto(z) = error;
    %Replace vold with vnew
        Vold = Vnew;
end

%Take final value function grid and make it a useable function
    Vold_F = griddedInterpolant(asset_grid,y_grid,Vold,'spline');

%Start out my single agent
    sim_A = 0;
    sim_y = mu;


rng(0)
bounds = [[0;cumsum(yprob(1:end-1))],cumsum(yprob)]
for t = 1:10000
    At = sim_A(t);
    yt = sim_y(t);
    
            %Do the same thing I did before for my simulated agent. 
                [x,w]=qnwcheb(21,-50,50);
                ynext = (mu+phi*(yt-mu))+x;
                yprob = (1./sqrt(2*pi*(sigma.^2))).*exp(-((ynext-(mu+phi*(yt-mu))).^2)./(2.*(sigma.^2)));
                yprob = yprob./sum(yprob);
                ynext = max([ynext,ones(length(ynext),1)*y_min]')';
                ynext = min([ynext,ones(length(ynext),1)*y_max]')';
                if rho == 1
                    ut = @(c) -sum(w.*yprob.*(log(c) + beta*Vold_F(min([ones(length(ynext),1)*((1+r)*At+yt - c),ones(length(ynext),1)*asset_max]')',ynext )));
                else
                    ut = @(c) -sum(w.*yprob.*((c.^(1-rho))./(1-rho) + beta*Vold_F(min([ones(length(ynext),1)*((1+r)*At+yt - c),ones(length(ynext),1)*asset_max]')',ynext )));
                end
        %Find the best consumption
            [temp1,temp2]=fminbnd(ut,0,(1+r)*At+yt);

    %Store it and consequent assets
        sim_c(t) = temp1;
        sim_A(t+1) = (1+r)*At+yt-temp1;
        temp = rand;
    
    %Create new stochastic income for next period
        sim_y(t+1) = (mu+phi*(yt-mu)) + sigma*randn;
end

%I'll just show you my plots
    plot(sim_y(1000:1200),'-k')
    hold on
    plot(sim_c(1000:1200)-50,'-b')
    plot(sim_A(1000:1200),'-r')
    title('Simulated Paths')
    legend('Y','C-50','A')
    xlabel('T')
    ylabel('Dollars')
