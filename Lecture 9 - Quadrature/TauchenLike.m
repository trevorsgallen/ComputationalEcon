clear

%Random number generating seed
rng(8675309,'twister')

%Simulate an AR(1) data series.
rho = 0.95;
a = 1;
y = 1;

for t = 2:10000
    y(t) = (1-rho)*a+rho*y(t-1)+randn;
end

%Extract some of the relevant statistics
    targ.ymean = mean(y(5000:end)); %Unconditional average
    targ.uvar = var(y(5000:end));  %Unconditional variance
    targ.skew = skewness(y(5000:end)); %Unconditional skewness
    targ.kurt = kurtosis(y(5000:end)); %Unconditional kurtosis
    targ.dvar = var(y(5001:end)-y(5000:end-1)); %One-step variance
    targ.d2var = var(y(5002:end)-y(5000:end-2)); %Two-step variance

%Truly bad starting point
    thetainit = randn(1,30);

%Require that all rows add up to one
    A = zeros(5,30);
    %All rows add up to one
    A(1,1:5)=ones(1,5);
    A(2,6:10)=ones(1,5);
    A(3,11:15)=ones(1,5);
    A(4,16:20)=ones(1,5);
    A(5,21:25)=ones(1,5);
    B(1:5) = ones(5,1);
    %States are ordered
    Ain = zeros(4,30);
    Ain(6,26:27) = [1,-1];
    Ain(7,27:28) = [1,-1];
    Ain(8,28:29) = [1,-1];
    Ain(9,29:30) = [1,-1];
    Bin(6:9) = zeros(4,1);
    
    Pinit = [0.99 , 0.01 , 0    , 0    , 0   ;
            0.01  , 0.98 , 0.01 , 0    , 0   ;
            0     , 0.01 , 0.98 , 0.01 , 0   ;
            0     , 0    , 0.01 , 0.98 , 0.01;
            0     , 0    , 0    , 0.01 , 0.99];
    sinit = [0,0.5,1,1.5,2];

    Pinit = [     0.9419    0.0121    0.0005    0.0274    0.0180
    0.0186    0.5179    0.3510    0.0838    0.0287
    0.0014    0.1838    0.2291    0.4016    0.1842
    0.0790    0.3653    0.2445    0.0652    0.2461
    0.0082    0.1176    0.0397    0.0851    0.7494];
    sinit = [   -3.5700    3.7869    3.9259    4.0009    4.2980];
    mytheta = [reshape(Pinit',1,[]),sinit];

    mytheta = [    0.9576    0.0029    0.0006    0.0009    0.0380    0.0089    0.4667    0.1481     0.2794    0.0969    0.0011    0.4110    0.2898    0.2321    0.0662    0.0355     0.1818    0.5940    0.0802    0.1086    0.0243    0.0022    0.1364    0.1750     0.6620   -4.7394    3.1970    3.1960    3.1955    3.1945]

    myfit(mytheta,targ)

    mytheta = fmincon(@(theta) myfit(theta,targ),mytheta,Ain,Bin,A,B,[zeros(1,25),-10*ones(1,5)],[ones(1,25),10*ones(1,5)],[],optimset('Display','iter'));
    mytheta = patternsearch(@(theta) myfit(theta,targ),mytheta,Ain,Bin,A,B,[zeros(1,25),-10*ones(1,5)],[ones(1,25),10*ones(1,5)],[],psoptimset('Display','iter'));
    mytheta = ga(@(theta) myfit(theta,targ),30,Ain,Bin,A,B,[zeros(1,25),-10*ones(1,5)],[ones(1,25),10*ones(1,5)],[],[],gaoptimset('Display','iter','InitialPopulation',mytheta));

function err = myfit(theta,targ)
    rng(1,'twister')
    %First 25 entries are 
    P = reshape(theta(1:25),5,5)';
    %Could constrain, or just re-normalize so adds up to one and all
    %positive
    P = abs(P);
    P = P./sum(P,2);

    s = theta(26:30);
    %Create transition matrix from first 25 entries
    mc = dtmc(P);
    %Simulate 10,000 times
    ysim = simulate(mc,10000);
    %Look up actual values
    ysim = s(ysim);

    fit.ymean = mean(ysim);
    fit.uvar = var(ysim(5000:end));
    fit.dvar = var(ysim(5001:end)-ysim(5000:end-1));
    fit.d2var = var(ysim(5002:end)-ysim(5000:end-2));
    fit.skew = skewness(ysim(5000:end));
    fit.kurt = kurtosis(ysim(5000:end)); 

    err = sum([targ.ymean-fit.ymean;
           targ.uvar-fit.uvar;
           targ.dvar-fit.dvar;
           targ.d2var-fit.d2var;
           targ.skew-fit.skew;
           targ.kurt-fit.kurt].^2);
end

