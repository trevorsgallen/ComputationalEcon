clear
% close all

%Set out maximum number of periods
    Tmax = 20

%This vector of all the possible beauties (assumed uniform)
    offer_vec = [1:100];

%Count up number of possibilities so we can loop
    offer_num = length(offer_vec)
    
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
            %Compare offer to expected value next period (which is the
            %E(V(beauty')), which is just the average of the values).
            [valmax,choice_ind] = max([(1./offer_num).*sum(Val(:,t+1)),offer])
            %Store max and policy (accept = 1 if accept, 0 otherwise)
                Val(off_ind,t) = valmax;
                accept(off_ind,t) = choice_ind-1;
        end
end
%This is the policy function
    accept
    
%I'm going to add a row onto accept so the edges graph out ok
    accept_graph = [accept;ones(1,size(accept,2))]
    figure(2)
    accept_graph = [accept_graph,ones(size(accept_graph,1),1)]
    pcolor([accept_graph])
    shading flat
    title('Threshold for Accepting by Time')
    xlabel('Time')
    ylabel('Beauty of Offer')
    annotation('textbox', [0.2,0.4,0.1,0.1],...
           'String', 'Reject','Color','White')
    annotation('textbox', [0.8,0.7,0.1,0.1],...
           'String', 'Accept','Color','White')