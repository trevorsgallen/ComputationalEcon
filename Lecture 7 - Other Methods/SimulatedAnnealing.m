clear
close all

f = @(x,y) (1-x).^2 + 100.*(y-x.^2).^2;

[X,Y] = meshgrid(-2:.01:2);
FY = f(X,Y)

figure(1)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
title('Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2')
xlabel('X')
ylabel('Y')
print('Nelder_Mead_1','-dpng')

initpop = [-1.2,-1.2];

T0 = 0.0005;
z=0;
zfig = 1;
allpts_sto(1,:) = initpop;
while z < 10000
    change = 0;
    z = z+1;
    T = 1/log(z)
    newpt = initpop + sqrt(T)*rand(1,2)-sqrt(T)./2;
    allpts_sto(end+1,:) = newpt;
    init_fit = f(initpop(1),initpop(2));
    new_fit = f(newpt(1),newpt(2));
    
    praccept = 1/(1+exp((init_fit-new_fit)/T))

    temp = rand;
    
    if temp > praccept
        oldpt = initpop;
        initpop = newpt;
        change = 1;
    end
    pt_sto(z,:) = initpop;
end






while z < 100000
    
    change = 0;
    z = z+1
    T = 0.5/log(z)
    newpt = initpop + sqrt(T)*rand(1,2)-sqrt(T)./2;
    allpts_sto(end,:) = newpt;
    init_fit = f(initpop(1),initpop(2));
    new_fit = f(newpt(1),newpt(2));
    
    praccept = 1/(1+exp((init_fit-new_fit)/T))

    temp = rand;
    
    if temp > praccept
        oldpt = initpop;
        initpop = newpt;
        change = 1;
    end
    pt_sto(z,:) = initpop;

    
    close all
    figure(1)
    scatter(initpop(1),newpt(2),'K')
    pcolor(X,Y,FY)
    hold on
    shading flat
    scatter(1,1,'R','Filled')
    title('Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2')
    xlabel('X')
    ylabel('Y')
    plot(pt_sto(:,1),pt_sto(:,2))
    if change == 0
        scatter(pt_sto(end,1),pt_sto(end,2),'R','Filled')
        scatter(newpt(end,1),newpt(end,2),'Y')
    end
    if change == 1
        scatter(oldpt(end,1),oldpt(end,2),'R')
        scatter(newpt(end,1),newpt(end,2),'Y','Filled')
    end
    drawnow
    if z < 30
            eval(['print(''','SimulatedAnnealing_',num2str(zfig),''' ,''-dpng'' )'])
        zfig = zfig+1;
    end
    if z >= 30
        if mod(z,1000) == 2
            eval(['print(''','SimulatedAnnealing_',num2str(zfig),''' ,''-dpng'' )'])
            zfig = zfig+1;
        end
    end
end


