%Import the data from NIPA (I, delta*K, Y, C)
    clear
    filename = 'Workbook2.csv';
    delimiter = ',';
    startRow = 2;
    formatSpec = '%f%f%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    I_t = dataArray{:, 1}*1000000000;
    deltaK_t = dataArray{:, 2}*1000000000;
    Y_t = dataArray{:, 3}*1000000000;
    Cdat = dataArray{:, 4}*1000000000;
    %Re-calculate C to be consistent with our model: note this counts
    %everything that isn't investment as consumption!
    C_t = Y_t-I_t;
    
%Import the data from BLS (hours and employment)
    [~, ~, raw] = xlsread('HoursEmployment.xlsx','Sheet1');
    raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
    R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); 
    raw(R) = {NaN};
    data = reshape([raw{:}],size(raw));
    H_t = data(:,1);
    E_t = data(:,2)*1000;
    E_t(end) = E_t(end-1).*1.02;
    
%% Import the data from BLS (population)
    N_t = xlsread('Population.xlsx','Sheet1');
    N_t = N_t*1000;
    
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
    plot([1967:2015],K_t)
    title('Capital Stock (per capita)')
    xlabel('Year')
    ylabel('Dollars')
    print('Figure_3.png','-dpng')

%Alpha
    alpha = 0.7;
    
%Next, grab the A's
    A_t = Y_t./((L_t.^alpha).*K_t(1:end-1).^(1-alpha))
    w_t = alpha.*Y_t./L_t;
    r_t = (1-alpha).*Y_t./K_t(1:end-1);

    figure(4)
    plot([1967:2014],A_t)
    title('TFP')
    xlabel('Year')
    ylabel('Value')
    print('Figure_4.png','-dpng')

    
%Beta
    figure(5)
    plot([1967:2013],(1./(1-delta+r_t(2:end)).*(C_t(2:end)./C_t(1:end-1))));
    title('Beta/Euler Equation Values')
    xlabel('Year')
    ylabel('Beta')
    print('Figure_5.png','-dpng')

     beta_avg = mean((1./(1-delta+r_t(2:end)).*(C_t(2:end)./C_t(1:end-1))));

%gamma
    figure(6)
    plot([1967:2014],((w_t.*(1-L_t)./C_t)));
    title('psi/intratemporal foc')
    xlabel('Year')
    ylabel('psi')
    print('Figure_6.png','-dpng')

    psi_avg = mean((w_t.*(1-L_t)./C_t));

    save Data.mat Y_t w_t L_t K_t N_t C_t A_t I_t r_t


    