function phiJ = phiJHandpicked0V(sigma, dataTable, y)


phi0 = y(2);
sigmastar = y(6);
D = y(7:end);

% determine alpha directly from D
phi_list = unique(dataTable(:,1));
dphi = phi0-phi_list;
l2 = 10:13;
linearfit = fittype('poly1');
myft2 = fit(log(dphi(l2)),log(D(l2))',linearfit);
alpha = -1*myft2.p1;

% calculate phiJ
% note that i assume C(phiJ)=1, which i think is approximately true
f = @(sigma) sigma./(sigmastar^2+sigma.^2).^(1/2);
phiJ = phi0 - f(sigma)^(1/alpha);

end