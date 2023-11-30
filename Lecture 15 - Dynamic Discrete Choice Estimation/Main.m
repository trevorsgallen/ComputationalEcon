%This code estimates the offer distribution of a Helen of Troy/McCall-style search model from data on accepted offers and time periods.
clear
close all

N = 100000;
%First, generate the data
[~,data,temp]=HelenofTroy_Est([30,40],NaN,NaN,1,N);
[~,data,temp]=HelenofTroy_Est([30,40],data',eye(2),1,N);

%Next, do the first stage
    theta_init = [20,50];
    W_init = eye(2);
    %Throw to patternsearch
    parmhat = fminunc(@(theta)HelenofTroy_Est(theta,data',W_init,2,N),[theta_init'],optimset('Display','iter','TolX',1e-4,'DiffMinChange',1e-1))
    asdf
    % parmhat = fminunc(@(theta)HelenofTroy_Est(theta,data',W_init,2,N),[theta_init'],optimset('Display','iter','DiffMinChange',1e-2))
    parmhat_0 = parmhat;

%Now, find the variance-covariance matrix of errors
    [~,~,G]=HelenofTroy_Est(parmhat,data',W_init,2,N)
    omega=cov(G');

%Now, second stage: throw to patternsearch with new weighting matrix
    parmhat = fminsearch(@(theta)HelenofTroy_Est(theta,data',inv(omega),2,N),[parmhat_0],optimset('Display','iter','TolX',1e-4));

%Now, calculate standard errors
    [~,~,G]=HelenofTroy_Est(parmhat,data',inv(omega),2,N);
    G_mean = mean(G,2);
    %Need the Jacobian (how parameters affect model moments)
    d = NaN(length(G_mean),length(parmhat));
    pert = 1e-1;
    for thetaind = 1:length(parmhat)
        parm_temp = parmhat;
        parm_temp(thetaind)=parm_temp(thetaind)+pert;
        [~,~,G]=HelenofTroy_Est(parm_temp,data',inv(omega),2,N);
        d(:,thetaind)=mean(G,2)-G_mean;
    end
    d = d./pert;

    %Table of coefficients and standard errors
    t = array2table([parmhat,sqrt(diag(inv(d'*inv(cov(G'))*d))/N)],'VariableNames',{'theta' 'se'} )
% 
    %Standard error ellipses
    temp1 = (inv(d'*inv(cov(G'))*d))/N;

    %Find the eigen vectors & values
        [eigenvec, eigenval ] = eig(temp1);

    % Get the index of the largest eigenvector
    [largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
    largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);

    % Get the largest eigenvalue
    largest_eigenval = max(max(eigenval));

    % Get the smallest eigenvector and eigenvalue
    if(largest_eigenvec_ind_c == 1)
        smallest_eigenval = max(eigenval(:,2))
        smallest_eigenvec = eigenvec(:,2);
    else
        smallest_eigenval = max(eigenval(:,1))
        smallest_eigenvec = eigenvec(1,:);
    end

    % Calculate the angle between the x-axis and the largest eigenvector
    angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

    % This angle is between -pi and pi.
    % Let's shift it such that the angle is between 0 and 2pi
    if(angle < 0)
        angle = angle + 2*pi;
    end

    % Get the coordinates of the data mean
    avg = parmhat;

    % Get the 95% confidence interval error ellipse
    chisquare_val = 2.4477;
    theta_grid = linspace(0,2*pi);
    phi = angle;
    X0=avg(1);
    Y0=avg(2);
    a=chisquare_val*sqrt(largest_eigenval);
    b=chisquare_val*sqrt(smallest_eigenval);

% the ellipse in x and y coordinates 
ellipse_x_r  = a*cos( theta_grid );
ellipse_y_r  = b*sin( theta_grid );

%Define a rotation matrix
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

%let's rotate the ellipse to some angle phi
r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;

% Draw the error ellipse
plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')
hold on;
scatter(parmhat(1),parmhat(2))
hold on;
scatter(30,40)
legend('Estimated 95% Confidence Interval','Estimated Parameter Values','True Parameter Values')


