clear

%Parameterization
    beta = 0.95;
    A = 1;
    delta = 0.05;
    gamma =0.6;

%Human capital space
    h_space = linspace(0.1,30,100);

%Initialize value function and policy
    V_0 = zeros(size(h_space));
    V_1 = zeros(size(h_space));
    i_policy = 0.5*ones(size(h_space));

error = Inf;
while error > 1e-10
    for h_ind = 1:length(h_space)
        %Look up value for h
        h = h_space(h_ind);

        %Define utility, plugging in constraints
        ut = @(i) log(h*(1-i))+beta*interp1(h_space,V_0,(1-delta)*h+A.*i.^gamma,'makima');

        %Minimize the negative, start at best policy from last iteration
        [temp1,temp2]=fmincon(@(i)-ut(i),i_policy(h_ind),[],[],[],[],0.0001,0.9999,[],optimset('Display','off'));

        V_1(h_ind) = -temp2;
        i_policy(h_ind) = temp1;
    end
    error = max(abs(V_1-V_0))
    V_0 = V_1;
end

%Plot the policy function
    figure(1)
    plot(h_space,i_policy)
    xlabel('h')
    ylabel('i')
    title('Policy Function')

%Simulate
    h_sim = random('uniform',1,15,100,1);
    for t = 1:40
        i_sim(:,t)=interp1(h_space,i_policy,h_sim(:,t));
        h_sim(:,t+1)=(1-delta)*h_sim(:,t)+A.*i_sim(:,t).^gamma;
    end

    figure(2)
    plot(h_sim')
    xlabel('t')
    ylabel('h')
    title('Simulated Paths of Human Capital')

%Find steady state human capital using fzero
    hstar = fzero(@(h) (1-delta)*h+A.*interp1(h_space,i_policy,h).^gamma - h,6);
