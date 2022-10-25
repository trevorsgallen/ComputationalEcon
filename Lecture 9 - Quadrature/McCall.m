% The purpose of this file is to:
    %Better understand the McCall model
    %Do value function iteration with:
        %Interpolate (one dimension)
        %Integrate (one dimension)
    %Play around with different distributional forms
    
clear

%Parameters
    beta = 0.95;
    max_w = 5;
    
%Define space we'll iterate over
    w_vec = linspace(0,max_w,20);

    option = 1;
%Need to truncate standard normal distribution at zero
    if option == 1
        pdf_temp = @(w) pdf('Uniform',w,0,2.575)
        max_w = 2.575;
    end
    if option == 2
        pdf_temp = @(w) pdf('Normal',w,1,1)
    end
    if option == 3
        pdf_temp = @(w) pdf('T',w-0.5213,1)
    end

    area_under_curve = integral(pdf_temp,0,max_w);
    
%Truncated normal
    pdf_norm = @(w) pdf_temp(w)./area_under_curve;
    
    
%Expected value (should be 1.2875)
    interior = @(w) pdf_norm(w).*w;
    integral(interior,0,max_w)

%Check it integrates to one
    integral(pdf_norm,0,max_w);
    
%Value function initialization
    V_0 = zeros(1,length(w_vec));
    V_1 = V_0;
    
%Initialize error
error = Inf;
while error > 0.1
    %Loop over current draws
    for w_ind = 1:length(w_vec)
        %Look up current draw value
        wnow = w_vec(w_ind);
        
        %Expected value of a draw
             ev = @(w) pdf_norm(w).*interp1(w_vec,V_0,w);
        %Maximization choice: accept or don't
            [temp1,temp2] = max([wnow./(1-beta) , beta*integral(ev,0,max_w)])
        %Store value function and choice (choice=1 if reject, 2 if accept)
            V_1(w_ind) = temp1;
            choice_accept = temp2-1;
    end
    
    %Graph the value function
        figure(option)
        plot(w_vec,V_0);
        hold on
        drawnow
    %Define error
        error = max(abs(V_1-V_0))
    %Replace the old V_0 with V_1
        V_0 = V_1;
end

%Expected value of a random draw
    integral(ev,0,max_w)



