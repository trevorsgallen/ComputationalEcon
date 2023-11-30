function [out,ceq,V_1,accept] = VCheck(theta,V,seed,output,data,W)
    %This vector of all the possible beauties (assumed uniform)
        offer_vec = [1:100];

    %Count up number of possibilities so we can loop
        offer_num = length(offer_vec);

    %Blank out the value and policy functions
        V_0 = V;
        V_1 = NaN(offer_num,1);
        choice = zeros(offer_num);

    if strmatch(output,'nonlinc','exact')==1
        'Iterating V'
        %SINGLE LOOP
        for off_ind = 1:offer_num
            %Look up offer
            offer = offer_vec(off_ind);
            %Distribution of probabilities
            pr = pdf('Normal',theta(1),theta(2),offer_vec);
            pr = pr./sum(pr);
    
            [valmax,choice_ind] = max([sum(pr'.*V_0),offer]);
            %Store max and policy (accept = 1 if accept, 0 otherwise)
                V_1(off_ind) = valmax;
                accept(off_ind) = choice_ind-1;
        end
    
        %Output can be for nonlinear constraint, value function, or policy
        %function
        out = [];
        ceq = V_1-V_0;
        'Done Iterating V'
    end

    if strmatch(output,'estim','exact')==1
        'Evaluating Estim'
        num_i = 100000;
        %Now simulate many individuals, storing their stopping period and final
        %draw
        endstep = zeros(num_i,1);
        enddraw = zeros(num_i,1);
    
        pd = makedist('Normal',theta(1),theta(2));
        pdtrunc = truncate(pd,1,100);
        for i = 1:num_i
            rng(300000+i)
            accepted = 0;
            t = 1;
            while accepted == 0 & t <= 1000
                draw = random(pdtrunc,1);
                pr = pdf('Normal',theta(1),theta(2),offer_vec);
                pr = pr./sum(pr);
                [valmax,choice_ind] = max([sum(pr'.*V_0(:)),draw]);
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
        out = [reshape(endstep,[],1),reshape(enddraw,[],1)];
        mod = mean(out)';
        G = repmat(mod,1,size(data,1))-data';
        g = mean(G,2);
    
        out = g'*W*g;
        ceq = [];
        'Done evaluating estim'
    end



end