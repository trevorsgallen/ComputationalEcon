clc;
clear;
% Define exogenous parameters of the model 
T    =  65; % Lifespan
T_prime = 45;
per  = (0:T-1)'; 
t = (1:T)';
psi  =  10; % Disutility of labor
eps  = .75; % Elasticity Labor supply
beta = .96; % Discount Factor
wage_vec = ones(T,1);
wage_vec(30) = 1.05;
wage_vec(T_prime+1:end)=0;
int_vec = 0.05*ones(T,1);
int_vec(20) = .1; 
% NPV discount rate 
NPV_r = cumprod(1./(1+int_vec));
 
% Utility Function

U_cl = @(c,L) log(c)-psi*(eps/(1+eps))*L.^((1+eps)/eps);

% A function of the lifetime excess savings

bc_lifetime_cl = @(c,L) sum(c.*NPV_r)-sum((wage_vec.*L).*NPV_r);

% Lifitime Utility Function with Penalty 
ut_lifetime = @(c,l) sum((beta.^per).*U_cl(c,l)) - 3.1*(bc_lifetime_cl(c,l) > 0)*bc_lifetime_cl(c,l);

% Lifitime Utility Function with no Penalty 

% ut_lifetime_no_pen = @(c,l) sum((beta.^per).*U_cl(c,l));


% Define new function for fminunc
ut_life_x = @(x) -(ut_lifetime(x(1:T),x(T+1:end)));

%fminunc :penalty term heavily affects the results 
x0_c = .3*ones(T,1);
x0_l = .5*ones(T,1); % initial condition 
x0 = [x0_c;x0_l];
options = optimset('MaxIter',1e10,'MaxFunEval',1e10,'TolFun',1e-10);
[x,fval1] = fminunc(ut_life_x,x0,options);
c_t = x(1:T);
l_t = x(T+1:end);
fig3 = figure(3);
subplot(2,1,1)
plot(t,c_t)
title("Optimization using Fminunc with retirement")
ylabel('$\mathbf{c_t}$:Consumption path','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
subplot(2,1,2)
plot(t,l_t)
ylabel('$\mathbf{L_t}$:Labor Supply','Interpreter','latex')
xlabel('$\mathbf{t}$','Interpreter','latex');
saveas(fig3,'Cons_Labor_Path_retirement_fminunc1.png');

% fmincon 
% define equality constraints 
A = [];
b = [];
Aeq = zeros(2*T,1)';
Aeq(1:T) = NPV_r';
Aeq(T+1:end) = -(wage_vec.*NPV_r)';
beq = 0;
lb = [];
ub = [];

% Define new function for fmincon
ut_life_no_pen_x = @(x,pen) -(ut_lifetime_no_pen(x(1:T),x(T+1:end),beta,per,U_cl,Aeq,beq,pen));
[x_fmincon,fval2,temp1,temp2,temp3,grad] = fmincon(@(x)ut_life_no_pen_x(x,0),x0,A,b,Aeq,beq,lb,ub);
c_t_fmincon = x_fmincon(1:T);
l_t_fmincon = x_fmincon(T+1:end);
fig4 = figure(4);
subplot(2,1,1)
plot(t,c_t_fmincon)
title("Optimization using Fmincon with retirement")
ylabel('$\mathbf{c_t}$:Consumption path','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
subplot(2,1,2)
plot(t,l_t_fmincon)
ylabel('$\mathbf{L_t}$:Labor Supply','Interpreter','latex')
xlabel('$\mathbf{t}$','Interpreter','latex');
saveas(fig4,'Cons_Labor_Path_retirement_fmincon2.png');

% savings = zeros(T+1,1);
% for i = 2:T+1
%    savings(i) = wage_vec(i-1)*l_t_fmincon(i-1)-c_t_fmincon(i-1)+(1+int_vec(i-1)*savings(i-1));
% end
% fig6 = figure(6);
% plot(t,savings(2:end));


% patternsearch 
%Doesn't work!
[x_pat,fval3,exitflag] = patternsearch(@(x)ut_life_no_pen_x(x,0),x0,[],[],Aeq,beq,[],[],psoptimset('Display','iter','InitialMeshSize',0.01));

%Does work!
    %Better starting guess
        [x_pat,fval3,exitflag] = patternsearch(@(x)ut_life_no_pen_x(x,0),0.2*ones(size(Aeq))',[],[],Aeq,beq,[],[],psoptimset('Display','iter','InitialMeshSize',0.01));
    %Inequality, rather than equality constraints
        [x_pat,fval3,exitflag] = patternsearch(@(x)ut_life_no_pen_x(x,0),0.2*ones(size(Aeq))',Aeq,beq,[],[],[],[],psoptimset('Display','iter','InitialMeshSize',0.01));
    %Punish the function for c<0 or l<0
        [x_pat,fval3,exitflag] = patternsearch(@(x)ut_life_no_pen_x(x,1),x0,[],[],Aeq,beq,[],[],psoptimset('Display','iter','InitialMeshSize',0.01));

[x_pat,fval3,exitflag] = patternsearch(ut_life_no_pen_x,0.2*ones(size(Aeq))',[],[],Aeq,beq,[],[],psoptimset('Display','iter','InitialMeshSize',0.01));
c_t_pat = x_pat(1:T);
l_t_pat = x_pat(T+1:end);
fig5 = figure(5);
subplot(2,1,1)
plot(t,c_t_pat)
title("Optimization using patternsearch with retirement")
ylabel('$\mathbf{c_t}$:Consumption path','Interpreter','latex')
xlabel('$t$','Interpreter','latex')
subplot(2,1,2)
plot(t,l_t_pat)
ylabel('$\mathbf{L_t}$:Labor Supply','Interpreter','latex')
xlabel('$\mathbf{t}$','Interpreter','latex');
saveas(fig5,'Cons_Labor_Path_retirement_patternsearch3.png');


