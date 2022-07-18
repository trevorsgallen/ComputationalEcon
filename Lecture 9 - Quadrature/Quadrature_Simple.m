clear
close all
for nn = 3:20
    clear -nn -sto
    
    %Function to interpolate
        f = @(x) x.^2+2.*x-x.^3+cos(5*x);
        n = nn;

    %Find the points, interpolation weights, integration weights
        [x_k,a_k,w_k] = chebfull(f,n)

    %Define approximating function (interpolation weights & values)
        f_approx = @(x) (a_k(1) + sum(repmat(a_k(2:end),1,length(x)).*cos((repmat([1:n-1]',1,length(x)).*repmat(acos(x),n-1,1)))));

        figure(1)
        x_enh = [-1:0.001:1];
        plot(x_enh,f_approx(x_enh),'--r')
        hold on
        plot(x_enh,f(x_enh),'-k')
        scatter(x_k',f_approx(x_k'))

        format long g

    %Fejer's rule/Clenshaw-Curtis type
        %Now take the function value and integrate
            temp1 = sum(f(x_k).*w_k);

    %Matlab's built-in integrator (adaptive quadrature...keep adding points)
            temp3 = integral(f,-1,1);

        sto(nn-2,:) = [nn,temp1,temp3];
end

figure(2)
plot(sto(:,1),sto(:,2),'-k')
hold on
plot(sto(:,1),sto(:,3),'--b')
legend('Fejer','Adaptive (no n limit!)')

figure(3)
plot(sto(:,1),log10(sto(:,2)./sto(:,3)-1),'-k')
legend('Fejer')
xlabel('Number of points')
ylabel('Log (base 10) of percent error')


