

%1-D Function (one input, one output) I want to zero (solve equation)
    f1dzero = @(x) sin(x) + 10 - 3*x
    
%2-D Function (multiple inputs, same number of outputs) I want to zero
%(solve system of equations)
    f2dzero = @(x) [5*x(1)-x(2)  ; 
                    -3*x(2)+x(2) ]
    
%1-D Function (one input, one output) I want to minimize
    f1dmin = @(x) (x-5)^2;
    
%2-D Function (multiple inputs, one output) I want to minimize
    f2dmin = @(x) (x(1)-5)^2 + 100*(x(2)-x(1).^2).^2; 

    
%% 1 Dimensional Functions
    %1-D only, find zeros: Bisection Method (fzero with two inputs as bounds)
    [temp1,temp2]=fzero(f1dzero,[-10,10])

    %1-D only, find zeros: Newton's Method (fzero with one input as guesses)
    [temp1,temp2]=fzero(f1dzero,10)
    
    %1-D only, find minimum:  Minimization (fminbnd with two bounds)
        [temp1,temp2]=fminbnd(f1dmin,-10,10)
        
%% Multidimenstional Functions
    %Quasi-Newton: Find zeros with two guesses (one for each parameter)
        [temp1,temp2]=fsolve(f2dzero,[1,1])
        
    %Quasi-Newton: Find unconstained minimum (fminUNC)
        [temp1,temp2]=fminunc(f2dmin,[1,1])
        
    %Quasi-Newton: Find constrained minimum (fminCON) (see help for linear
    %inequalities and equality constraints, and nonlinear constraints)
        lb = [5,5];
        ub = [6,7];
        ineqA = []
        ineqB = []
        eqA = []
        eqB = []
        nonlincon = []
        [temp1,temp2]=fmincon(f2dmin,[1,1],ineqA,ineqB,eqA,eqB,lb,ub,nonlincon)


    %Nelder-Mead: Search for Minimum (fminSEARCH)
        [temp1,temp2]=fminsearch(f2dmin,[1,1])

    %Patternsearch: Search for Minimum (patternsearch)
        [temp1,temp2]=fminsearch(f2dmin,[1,1])

    %Genetic Algorithm: Population search for minimum (ga)
        %Note that this is different in that you only specify how many
        %inputs in the base command: you have to use options to tell it an
        %initial point or set of points, which I do here.
            gaoptions = gaoptimset('InitialPopulation',[1,1],'Display','iter','PopulationSize',10000);
            lb = [-Inf,-Inf];
            ub = [Inf,Inf];
        [temp1,temp2]=ga(f2dmin,2,ineqA,ineqB,eqA,eqB,lb,ub,nonlincon,gaoptions)

    %Particleswarm
        opts = optimoptions('particleswarm','InitialSwarmMatrix',[1,1]);
        [temp1,temp2] = particleswarm(f2dmin,2,[],[],opts)


    %Simulated Annealing (generally does terribly in my experience)
            lb = [-10000,-10000];
            ub = [10000,10000];
            simuloptions = optimoptions(@simulannealbnd,'TemperatureFcn',@temperatureboltz,'Display','iter','MaxIter',10000000,'MaxFunEvals',10000000,'TolFun',1e-20)
        [temp1,temp2]=simulannealbnd(f2dmin,[1,1],lb,ub,simuloptions)


