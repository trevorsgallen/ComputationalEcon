%Basics of Matlab--A collection of commands we Learn

    %Preliminaries
        clear
        clc
        close all

    %Define a scalar
        x = 3;
        b = 2;
        
    %Look at output
        x*b
        x/b
        x = x+1
        
    %Silence output
        x = x+1;
        
    %Comment within output
        ['Is be am are was were been equals: ',num2str(x)]
        
    %Define a row vector
        X_row = [1,2,3,4,50,20]
        X_col = [5;10;15;20;25;30]
        
%         x_row = [-3:0.23:6]
        X_row_2 = linspace(-3,6,100)'
        
    %Find maximum
        [temp1,temp2] = min(X_row);
        temp1 %<---- value
        temp2 %<---- index of highest value
        [temp1,X_row(temp2)] %<----are equal
        
    %Sum over vector
        sum(X_row)
    %Mean of vector
        mean(X_row)
    %Standard deviation, variance of vector
        std(X_row)
        var(X_row)
    %Skew of vector
        skewness(X_row)
    %Skew of vector
        kurtosis(X_row)

    %Cumulative sum
        cumsum(X_row)
        
    %Examine points within a vector
        X_row(1)
        X_row(2)
        X_row(1:3)
        
    %Matrix multiplication
        X_row*X_col
        X_col*X_row
        
    %Pointwise multiplication and division
        X_row.*X_col %<---- error!
        X_row.*X_col' %<----transpose
        [X_row',X_col,X_row'.*X_col]
        
    %Define a matrix
        X = [1+2 , 4+8 , 7-2 ; 2-6 , 5+2 , 8-1 ; 3-2 , 6 , 9]
        sum(X)
        [a,b] = max(X)
        
        %Identity matrix
            eye(3)
        %Matrix of ones
            ones(3,2)
        %Matrix of zeros
            zeros(2,3)
        %Matrix of NaN
            NaN(3,3)
        %Matrix of Inf
            Inf(2,2)
        %Diagonal matrix
            diag([1,2,3])
            
        %Some properties
            0/0
            0/0+1
            -Inf+1
            Inf/0
            Inf*NaN
            
            [NaN,1,3,Inf]+[2,4,5,6]
                    
    %Examine points within a matrix
        X(2:3,1:2)
        
    %Use the find command
        index = find(X > 4 & X < 7)
        X(index)
        X((X > 4 & X < 7))  %<--- faster!  logical statements

        
    %Use the reshape command
        X_vec = reshape(X,[],1)
        
    %Loop over entries
            for row_ind = 1:1:3
                for col_ind = 1:3
                    [row_ind,col_ind]
                    X_new(row_ind,col_ind) = X(row_ind,col_ind)+1;
                end
            end
        X
        X_new
        
    %While loops
        t = 0;
        while t < 10
            t=t+1;
            randomnum(t) = rand;
            randomnum_alt(t,1) = randn;
        end
        
    %Interpolate command: first, create some x-values and look at their
    %sizes
        x_space = [0:0.5:10]
        size(x_space)
        length(x_space)
        size(x_space,1)
        size(x_space,2)
        
    %Now, let's interpolate a function
        f_x = x_space.^2-20*sin(x_space)+1
        
