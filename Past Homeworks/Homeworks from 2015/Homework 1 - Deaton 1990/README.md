This homework, given in 2015, runs students through Angus Deaton's 1990 Econometrica article "Savings and Liquidity Constraints"

In this code, I make use of three functions from Miranda & Fackler (2002)'s textbook "Applied Computational Economics and Finance."  

1. gridmake.m, which like meshgrid or ndgrid makes a grid of points
2. csize.m, which returns cell sizes
3. ckron.m, which takes cell arrays and calculates Kronecker products
4. qnwcheb.m, which calculates quadrature nodes & weights, for interpolation/integration purposes

These are all called by the main function, Deaton.m, which:
1.  Solves the stochastic value function iteration problem posed by Deaton (1990) using value function iteration.
2.  Simulates results comparable to his.

Students may find this a helpful example of how to run value function iteration: 
1. Maximizing utility
2. Interpolating  the value function (using Chebyshev polynomials)
3. Integrating the expectation (again using Chebyshev quadrature rules)

The main seminal economic takeaways is that persistent shocks can't (or won't!) be insured against very well, while idiosyncratic ones can.  
