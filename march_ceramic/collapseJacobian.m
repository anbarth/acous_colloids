function J = collapseJacobian(paramsVector,stressTable)

% output should be a matrix with (# data points) rows and (# parameters) columns
J = zeros(size(stressTable,1),length(paramsVector));

phi_list = sort(unique(stressTable(:,1)));
volt_list = sort(unique(stressTable(:,3)));
numPhi = length(phi_list);
numV = length(volt_list);

[eta0, phi0, delta, sigmastar, C] = unzipParams(paramsVector,numPhi);
f = @(sigma,jj) exp(-sigmastar(jj)./sigma);

% go through the data points -- construct J row by row
for kk=1:size(stressTable,1)
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    ii = find(phi == phi_list);
    jj = find(voltage == volt_list);

    x = C(phi == phi_list,voltage == volt_list)*f(sigma,jj) / (phi0-phi);
    eta_hat = eta0*(phi0-phi)^-2*(1-x)^delta;

    % each row goes [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
    % eta0
    J(kk,1) = eta_hat/eta0;

    % phi0
    J(kk,2) = eta_hat/(phi0-phi)*(-2+delta*x/(1-x));

    % delta
    J(kk,3) = eta_hat*log(1-x);

    % sigmastar(V)
    J(kk,3+jj) = eta_hat*delta/(1-x)*x/sigma;

    % C(phi, V)
    J(kk,3+numV+(jj-1)*numPhi+ii) = eta_hat*delta/(1-x)*(-1*x/C(ii,jj));



end
end