%Graphing it out
        figure(1)
        plot(x_space,f_x,'--r')
        scatter(x_space,f_x)
        close all;
        figure(1)
        plot(x_space,f_x,'-k')
        hold on
        scatter(x_space,f_x)
        title('My graph')
        xlabel('X axis')
        ylabel('Y axis')
        legend('First entry','Second entry','Location','Best')
        annotation('textbox', [0.2,0.4,0.1,0.1],...
           'String', 'This is my annotation','Color','Black')

       %Now let's interpolate on an enhanced space.  
            x_space_enhanced = [0:0.001:10]
        %Interpolate for a single value
            f_x_interp = interp1(x_space,f_x,1)
        %Interpolate for the whole vector all at once!
            f_x_interp = interp1(x_space,f_x,x_space_enhanced)
            f_x_interpa = interp1(x_space,f_x,x_space_enhanced,'nearest')

        %Graph it
            figure(2)
            scatter(x_space_enhanced,f_x_interp)
            hold on
            scatter(x_space_enhanced,f_x_interpa)

        
        %Histogram
            figure(3)
            hist(f_x_interp,10)
            
        %Get list of unique values and unique rounded values
            unique(f_x_interp)
            unique(round(f_x_interp))


            unique([1,3,4; 1,3,4 ; 2,3,4])
        bar(x_space_enhanced,f_x_interp) %<---poor use of bar
        
    %Interpolate in many dimensions
        x_space = linspace(0,1,20);  %<---alternative way to make a vector
        y_space = [0:0.2:3];
        [x_grid,y_grid]=meshgrid(x_space,y_space);
        cobbdoug = ((x_grid.^0.5).*y_grid.^(0.5));
        surf(x_grid,y_grid,cobbdoug);
        hold on
        
        x_space_enhanced = [0:0.01:1];
        y_space_enhanced = [0:0.02:3];
        [x_grid_enhanced,y_grid_enhanced]=meshgrid(x_space_enhanced,y_space_enhanced);

        
        interpsurf = interp2(x_grid,y_grid,cobbdoug,x_grid_enhanced,y_grid_enhanced)
        scatter3(reshape(x_grid_enhanced,[],1),reshape(y_grid_enhanced,[],1),reshape(interpsurf,[],1))
        
    %Properties of Interp and NaN (common with VFI without extrapolation)
        interp1([1;2;3;4;5],[1;4;9;16;NaN],3)
        interp1([1;2;3;4;5],[1;4;9;16;NaN],3.5)
        interp1([1;2;3;4;5],[1;4;9;16;NaN],4.5)

    %Create some functions
        f(x) = x.^2+1  %<---- this won't do what you think it does!
        f = @(x) x.^2 + 1  %<---- this is how we define functions
        f(3)
        
        f = @(x,y) x+y
        close all
        surf(f(x_grid_enhanced,y_grid_enhanced))
        shading flat
        
    %Use the eval command  (CAREFUL!, goto of Matlab)
        x = 2;
        'This is x'
        eval(['''This is ',num2str(x),''''])
        for z = 1:3
            eval(['f',num2str(z),' = @(y) y.^',num2str(z)])
        end
        [f1(2) ; f2(2) ; f3(2)]
        
    %sub2ind functions
        rng(0,'twister');  % <- seed for random number genreation
        X = rand(4,3,2);
        
        %You can find a bunch of linear indicies:
            ind_lin = find(X < 0.5)
        %Or your can look up their corresponding array index
            [ind_1,ind_2,ind_3] = ind2sub(size(X),ind_lin)
            [ind_1,ind_2,ind_3]
        %Compare the two
            X_alt_1 = X(ind_lin);
            for t = 1:length(ind_1)
                X_alt_2(t,1) = X(ind_1(t),ind_2(t),ind_3(t));
            end
            [X_alt_1,X_alt_2]

    %We'll look at these more in the future, but just as a taste:
        %Function to minimize
            f_a_1 = @(x) x.^2+1-x;
            f_a_2 = @(x,y) (x-0.5).^2 + (y+0.5).^2 +1;
            
        %Function to zero
            f_b_1 = @(x) 10-x+2*sin(x)
            f_b_2 = @(x,y) 2*(x+1)+3*(y-2)+sin(x)+cos(y)
            
            
%Alternative from class
    temp = [0:0.01:13]
    find(sign(f_b_1(temp(1:end-1))') ~= sign(f_b_1(temp(2:end))'))
    
        %Find the zero (1-dimensional)
            [temp1,temp2] = fzero(f_b_1,0)
            [temp3,temp4] = fzero(f_b_1,[0,10])
            %Or use fsolve, which can handle multiple dimensions
            [temp5,temp6] = fsolve(f_b_1,0) 
            [temp7,temp8] = fsolve(f_b_1,9)
            
        %Find the zero (n-dimensional)
            %First restate the function so it takes a single vector input
                f_b_2_temp = @(x) f_b_2(x(1),x(2))
                [temp1,temp2] = fsolve(f_b_2_temp,[1,1])
            
        %Or minimize a function
                f_a_2_temp = @(x) f_a_2(x(1),x(2))
            %Nelder-Mead
                [temp1,temp2] = fminsearch(f_a_2_temp,[1,1])
            %Quasi-Newton Methods (depends on options)
                %Unconstrained
                    [temp1,temp2] = fminunc(f_a_2_temp,[1,1])
                %Constrained
                    lb = [-1,-1]
                    ub = [10,10]
                    [temp1,temp2] = fmincon(f_a_2_temp,[1,1],[],[],[],[],lb,ub)
            %Patternsearch
                    [temp1,temp2] = patternsearch(f_a_2_temp,[1,1],[],[],[],[],lb,ub)
            %Genetic Algorithm
                    [temp1,temp2] = ga(f_a_2_temp,2,[],[],[],[],lb,ub)
            %Simulated Annealing
                    [temp1,temp2] = simulannealbnd(f_a_2_temp,[0,0])
            %Particle Swarm
                    [temp1,temp2] =	` particleswarm(f_a_2_temp,2)
                    
             %Minimize a function that is just a cloud of points
  		Xtrue = linspace(-5,5,1000)
		Ytrue = (Xtrue-1).^2+5.*(Xtrue>-1.75)

		%Here's our "data"
             	 Xdata= linspace(-5,5,10)
	 	Ydata = (Xdata-1).^2+5.*(Xdata>-1.75)
		scatter(Xdata,Ydata)
		X_detailed = linspace(-5,5,100)
		f_interp = @(x) interp1(Xdata,Ydata,x,'spline')
		hold on
		plot(X_detailed,f_interp(X_detailed),'--r')
                  [temp1,temp2] = ga(f_interp,1,[],[],[],[],-5,5)
		plot(Xtrue,Ytrue)
		scatter(temp1,f_interp(temp1),'k','filled')
		


        %Example: Minimize a parameterized function
            f = @(x,y,beta,alpha) (x-alpha).^2+(y-beta).^2;
            fminunc(f,1) %<---- no good!
            f_temp = @(x) f(x(1),x(2),1,2)
            fminunc(f_temp,[1,2])
     
        %Sometimes all these solvers can be opaque...the next two weeks
        %will be deopacifying them.
            
%One last thing: structures can be used to group data together
    x = 1
    s = 'hello'
    
    mystruc.x = 3
    mystruc.s = 'This is my string'
    for z = 1:10
        mystruc.(['var',num2str(z)]) = 8675309-z
    end
    mystruc.var1+mystruc.var2
    
    
    