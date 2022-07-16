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

% initpop = rand(20,2)*1-1;
initpop = [-1.5,-1.5; -1.5 , 1.5 ; 1.5 , -1.5 ; 1.5 , 1.5 ; 0 , 0 ; -1.9 , -1.9 ; 1.9 , 1.9 ; -1.9 , 1.9 ; 1.9 , -1.9 ]
initpop(10:20,:) = rand(11,2)*4-2; 
fitness = f(initpop(:,1),initpop(:,2))
scatter(initpop(:,1),initpop(:,2))
z = 0;
while min(fitness) > 1e-5
    z = z+1;
    fitness = f(initpop(:,1),initpop(:,2))
    temp = sortrows([fitness,initpop]);
    fitness = temp(:,1);
    initpop = temp(:,2:3);
    parents = initpop(1:5,:);
    
    %Crossover step
        %The elite two survive
            child(1:2,:) = parents(1:2,:);
        
        for child_ind = 3:20
            %Choose two random parents
            parent_1_ind = round(0.5+5*rand());
            parent_2_ind = round(0.5+5*rand());
            while parent_1_ind == parent_2_ind
                parent_2_ind = round(0.5+5*rand());
            end
            
            for vec_ind = 1:2
                temp = rand;
                child(child_ind,vec_ind) = (temp<0.5)*parents(parent_1_ind,vec_ind) + ...
                                          +(temp>=0.5)*parents(parent_2_ind,vec_ind);
            end
        end
        
    %Mutation Step for all but the most elite two
        child(3:end,:) = child(3:end,:)+0+randn(18,2).*(rand(18,2)-0.5)./(z.^0.3)
    
    %We now have our new pop
    pop_sto(:,:,z)= initpop;
    initpop = child;
end


colormat = ['y';'m';'c';'r';'g';'b';'w';'k';'y';'m';'c'];
framex = 0;
for frame = 1:size(pop_sto,3)
        framex = framex+1;
        close all
        pcolor(X,Y,FY)
        hold on
        shading flat
        title('Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2')
        xlabel('X')
        ylabel('Y')
        if frame >= 11
            scatter(pop_sto(:,1,frame-10),pop_sto(:,2,frame-10),colormat(mod(1+frame,11)+1))
        end
        if frame >= 10
        scatter(pop_sto(:,1,frame-9),pop_sto(:,2,frame-9),colormat(mod(2+frame,11)+1))
        end
        if frame >= 9
            scatter(pop_sto(:,1,frame-8),pop_sto(:,2,frame-8),colormat(mod(3+frame,11)+1))
        end
        if frame >= 8
            scatter(pop_sto(:,1,frame-7),pop_sto(:,2,frame-7),colormat(mod(4+frame,11)+1))
        end
        if frame >= 7
            scatter(pop_sto(:,1,frame-6),pop_sto(:,2,frame-6),colormat(mod(5+frame,11)+1))
        end
        if frame >= 6
            scatter(pop_sto(:,1,frame-5),pop_sto(:,2,frame-5),colormat(mod(6+frame,11)+1))
        end
        if frame >= 5
            scatter(pop_sto(:,1,frame-4),pop_sto(:,2,frame-4),colormat(mod(7+frame,11)+1))
        end
        if frame >= 4
            scatter(pop_sto(:,1,frame-3),pop_sto(:,2,frame-3),colormat(mod(8+frame,11)+1))
        end
        if frame >= 3
            scatter(pop_sto(:,1,frame-2),pop_sto(:,2,frame-2),colormat(mod(9+frame,11)+1))
        end
        if frame >= 2
            scatter(pop_sto(:,1,frame-1),pop_sto(:,2,frame-1),colormat(mod(10+frame,11)+1))
        end
        scatter(pop_sto(:,1,frame),pop_sto(:,2,frame),colormat(mod(11+frame,11)+1))
        scatter(1,1,'R','Filled')
        drawnow 
        
        eval(['print(''','GeneticAlgorithm',num2str(frame),''' ,''-dpng'' )'])

        F((frame-1)*10+1:frame*10) = getframe(gcf)
end


writerObj = VideoWriter('peaks.avi','MPEG-4');
open(writerObj);
writeVideo(writerObj,F);
close(writerObj);
