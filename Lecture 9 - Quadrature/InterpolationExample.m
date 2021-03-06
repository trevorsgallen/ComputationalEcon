clear

rng(1) 

w_vec = linspace(1,10,10);
m_vec = [0,1];
c_vec = [0,1,2,3,4];

[w_grid,m_grid,c_grid]=ndgrid(w_vec,m_vec,c_vec);

V = randn(size(w_grid));

V_interp_fxn_lin = griddedInterpolant(w_grid,m_grid,c_grid,V,'linear')
V_interp_fxn_spline = griddedInterpolant(w_grid,m_grid,c_grid,V,'spline')
V_interp_fxn_akima = griddedInterpolant(w_grid,m_grid,c_grid,V,'makima')

%Find interpolated value
    V_interp_fxn_lin(1,2,3)
%The function takes in matricies!
    V_interp_fxn_lin([1,2,3 ; 3 , 4, 5])
%Plot the two functions for comparison:
    w_vec_enhanced = linspace(1,10,100);
    
    figure(1)
    plot(w_vec_enhanced,V_interp_fxn_lin(w_vec_enhanced',2*ones(100,1),3*ones(100,1)),'-k')
    hold on
    plot(w_vec_enhanced,V_interp_fxn_spline(w_vec_enhanced',2*ones(100,1),3*ones(100,1)),'--r')
    hold on
    plot(w_vec_enhanced,V_interp_fxn_akima(w_vec_enhanced',2*ones(100,1),3*ones(100,1)),'--b')
    legend('Linear','Spline','Akima')
