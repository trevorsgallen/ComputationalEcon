clear

sigma2 = 10;


U = @(x,psi) -(x-psi).^2;

choice_set = [0:5];

U(choice_set,1)