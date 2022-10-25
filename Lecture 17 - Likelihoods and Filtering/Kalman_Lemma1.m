clear

mu = [0,0];
s_xx = 2;
s_xy = 0.1;
s_yy = 3;

sigma = [s_xx , s_xy ; s_xy , s_yy];

[xy]=mvnrnd(mu,sigma,1000);
       
x = xy(:,1);
y = xy(:,2);

X = [ones(length(x),1),y];

beta = inv(X'*X)*X'*x;

s_xgy_sim = var(x-beta*X')

s_xgy_alt = s_xx-s_xy*inv(s_yy)*s_xy
