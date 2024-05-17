function sse = collapseSSE(paramsVector,stressTable)

phi_list = sort(unique(stressTable(:,1)));
volt_list = sort(unique(stressTable(:,3)));
numPhi = length(phi_list);
%numV = length(volt_list);

[eta0, phi0, delta, sigmastar, C] = unzipParams(paramsVector,numPhi);
f = @(sigma,jj) exp(-sigmastar(jj)./sigma);

sse = 0;
for kk=1:size(stressTable,1)
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta = stressTable(kk,4);
    %ii = find(phi == phi_list);
    jj = find(voltage == volt_list);

    x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj) / (phi0-phi);
    eta_hat = eta0*(phi0-phi)^-2*(1-x)^delta;

    sse = sse + (eta_hat-eta)^2;
end

end