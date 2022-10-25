clear
close all

f = @(x,y) (1-x).^2 + 100.*(y-x.^2).^2;


[X,Y] = meshgrid(-3:.01:3);
FY = f(X,Y)

initpop = rand(10,2)*4-2


figure(1)
pcolor(X,Y,FY)
hold on
shading flat
scatter(1,1,'R','Filled')
scatter(initpop(:,1),initpop(:,2),'r')
title('Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2')
xlabel('X')
ylabel('Y')
print('DifferentialEvolution_1','-dpng')

error = 1;
z = 0;
trialvec_accept = 0;
while trialvec_accept < 5
    z = z+1;
    pop_sto(:,:,z) = initpop;
    % Create a competitor for each point
        for indpt = 1:10
            %First point to create direction vector
                ind_vec1 = round(0.5+10*rand(1,1));
                while ind_vec1 == indpt
                    ind_vec1 = round(0.5+10*rand(1,1));
                end
            %Second point to create direction vector
                ind_vec2 = round(0.5+10*rand(1,1));
                while ind_vec2 == indpt | ind_vec2 == ind_vec1
                    ind_vec2 = round(0.5+10*rand(1,1));
                end
            %Point from which to center the direction vector
                ind_vec3 = round(0.5+10*rand(1,1));
                while ind_vec3 == indpt | ind_vec3 == ind_vec1 | ind_vec3 == ind_vec2
                    ind_vec3 = round(0.5+10*rand(1,1));
                end

            %Create the direction vector
            rand_vec = [initpop(ind_vec1,:)-initpop(ind_vec2,:)];

            %Create the new vector
                trial_vec = initpop(ind_vec3,:)+rand_vec;

            %Compete the new vector with the current point, replace with best
                    newpop(indpt,:) = trial_vec.*(f(initpop(indpt,1),initpop(indpt,2)) >= f(trial_vec(:,1),trial_vec(:,2))) + ...
                                      initpop(indpt,:).*(f(initpop(indpt,1),initpop(indpt,2)) < f(trial_vec(:,1),trial_vec(:,2)));
        end
%         max(trial_vec==f(initpop(:,1),initpop(:,2)))-min(f(newpop(:,1),newpop(:,2)));
        if min(min(initpop==newpop)) == 1
            trialvec_accept = trialvec_accept+1;
        elseif min(min(initpop==newpop)) == 0
            trialvec_accept = 0;
        end
        
        
        figure(z)
        pcolor(X,Y,FY)
        hold on
        shading flat
        scatter(newpop(:,1),newpop(:,2),100*ones(10,1),'G','Filled')
        hold on
        scatter(initpop(:,1),initpop(:,2),'RX')
        scatter(1,1,'R','Filled')
        title('Rosenbrock Function: f(x,y)=(1-x)^2+b(y-x^2)^2')
        xlabel('X')
        ylabel('Y')
        eval(['print(''','DifferentialEvolution_',num2str(z+1),''' ,''-dpng'' )'])

    initpop = newpop;
end
        pop_sto(:,:,z+1) = initpop;

