%This .m file solves the problem from Homework 3 with value function iteration.
tic
clear

%Parameters
    phi = 0.1;
    sigma = 0.01;
    rho = 0.95;
    beta = 0.95;


pbar_space = linspace(-0.15,0.15,9);
ptm1_space = linspace(-0.15,0.15,10);

[pbar_grid,ptm1_grid]=meshgrid(pbar_space,ptm1_space);

V_0 = -0.25*ones(size(pbar_grid));
V_1 = -0.25*ones(size(pbar_grid));

err = Inf;
while err > 0
    for pbar_ind = 1:length(pbar_space)
        for ptm1_ind = 1:length(ptm1_space)
            pbar = pbar_space(pbar_ind);
            ptm1 = ptm1_space(ptm1_ind);

            ut = @(pt) (-(pt-pbar).^2-phi*(pt-ptm1).^2)+beta*integral(@(e) pdf('Normal',e,0,sigma).*interp2(pbar_grid,ptm1_grid,V_0,max(min(rho*pbar+e,max(pbar_space)),min(pbar_space)),pt,'makima'),-3*sigma,3*sigma);
            [temp1,temp2]=fminbnd(@(pt)-ut(pt),min(pbar_space),max(pbar_space));

            V_1(ptm1_ind,pbar_ind)=-temp2;
            ptstar(ptm1_ind,pbar_ind)=temp1;
        end
    end
    err = max(abs(V_0-V_1),[],'all')
    V_0 = V_1;
end

save('VFI.mat','pbar_grid','ptm1_grid','V_0','ptstar')

surf(pbar_grid,ptm1_grid,V_0)

X = [ones(numel(pbar_grid),1),reshape(pbar_grid,[],1),reshape(ptm1_grid,[],1)];
Y = reshape(ptstar,[],1);
bhat = inv(X'*X)*X'*Y

fprintf("\n %s %9.3f %s %9.3f %s %9.3f %s \n %s %9.3f %s",'Policy function is pt=',bhat(1),'+',bhat(2),'*pbar+',bhat(3),'*ptm1.','Everything took ',toc,' seconds.')
toc
