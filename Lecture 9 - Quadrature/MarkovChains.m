clear
format short g
Pi = [0   0.9   0   0   0   0   0   0   0.1 ;
0   0   0.7   0   0   0   0   0   0.3 ;
0   0   0   0.9   0   0   0   0   0.1 ;
0   0   0   0   0.99   0   0   0   0.01 ;
0   0   0   0   0   0.7   0   0   0.3 ;
0   0   0   0   0   0   0.6   0   0.4 ;
0   0   0   0   0   0   0   0.5   0.5 ;
0   0   0   0   0   0   0   0.4   0.6;
0   0   0   0   0   0   0   0   1]

V = [1 , 0   0   0   0   0   0   0   0];

V_sto(1,:)=V
V_sto(2,:)=V*Pi
V_sto(3,:)=V*Pi^2
V_sto(4,:)=V*Pi^3
V_sto(5,:)=V*Pi^4
V_sto(6,:)=V*Pi^5
V_sto(7,:)=V*Pi^6
V_sto(8,:)=V*Pi^7
V_sto(9,:)=V*Pi^8
V_sto(10,:)=V*Pi^9
V_sto(11,:)=V*Pi^10

figure(1)
plot(V_sto(:,end))
title('Cumulative Probability of Death')
xlabel('Year')
ylabel('Probability Dead')
print('CumulativeProbDeath','-dpng')


clear
format short g
Pi = [0.99   0.01  ;
    0.01 0.99]

V(1) = 1;

for t = 1:1199
    temp = rand;
    if V(t) == 1
        Pr = Pi(1,:);
    else
        Pr = Pi(2,:);
    end
    
    if temp <= Pr(1)
        V(t+1) = 1;
    else
        V(t+1) = 2;
    end
end

plot(V)
title('Regime Shifts')
xlabel('Period')
ylabel('State')
ylim([0.9,2.1])
print('RegimeShifts','-dpng')


clear
format short g
Pi = [0.99   0.01  ;
    0.3 0.7]

V(1) = 1;

for t = 1:1199
    temp = rand;
    if V(t) == 1
        Pr = Pi(1,:);
    else
        Pr = Pi(2,:);
    end
    
    if temp <= Pr(1)
        V(t+1) = 1;
    else
        V(t+1) = 2;
    end
end

plot(V)
title('Sudden, Brief Shocks')
xlabel('Period')
ylabel('State')
ylim([0.9,2.1])
print('SuddenShocks','-dpng')

clear
format short g
Pi = [0.85   0.15   0.00   0.00   0.00   0.00   0.00   0.00   0.00 ;
0.15   0.70   0.15   0.00   0.00   0.00   0.00   0.00   0.00 ;
0.00   0.15   0.70   0.15   0.00   0.00   0.00   0.00   0.00 ;
0.00   0.00   0.15   0.70   0.15   0.00   0.00   0.00   0.00 ;
0.00   0.00   0.00   0.15   0.70   0.15   0.00   0.00   0.00 ;
0.00   0.00   0.00   0.00   0.15   0.70   0.15   0.00   0.00 ;
0.00   0.00   0.00   0.00   0.00   0.15   0.70   0.15   0.00 ;
0.00   0.00   0.00   0.00   0.00   0.00   0.15   0.70   0.15;
0.00   0.00   0.00   0.00   0.00   0.00   0.00   0.15   0.85]

V = [1 , 0   0   0   0   0   0   0   0];

for ind = 0:100
V_sto(ind+1)=sum([1:9].*(V*Pi^ind))
end

figure(1)
plot(V_sto)
