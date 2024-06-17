function goodness = goodnessOfCollapseAllParamsPhiFudge(stressTable, phi_list, volt_list, paramsVector)

[eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(paramsVector,length(phi_list));

f = @(sigma,jj) exp(-sigmastar(jj)./sigma);

x_all = zeros(size(stressTable,1),1);
F_all = zeros(size(stressTable,1),1);

for kk=1:size(stressTable,1)
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta = stressTable(kk,4);
    %ii = find(phi == phi_list);
    my_phi_fudge = phi_fudge(phi == phi_list);
    jj = find(voltage == volt_list);

    %x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj) / (phi0-phi);
    x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj);
    F = eta * (phi0-(phi+my_phi_fudge))^2;

    x_all(kk) = x;
    F_all(kk) = F;

end

Fhat = eta0*(1-x_all).^delta;
goodness = sum( ((Fhat-F_all)./F_all).^2 );
%goodness = sum( abs((Fhat-F_all)./F_all) );

end