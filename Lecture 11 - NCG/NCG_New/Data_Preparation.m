%Import the data from NIPA (I, delta*K, Y, C)
    clear
    filename = 'Raw Data/NIPA.csv';
    delimiter = ',';
    startRow = 2;
    formatSpec = '%f%f%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    Y_t = dataArray{:, 1}*1000000000;
    Cdat = dataArray{:, 2}*1000000000;
    I_t = dataArray{:, 3}*1000000000;
    N_t = dataArray{:, 4}*1000;
    deltaK_t = cellfun(@str2num,dataArray{:, 5})*1000000000
    %Re-calculate C to be consistent with our model: note this counts
    %everything that isn't investment as consumption!
    C_t = Y_t-I_t;
    
%Import the data from BLS (hours and employment)
    [~, ~, raw] = xlsread('Raw Data/HoursEmployment.xlsx','Sheet1');
    raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
    R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); 
    raw(R) = {NaN};
    data = reshape([raw{:}],size(raw));
    H_t = data(:,1);
    E_t = data(:,2)*1000;
    E_t(end) = E_t(end-1).*1.02;
    
%Calculate total labor hours
    L_t = H_t.*E_t;

%Calculate fraction of free hours worked
    L_t = (H_t.*E_t)./(5200.*N_t);
    Y_t = Y_t./N_t;
    C_t = C_t./N_t;
    I_t = I_t./N_t;
    deltaK_t = deltaK_t./N_t;

%Now we have all the data we care about!  The whole time series.
    
%% Clear temporary variables
    clearvars raw;

%% Clear temporary variables
clearvars data raw R;

%Given K_0 and delta, I_t, we can construct the capital stock:
    f_temp = @(x) f_Kstock(x(1),x(2),I_t,Y_t,deltaK_t);
    [parms]=fsolve(f_temp,[10000*1000,0.04]);
    k0 = parms(1);
    delta = parms(2);
    [error,K_t] = f_temp([k0,delta]);

    figure(3)
    plot([1967:2023],K_t)
    title('Capital Stock (per capita)')
    xlabel('Year')
    ylabel('Dollars')
    print('../Figures/Figure_3.png','-dpng')

%Alpha
    alpha = 0.7;
    
%Next, grab the A's
    A_t = Y_t./((L_t.^alpha).*K_t(1:end-1).^(1-alpha))
    w_t = alpha.*Y_t./L_t;
    r_t = (1-alpha).*Y_t./K_t(1:end-1);

    figure(4)
    plot([1967:2022],A_t)
    title('TFP')
    xlabel('Year')
    ylabel('Value')
    print('../Figures/Figure_4.png','-dpng')

    
%Beta
    figure(5)
    plot([1967:2021],(1./(1-delta+r_t(2:end)).*(C_t(2:end)./C_t(1:end-1))));
    title('Beta/Euler Equation Values')
    xlabel('Year')
    ylabel('Beta')
    print('../Figures/Figure_5.png','-dpng')

     beta_avg = mean((1./(1-delta+r_t(2:end)).*(C_t(2:end)./C_t(1:end-1))));

%gamma
    figure(6)
    plot([1967:2022],((w_t.*(1-L_t)./C_t)));
    title('psi/intratemporal foc')
    xlabel('Year')
    ylabel('psi')
    print('../Figures/Figure_6.png','-dpng')

    psi_avg = mean((w_t.*(1-L_t)./C_t));

%gamma
    figure(60)
    plot([1967:2022],((w_t.*(1-L_t)./C_t)));
    hold on
    plot([1967:2022],psi_avg(ones(1,2022-1967+1)),'--r','LineWidth',3);
    text(1973,psi_avg+0.4,"Period of 'high taxes' (distortions)")
    text(1987,psi_avg-0.14,["Period of 'low ","taxes' (distortions)"])
    scatter(2020,((w_t(end-2).*(1-L_t(end-2))./C_t(end-2))),'red')
    title('psi/intratemporal foc')
    xlabel('Year')
    ylabel('psi')
    print('../Figures/Figure_6b.png','-dpng')



    save Data.mat Y_t w_t L_t K_t N_t C_t A_t I_t r_t


    