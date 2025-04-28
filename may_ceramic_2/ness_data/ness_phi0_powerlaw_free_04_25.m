dataTable = chris_table_04_25;

phi0=0.645;

figure; hold on; makeAxesLogLog;
xlabel('\phi_0-\phi')
ylabel('\eta')

phi = [];
eta = [];

for kk=1:size(dataTable,1)
    stress = dataTable(kk,2);
    if stress < 1e-3
        myPhi = dataTable(kk,1);
        myEta = dataTable(kk,4);
        plot(phi0-myPhi,myEta,'ok')

        phi(end+1) = myPhi;
        eta(end+1) = myEta;
    end
end

p = polyfit(log(phi0-phi),log(eta),1);
phi0phiF = logspace(-3,-1);
disp(p(1))
plot(phi0phiF,exp(polyval(p,log(phi0phiF))),'r-');

prettyplot