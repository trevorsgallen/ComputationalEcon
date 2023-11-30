function [err,out,G] = HelenofTroy_Est(theta,data,W,seed,num_i)

        rng(seed,'twister')
        %Set out maximum number of periods
        Tmax = 20;

    %This vector of all the possible beauties (assumed uniform)
        offer_vec = [1:100];

    %Count up number of possibilities so we can loop
        offer_num = length(offer_vec);

    %Blank out the value and policy functions
        Val = zeros(offer_num,Tmax+1);
        Val(:,end) = ones(offer_num,1);
        choice = zeros(offer_num,Tmax);

    %Loop backwards through time, starting at the period before death
    for t = Tmax:-1:1
        %Ask whether or not accepting or rejecting offer is better for each
        %offer
        for off_ind = 1:offer_num
            %Look up offer
            offer = offer_vec(off_ind);
            %Distribution of probabilities
            pr = pdf('Normal',theta(1),theta(2),offer_vec);
            pr = pr./sum(pr);

            [valmax,choice_ind] = max([sum(pr'.*Val(:,t+1)),offer]);
            %Store max and policy (accept = 1 if accept, 0 otherwise)
                Val(off_ind,t) = valmax;
                accept(off_ind,t) = choice_ind-1;
        end
    end

    %Now simulate many individuals, storing their stopping period and final
    %draw
    cum_pr = [0,cumsum(pr)];
    endstep = zeros(num_i,1);
    enddraw = zeros(num_i,1);

    pd = makedist('Normal',theta(1),theta(2));
    pdtrunc = truncate(pd,1,100);
    for i = 1:num_i
        rng(1000000*seed+i)
        accepted = 0;
        t = 1;
        while accepted == 0 & t <= Tmax
            draw = random(pdtrunc,1);
            pr = pdf('Normal',theta(1),theta(2),offer_vec);
            pr = pr./sum(pr);
            [valmax,choice_ind] = max([sum(pr'.*Val(:,t+1)),draw]);
            accepted=choice_ind-1;
            if accepted == 1
                endstep(i) = t;
                enddraw(i) = draw;
            end
            t = t+1;
        end
        if endstep(i) == 0
            endstep(i)=t;
            enddraw(i)=theta(1);
        end
    end

    %Percent of final draws above 85
    %mod(1,1)=length(find(enddraw>85))./length(enddraw);
    %Mean stopping step
    %mod(2,1)=mean(endstep);
    %Percent of final draws less than or equal to fifteen
    %mod(3,1)=length(find(enddraw<15))./length(enddraw);
    %Mean final draw
    %mod(4,1)=mean(enddraw);
    %Number of agents stopping at the first step
    %mod(5,1)=length(find(endstep==1))./length(endstep);
    %Number of steps belwo 
    %mod(6,1)=length(find(endstep==20))./length(endstep);

    
    out = [reshape(endstep,[],1),reshape(enddraw,[],1)];
    mod = mean(out)';

    try
        G = repmat(mod,1,size(data,2))-data;
        g = mean(G,2);
    
        err = g'*W*g;
    catch        
        err = NaN;
    end
    
    [theta(1),theta(2),err];
    figure(1)
    scatter(theta(1),theta(2))
    hold on
    scatter(30,40,'k','filled')
    hold on
    xlim([0,100])
    ylim([0,100])

end