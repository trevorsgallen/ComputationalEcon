%This .m file solves the problem from Homework 3 with a Linear-Quadratic
%Regulator (see Sargent & Ljungqvist, Recursive Macroeconomic Methods, for
%more details!  This can be seen as an application of the Ricatti Equation
%in Exercise 5.1, which deals with mixed state/control utility functions.

clear
tic
%Parameters
    phi=0.1;
    beta = 0.95;
    rho = 0.95;

%Put -(pbar-p).^2-phi*(p-ptm1).^2 into matrix form
    %In Sargent & Ljungqvists's notation,
    %state x = [pbar;ptm1]
    %control u = p;
    %R is the quadratic matrix of state alone
    %Q is the quadratic matrix for control alone
    %H is the quadratic matrix for state-control interactions
    %A is the state LOM (state portion)
    %B is the state LOM (control portion)

    R = [-1,0;0,-phi];
    Q = -(1+phi);
    H = [1,phi];
    A = [rho,0;0,0]
    B = [0;1];

%Test whether we got the matrix forms correct
    p = 1.05;
    pbar = 2.2;
    ptm1=1.5;
    x = [pbar;ptm1];
    u = p;

    ut1 = -(pbar-p).^2-phi*(p-ptm1).^2;
    ut2 = x'*R*x+u'*Q*u+2*u'*H*x;
    fprintf("%s %9.2f %s %9.2f %s",'Formula: ',ut1,' matrix form: ',ut2,' should be equal.')

    clear p pbar ptm1 x u ut1 ut2
%Now iterate on the Ricatti Equation (VERY fast!)
    P = zeros(2,2);
    Psto = P;
    err = Inf;
    while err > 0
        P = R+beta*A'*P*A-(beta*A'*P*B+H')*inv(Q+beta*B'*P*B)*(beta*B'*P*A+H);
        err = max(abs(Psto-P),[],'all');
        Psto = P;
    end

    %Value Function
    pbar_vec = [-0.15:0.02:0.15];
    ptm1_vec = [-0.15:0.01:0.15];
    [pbar_grid,ptm1_grid]=meshgrid(pbar_vec,ptm1_vec)
    for pbar_ind = 1:size(pbar_grid,2)
        for ptm1_ind = 1:size(pbar_grid,1)
            V(ptm1_ind,pbar_ind)=[pbar_vec(pbar_ind);ptm1_vec(ptm1_ind)]'*P*[pbar_vec(pbar_ind);ptm1_vec(ptm1_ind)]
        end
    end
    
    save('LQR.mat')

    hold on
    surf(pbar_grid,ptm1_grid,V)
    %Policy function 
    polfun = -inv(Q+beta*B'*P*B)*(beta*B'*P*A+H);

    fprintf("\n %s %9.3f %s %9.3f %s \n %s %9.2f %s",'Policy function is pt=',polfun(1),'*pbar+',polfun(2),'*ptm1.','Everything took ',toc,' seconds.')
    toc
