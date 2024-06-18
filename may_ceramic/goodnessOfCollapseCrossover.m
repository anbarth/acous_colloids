function goodness = goodnessOfCollapseCrossover(stressTable, phi_list, volt_list, paramsVector)

[eta0, phi0, delta, A, width, sigmastar, C] = unzipParamsCrossover(paramsVector,length(phi_list));

f = @(sigma,jj) exp(-sigmastar(jj)./sigma);

x_all = zeros(size(stressTable,1),1);
F_all = zeros(size(stressTable,1),1);

for kk=1:size(stressTable,1)
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta = stressTable(kk,4);
    %ii = find(phi == phi_list);
    jj = find(voltage == volt_list);

    %x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj) / (phi0-phi);
    x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj);
    F = eta * (phi0-phi)^2;

    x_all(kk) = x;
    F_all(kk) = F;

end

xi = log(1./x_all-1);
intersection = (log(eta0)-log(A))/(2+delta);
crossover_mediator = 1/2*(1+tanh(width*(xi-intersection)));
Fhat = 1./x_all.^2 .* exp(-delta*xi+log(A) + crossover_mediator.*((2+delta)*xi+log(eta0)-log(A)) );

%Fhat = eta0*(1-x_all).^delta;
goodness = sum( ((Fhat-F_all)./F_all).^2 );
%goodness = sum( abs((Fhat-F_all)./F_all) );

end