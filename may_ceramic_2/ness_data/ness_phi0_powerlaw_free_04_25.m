dataTable = chris_table_04_25;

phi0=0.641;

figure; hold on; makeAxesLogLog;
xlabel('\phi_0-\phi')
ylabel('\eta')

phi = [];
eta = [];
sigma = [];
P = [];

for kk=1:size(dataTable,1)
    stress = dataTable(kk,2);
    if stress < 1e-3
        myPhi = dataTable(kk,1);
        myEta = dataTable(kk,4);
        plot(phi0-myPhi,myEta,'ok')

        phi(end+1) = myPhi;
        eta(end+1) = myEta;
        sigma(end+1) = dataTable(kk,2);
        P(end+1) = dataTable(kk,6);
    end
end

dphiFit = phi0-phi(phi<phi0);
etaFit = eta(phi<phi0);
p = polyfit(log(dphiFit),log(etaFit),1);
phi0phiF = logspace(-3,-1);
disp(p(1))
plot(phi0phiF,exp(polyval(p,log(phi0phiF))),'r-');

prettyplot

