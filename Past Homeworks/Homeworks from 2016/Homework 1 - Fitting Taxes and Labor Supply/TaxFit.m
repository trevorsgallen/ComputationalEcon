clear
data = [2113013	0	0
        10608111	1e-10	5000
        12030388	5000	10000
        12503345	10000	15000
        11621535	15000	20000
        10125285	20000	25000
        8809515	25000	30000
        14473606	30000	40000
        11279394	40000	50000
        19229309	50000	75000
        12574107	75000	100000
        16425446	100000	200000
        4488110	200000	500000
        724251	500000	1000000
        156269	1000000	1500000
        64236	1500000	2000000
        91128	2000000	5000000
        21412	5000000	10000000
        12839	10000000	Inf];
    
        data(:,1) = data(:,1)./sum(data(:,1));

        fcn_cdf = @(beta,x) beta(1) + (1-beta(1)).*cdf('logn',x,beta(2),beta(3))
        fcn_pdf = @(beta,x)  (1-beta(1)).*pdf('logn',x,beta(2),beta(3))

        fcn_cdf_vec = @(beta) [fcn_cdf(beta,data(1,2)) ;
                               (fcn_cdf(beta,data(2,3))-fcn_cdf(beta,data(2,2))) ;
                                (fcn_cdf(beta,data(3,3))-fcn_cdf(beta,data(3,2))) ;
                                (fcn_cdf(beta,data(4,3))-fcn_cdf(beta,data(4,2))) ;
                                (fcn_cdf(beta,data(5,3))-fcn_cdf(beta,data(5,2))) ;
                               (fcn_cdf(beta,data(6,3))-fcn_cdf(beta,data(6,2))) ;
                                (fcn_cdf(beta,data(7,3))-fcn_cdf(beta,data(7,2))) ;
                                (fcn_cdf(beta,data(8,3))-fcn_cdf(beta,data(8,2))) ;
                                (fcn_cdf(beta,data(9,3))-fcn_cdf(beta,data(9,2))) ;
                               (fcn_cdf(beta,data(10,3))-fcn_cdf(beta,data(10,2))) ;
                                (fcn_cdf(beta,data(11,3))-fcn_cdf(beta,data(11,2))) ;
                                (fcn_cdf(beta,data(12,3))-fcn_cdf(beta,data(12,2))) ;
                                (fcn_cdf(beta,data(13,3))-fcn_cdf(beta,data(13,2))) ;
                               (fcn_cdf(beta,data(14,3))-fcn_cdf(beta,data(14,2))) ;
                                (fcn_cdf(beta,data(15,3))-fcn_cdf(beta,data(15,2))) ;
                                (fcn_cdf(beta,data(16,3))-fcn_cdf(beta,data(16,2))) ;
                                (fcn_cdf(beta,data(17,3))-fcn_cdf(beta,data(17,2))) ;
                                (fcn_cdf(beta,data(18,3))-fcn_cdf(beta,data(18,2))) ;
                                1-fcn_cdf(beta,data(19,2))] 

     fcn_cdf_fit_disp = @(beta) [fcn_cdf_vec(beta),data(:,1)]
     fcn_cdf_fit = @(beta) sum((fcn_cdf_vec(beta)-data(:,1)).^2)
 
    X = fminsearch(fcn_cdf_fit,[0.2,5,5])
    
     fcn_cdf_fit_disp(X)
     fcn_cdf_fit(X)
 
     scatter(log(data(:,3)),log(cumsum(data(:,1))))
     hold on
     scatter(log(data(:,3)),log(fcn_cdf(X,data(:,3))))

     fcn_pdf_temp = @(x) x.*fcn_pdf(X,x)
     integral(fcn_pdf_temp,0,Inf)

 %Psi's
    L.^((1-epsilon)./epsilon) =1./psi

