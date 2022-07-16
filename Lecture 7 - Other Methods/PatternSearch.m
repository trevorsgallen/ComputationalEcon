clear
close all

f = @(x,y) x.^2 + y.^2 + (y-1).*x;
stepsize = 1;

switch_randvec = 1;
switch_noneuc = 0;

if switch_randvec == 1
    switch_noneuc = 0
end

[X,Y] = meshgrid(-2:.01:2);
FY = f(X,Y)

figure(1)
pcolor(X,Y,FY)
hold on
shading flat
    scatter(2/3,-1/3,'R','Filled')
title('Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2')
xlabel('X')
ylabel('Y')
print('PatternSearch_1','-dpng')

step = 1;
if switch_noneuc == 0
    d1 = [step,0]
    d2 = [0,step]
end
if switch_noneuc == 1
        dir = degtorad(45);
        d1 = [cos(dir).*step,sin(dir).*step]
        d2 = [sin(dir).*step,-cos(dir).*step]
end
if switch_randvec == 1
        dir = degtorad(360*rand);
        d1 = [cos(dir).*step,sin(dir).*step]
        d2 = [sin(dir).*step,-cos(dir).*step]
end
x = [-1,0];

% figure(2)
% pcolor(X,Y,FY)
% hold on
% shading flat
%     scatter(2/3,-1/3,'R','Filled')
% scatter(x(:,1),x(:,2),'G','Filled')
% title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Initial Point'})
% xlabel('X')
% ylabel('Y')
% print('PatternSearch_3','-dpng')


xsamp = [x ; x+d1 ; x+d2 ; x-d1 ; x-d2]

z = 2
while z < 15
    z = z+1;
    h = figure(z)
    pcolor(X,Y,FY)
    hold on
    shading flat
    scatter(2/3,-1/3,'R','Filled')
    scatter(xsamp(:,1),xsamp(:,2),'G','Filled')
    title({'Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2','Sampling Points'})
    xlabel('X')
    ylabel('Y')
    F(z-2) = getframe(gcf)
    if switch_randvec == 0 & switch_noneuc == 0
        eval(['print(''','PatternSearch_',num2str(z),''' ,''-dpng'' )'])
    end
    if switch_randvec == 0 & switch_noneuc == 1
        eval(['print(''','PatternSearch_Ne_',num2str(z),''' ,''-dpng'' )'])
    end
    if switch_randvec == 1 
        eval(['print(''','PatternSearch_Rand_',num2str(z),''' ,''-dpng'' )'])
    end

    ind_best = find(f(xsamp(:,1),xsamp(:,2))==min(f(xsamp(:,1),xsamp(:,2))));
    
    if ind_best(1) == 1 
        step = step./2;
        if switch_randvec == 0
            d1 = [step,0];
            d2 = [0,step];
        end
        if switch_noneuc == 1
                dir = degtorad(45);
                d1 = [cos(dir).*step,sin(dir).*step]
                d2 = [sin(dir).*step,-cos(dir).*step]
        end
    end
    if switch_randvec == 1
        dir = 360*rand;
        d1 = [cos(dir).*step,sin(dir).*step]
        d2 = [sin(dir).*step,-cos(dir).*step]
    end

    x = xsamp(ind_best(1),:)
    
    xsamp = [x ; x+d1 ; x+d2 ; x-d1 ; x-d2]
end
fig = figure;
movie(fig,F,2)

writerObj = VideoWriter('peaks.avi','MPEG-4');
writerObj.FrameRate = 100;
open(writerObj);
writeVideo(writerObj,F);
close(writerObj);

