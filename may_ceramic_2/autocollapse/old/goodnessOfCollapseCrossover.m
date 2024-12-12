function goodness = goodnessOfCollapseCrossover(stressTable, phi_list, volt_list, paramsVector, showPlot)

if nargin < 5
    showPlot = false;
end

[eta0, phi0, delta, A, width, sigmastar, C] = unzipParamsCrossover(paramsVector,length(phi_list));

f = @(sigma,jj) exp(-sigmastar(jj)./sigma);

x_all = zeros(size(stressTable,1),1);
F_all = zeros(size(stressTable,1),1);
H_all = zeros(size(stressTable,1),1);

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
    H = F*x^2;

    x_all(kk) = x;
    F_all(kk) = F;
    H_all(kk) = H;

end

xi = 1./x_all-1;
logintersection = log(A/eta0)/(-delta-2);
mediator = cosh(width*(log(xi)-logintersection));
Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
Hhat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));

if delta==-2
    Hhat = sqrt(A*eta0) * xi.^((delta-2)/2);
end

Fhat = 1./x_all.^2 .* Hhat;


goodness = sum( ((Fhat-F_all)./F_all).^2 );
%goodness = sum( ((Hhat-H_all)./H_all).^2 );

if showPlot
    figure; hold on;
    ax1=gca; ax1.XScale = 'log'; ax1.YScale = 'log';
    
    [xi,sortIdx] = sort(xi,'ascend');
    H_all = H_all(sortIdx);
    Hhat = Hhat(sortIdx);

    scatter(xi,H_all);
    plot(xi,Hhat,'k-','LineWidth',1);

end


end