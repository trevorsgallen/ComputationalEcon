clear
%Population 16+ (initially thousands) (monthly)
    opts = spreadsheetImportOptions("NumVariables", 1);
    opts.Sheet = "BLS Data Series";
    opts.DataRange = "D13:D658";
    opts.VariableNames = "Value";
    opts.VariableTypes = "double";
    data_pop_16p = 1000*table2array(readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/LNU00000000_Pop16plus.xlsx", opts, "UseExcel", false))
    pop_16p_date = [1967:1/12:1967+(1/12)*(length(data_pop_16p)-1)]'
    
%Population 16+ (initially thousands) (monthly)
    opts = spreadsheetImportOptions("NumVariables", 1);
    opts.Sheet = "BLS Data Series";
    opts.DataRange = "D13:D658";
    opts.VariableNames = "Value";
    opts.VariableTypes = "double";
    data_pop_65p = 1000*table2array(readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/LNU00000097_Pop65plus.xlsx", opts, "UseExcel", false))
    data_pop_65p_date = [1967:1/12:1967+(1/12)*(length(data_pop_65p)-1)]'
    
%Employment (initially thousands) (monthly)
    opts = spreadsheetImportOptions("NumVariables", 1);
    opts.Sheet = "BLS Data Series";
    opts.DataRange = "D14:D546";
    opts.VariableNames = "Value";
    opts.VariableTypes = "double";
	data_emp = 1000*table2array(readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/LNU02005053_Emp.xlsx", opts, "UseExcel", false));
    data_emp_date = [1976+5/12:1/12:1976+5/12+(1/12)*(length(data_emp)-1)]'

%Hours (per week per worker) (monthly)
    opts = spreadsheetImportOptions("NumVariables", 1);
    opts.Sheet = "BLS Data Series";
    opts.DataRange = "D14:D546";
    opts.VariableNames = "Value";
    opts.VariableTypes = "double";
	data_hoursper = table2array(readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/LNU02005054_Hoursperworker.xlsx", opts, "UseExcel", false));
    data_hoursper_date = [1976+5/12:1/12:1976+5/12+(1/12)*(length(data_hoursper)-1)]'

    
%Nominal GDP (billions) (quarterly)
    opts = spreadsheetImportOptions("NumVariables", 215);
    opts.Sheet = "Sheet0";
    opts.DataRange = "C8:HI8";
    opts.VariableNames = ["VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104", "VarName105", "VarName106", "VarName107", "VarName108", "VarName109", "VarName110", "VarName111", "VarName112", "VarName113", "VarName114", "VarName115", "VarName116", "VarName117", "VarName118", "VarName119", "VarName120", "VarName121", "VarName122", "VarName123", "VarName124", "VarName125", "VarName126", "VarName127", "VarName128", "VarName129", "VarName130", "VarName131", "VarName132", "VarName133", "VarName134", "VarName135", "VarName136", "VarName137", "VarName138", "VarName139", "VarName140", "VarName141", "VarName142", "VarName143", "VarName144", "VarName145", "VarName146", "VarName147", "VarName148", "VarName149", "VarName150", "VarName151", "VarName152", "VarName153", "VarName154", "VarName155", "VarName156", "VarName157", "VarName158", "VarName159", "VarName160", "VarName161", "VarName162", "VarName163", "VarName164", "VarName165", "VarName166", "VarName167", "VarName168", "VarName169", "VarName170", "VarName171", "VarName172", "VarName173", "VarName174", "VarName175", "VarName176", "VarName177", "VarName178", "VarName179", "VarName180", "VarName181", "VarName182", "VarName183", "VarName184", "VarName185", "VarName186", "VarName187", "VarName188", "VarName189", "VarName190", "VarName191", "VarName192", "VarName193", "VarName194", "VarName195", "VarName196", "VarName197", "VarName198", "VarName199", "VarName200", "VarName201", "VarName202", "VarName203", "VarName204", "VarName205", "VarName206", "VarName207", "VarName208", "VarName209", "VarName210", "VarName211", "VarName212", "VarName213", "VarName214", "VarName215", "VarName216", "VarName217"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
    data_PY = 1000000000*reshape(table2array(readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/NIPA_1_1_5_NomGDP.xls", opts, "UseExcel", false)),[],1);
    data_PY_date = [1967:1/4:1967+(1/4)*(length(data_PY)-1)]'

%Nominal Consumption of Fixed Capital (billions) (quarterly)
    opts = spreadsheetImportOptions("NumVariables", 215);
    opts.Sheet = "Sheet0";
    opts.DataRange = "C8:HI14";
    cfcdat = readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/NIPA_7_5_CFC.xls", opts, "UseExcel", false);
    data_PdeltaK = reshape(1000000000*str2double(table2array(cfcdat(1,:))),[],1)
    data_deltaK_date =  [1967:1/4:1967+(1/4)*(length(data_PdeltaK)-1)]'

% Gross Fixed Capital Formation (nominal dollars) (quarterly) 
    opts = spreadsheetImportOptions("NumVariables", 1);
    opts.Sheet = "FRED Graph";
    opts.DataRange = "B12:B254";
    opts.VariableNames = "GrossFixedCapitalFormationinUnitedStatesUnitedStatesDollarsQuar";
    opts.VariableTypes = "double";
    data_GFCF_nom = table2array(readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/OECD_GFCF_FRED_USAGFCFQDSMEI.xls", opts, "UseExcel", false));
    clear opts
    data_GFCF_nom_date = [1960:0.25:2020.5]';
    
%Real GDP, Consumption, Investment (billions) (quarterly)
%% Setup the Import Options and import the data
    opts = spreadsheetImportOptions("NumVariables", 215);
    opts.Sheet = "Sheet0";
    opts.DataRange = "C8:HI14";
    realnipa = readtable("/Users/tg/Dropbox/Econ_641/Fall_2020/Lecture 11 - NCG/Extension/NIPA_1_1_6_RealGDP.xls", opts, "UseExcel", false);
    data_Y = reshape(1000000000*str2double(table2array(realnipa(1,:))),[],1)
    data_C = reshape(1000000000*str2double(table2array(realnipa(2,:))),[],1)
    data_I = reshape(1000000000*str2double(table2array(realnipa(7,:))),[],1)
    Y_date = [1967:1/4:1967+(1/4)*(length(data_Y)-1)]'
    C_date = [1967:1/4:1967+(1/4)*(length(data_C)-1)]'
    I_date = [1967:1/4:1967+(1/4)*(length(data_I)-1)]'

%Get real deltaK and real GFCF
    data_deltaK = (data_PdeltaK./data_PY).*data_Y
    
    data_I_GFCF = data_GFCF_nom(data_GFCF_nom_date >= min(data_PY_date) & data_GFCF_nom_date <= max(data_PY_date)).*(data_Y./data_PY)

%Working-age population (turn quarterly)
    data_workpop = data_pop_16p-data_pop_65p;
    data_workpop_date = data_pop_65p_date;
    data_workpop = prctile(reshape([data_workpop;NaN;NaN],3,[]),50)'
%     d = min(data_workpop)./mean(data_workpop),3,1);
%      
%     asdf
%     data_workpop = mean(reshape([data_workpop;NaN;NaN],3,[]))'
    data_workpop_date = min(reshape([data_workpop_date;NaN;NaN],3,[]))
    
    
%Turn hours and employment quarterly
    data_hoursper = mean(reshape([NaN;NaN;data_hoursper;NaN;NaN],3,[]),'omitnan')'
    data_hoursper_date = reshape(min(reshape([data_hoursper_date(1)-2/12;data_hoursper_date(1)-1/12;data_hoursper_date;NaN;NaN],3,[])),[],1);
    data_hoursper(2:end-1) = (data_hoursper(3:end)+data_hoursper(2:end-1)+data_hoursper(1:end-2))/3
    
    data_emp = mean(reshape([NaN;NaN;data_emp;NaN;NaN],3,[]),'omitnan')'
    data_emp(2:end-1) = (data_emp(3:end)+data_emp(2:end-1)+data_emp(1:end-2))/3
    data_emp_date = reshape(min(reshape([data_emp_date(1)-2/12;data_emp_date(1)-1/12;data_emp_date;NaN;NaN],3,[])),[],1);

%Calculate total labor hours as fraction of free time

    data_L = 52*data_hoursper(find(data_hoursper_date>=1976.25 & data_hoursper_date<=2020.5)).*data_emp(find(data_emp_date>=1976.25 & data_emp_date<=2020.5))./(5200.*data_workpop(find(data_workpop_date>=1976.25 & data_workpop_date<=2020.5)));


    clear opts cfcdat realnipa

%Fit capital stock
%     temp1 = [27048427569629.9 , 0.020246481]
%     f_Kstock(temp1(1),temp1(2),data_I_GFCF,data_Y,data_deltaK)
% %     temp1 = [
%     [temp1,temp2]=lsqnonlin(@(x) f_Kstock(x(1),x(2),data_I_GFCF,data_Y,data_deltaK),[data_Y(1)*2.5,0.05]);
%     [temp1,temp2]=fminunc(@(x) sum(f_Kstock(x(1),x(2),data_I_GFCF,data_Y,data_deltaK).^2),temp1);
%     [temp1,temp2]=patternsearch(@(x) sum(f_Kstock(x(1),x(2),data_I_GFCF,data_Y,data_deltaK).^2),temp1);
%     [temp1,temp2]=fminunc(@(x) sum(f_Kstock(x(1),x(2),data_I_GFCF,data_Y,data_deltaK).^2),temp1);
%     gaoptions = gaoptimset('InitialPopulation',temp1,'PopulationSize',100000,'PopInitRange',[0.5*data_Y(1),0 ; 5*data_Y(1) 0.2],'PlotFcns',@gaplotbestf)
%     gaoptions = gaoptimset('InitialPopulation',temp1,'PopulationSize',10000,'PlotFcns',@gaplotbestf)
%     [temp1,temp2]=ga(@(x) log(sum(f_Kstock(x(1),x(2),data_I_GFCF,data_Y,data_deltaK).^2)),2,[],[],[],[],[0.5*data_Y(1),0],[data_Y(1)*20,0.2],[],gaoptions);
% 
% %Create data capital stock
%     [error,data_K]=f_Kstock(temp1(1),temp1(2),data_I,data_Y,data_deltaK);
    data_K_date = [Y_date;Y_date(end)+0.25];
%     delta = temp1(2);
    
    %Now set my own values b/c being a little funny
    [error,data_K]=f_Kstock(data_Y(1)*2,0.08,data_I,data_Y,data_deltaK);
    delta = 0.08;

%Truncate
    data_workpop = data_workpop(data_workpop_date>=1976.25 & data_workpop_date<=2020.5);
    
%Now that we have capital stock, truncate GDP data to be same as hours
    data_Y = data_Y(Y_date>=1976.25)
    data_C = data_C(C_date>=1976.25)
    data_I = data_I(I_date>=1976.25)

%Now Rewrite data as per-capita
    data_Y = data_Y./data_workpop;
    data_C = data_C./data_workpop;
    data_I = data_I./data_workpop;
    data_deltaK = data_deltaK(data_deltaK_date>=1976.25 & data_deltaK_date<= 2020.5)./data_workpop;
    data_K = data_K(data_K_date>=1976.25 & data_K_date<=2020.5)./data_workpop;
    date = data_K_date(data_K_date>=1976.25 & data_K_date<=2020.5)
    clearvars -except data_Y data_C data_I data_deltaK data_K data_L date delta
    
    figure(3)
    plot(date,data_K)
    title('Capital Stock (per capita)')
    xlabel('Year')
    ylabel('Dollars')
    print('Figure_3.png','-dpng')

%Alpha
    alpha = 0.7;
    
%Next, grab the A's
    A_t = data_Y./((data_L.^alpha).*data_K(1:end).^(1-alpha))
    
    w_t = alpha.*data_Y./data_L;
    r_t = (1-alpha).*data_Y./data_K(1:end);

    figure(4)
    plot(date,A_t)
    title('TFP')
    xlabel('Year')
    ylabel('Value')
    print('Figure_4.png','-dpng')

    
%Beta
    figure(5)
    plot(date(1:end-1),(1./(1-delta+r_t(2:end)).*(data_C(2:end)./data_C(1:end-1))));
    title('Beta/Euler Equation Values')
    xlabel('Year')
    ylabel('Beta')
    print('Figure_5.png','-dpng')
     beta_t = (1./(1-delta+r_t(2:end)).*(data_C(2:end)./data_C(1:end-1)))';
     beta_avg = (mean((1./(1-delta+r_t(2:end)).*(data_C(2:end)./data_C(1:end-1)))))';

%gamma
    figure(6)
    plot(date,((w_t.*(1-data_L)./data_C)));
    title('psi/intratemporal foc')
    xlabel('Year')
    ylabel('psi')
    print('Figure_6.png','-dpng')
sfg
    psi_avg = mean((w_t.*(1-data_L)./data_C));
    psi_t = ((w_t.*(1-data_L)./data_C));
    
%Now solve

    %Initial guesses
        k0 = data_K(1);
        %Solve for all 178 periods
            T = 178;
            Lguess = 0.25.*ones(T,1);
            Kguess =   k0.*exp(0.0218.*[0:T]')
        
            Lguess = data_L(1:T);
            Kguess = [data_K(1:T);data_K(T)];
            
    focs_temp = @(x) focs_NCGTrend(x(1:T),[k0;x(T+1:end)],A_t,alpha,delta,mean(reshape(beta_t,[],1)),mean(reshape(psi_t,[],1)));

%Start out my initial guess of L's and k's using the actual L's and k's!

    x0 = [Lguess;[Kguess(2:end)]];
    lb = [Lguess*0.1;0.1*[Kguess(2:end)]]
    ub = [Lguess*0.4;10*[Kguess(2:end)]]

    focs_temp(x0)
    fopts = optimset('Display','iter','MaxFunEval',1e10,'MaxIter',1e10,'TolX',1e-10,'TolFun',1e-8)
    %Solve the system
        x0 = fsolve(focs_temp,x0,fopts)
        x0 = real(x0)
        
%         x0 = lsqnonlin(focs_temp,x0,lb,ub,fopts)
%         x0 = real(x0)
%         x0 = fmincon(@(x)sum(focs_temp(x).^2),x0,[],[],[],[],zeros(length(x0),1),[],[],fopts)
%         x0 = real(x0)

        
%         x0 = fsolve(focs_temp,x0,fopts)
%         x0 = real(x0)
%         x0 = lsqnonlin(focs_temp,x0,lb,ub,fopts)
%         x0 = real(x0)

%         asdf
%         asdf
    date_forecast = [1976.25:0.25:2040.75]
%     date_forecast = [1976.25:0.25:2020.75]
    [focerr,sol]=focs_temp(x0)
        L = sol(:,2)
        K = sol(:,1)

        figure(10)
        plot(date_forecast,L,'-k')
        hold on
        plot(date,data_L,'--r')
        
        figure(11)
        plot(date_forecast,K,'-k')
        hold on
        plot(date,data_K,'--r')
        
