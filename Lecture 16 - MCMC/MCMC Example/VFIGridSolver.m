function out = VFIGridSolver(b)
    if exist('b')==0
        b =     [    0.0302
                0.6637
               -0.0245
                0.9750
                0.0644
                0.9275
                0.0010
               -0.7915
               -0.0149
               -1.0032]
    end
%Parameterization
        beta = 0.95;
        gamma =0.5;
    
    %Parameter space
        A_space = linspace(0.85,1.15,5);
        delta_space = linspace(0.02,0.08,5);
    
    %Human capital space
        h_space = linspace(0.1,20,100);
    
    %Make into grids
        [A_grid,delta_grid,h_grid]=ndgrid(A_space,delta_space,h_space);
    
    %Initialize value function and policy
        V_0 = b(1)+b(2).*A_grid+b(3).*delta_grid+b(4).*h_grid+b(5).*A_grid.^2+b(6).*delta_grid.^2+b(7).*h_grid.^2+b(8).*A_grid.*delta_grid+b(9).*A_grid.*h_grid+b(10).*delta_grid.*h_grid;
        V_1 = zeros(size(h_grid));
        i_policy = 0.5*ones(size(h_grid));
    
        tic
    error = Inf;
    while error > 1e-2
        for A_ind = 1:length(A_space)
            for delta_ind = 1:length(delta_space)
                for h_ind = 1:length(h_space)
                    %Look up value for h
                    delta = delta_space(delta_ind);
                    h = h_space(h_ind);
                    A = A_space(A_ind);
    
                    %Define utility, plugging in constraints
                    ut = @(i) log(h*(1-i))+beta*interp1(h_space,squeeze(V_0(A_ind,delta_ind,:)),(1-delta)*h+A*(i.^gamma),'makima');
            
                    %Minimize the negative, start at best policy from last iteration
                    [temp1,temp2]=fmincon(@(i)-ut(i),i_policy(A_ind,delta_ind,h_ind),[],[],[],[],0.0001,0.9999,[],optimset('Display','off'));
            
                    V_1(A_ind,delta_ind,h_ind) = -temp2;
                    i_policy(A_ind,delta_ind,h_ind) = temp1;
                    hnext_policy(A_ind,delta_ind,h_ind) = (1-delta)*h+A*i_policy(A_ind,delta_ind,h_ind)^gamma;
                end
            end
        end
        error = max(abs(V_1-V_0),[],'all')
        toc
        V_0 = V_1;
    end

    out.hnext_policy = hnext_policy;
    out.A_grid = A_grid;
    out.delta_grid = delta_grid;
    out.h_grid = h_grid;
end
