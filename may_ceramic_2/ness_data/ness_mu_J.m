dataTable = chris_table_04_25;

%dataTable = dataTable(dataTable(:,6)>0.5,:);
%dataTable = dataTable(dataTable(:,6)<0.05,:);

phi = dataTable(:,1);
sigma = dataTable(:,2);
P = dataTable(:,6);
rate = sigma./dataTable(:,4);

mu = sigma./P;
J = rate./P;

defineColorMaps;

figure; hold on; makeAxesLogLog;
xlabel('J'); ylabel('\mu')
for kk=1:length(mu)
    myColor = colorP(P(kk));
    %myColor = colorPhi(dataTable(kk,1));
    plot(J(kk),mu(kk),'o','Color',myColor)
end
prettyplot

muJ = @(mu_c,A,alpha,J) mu_c+A*J.^alpha; 
muJfittype = fittype(muJ,"Independent","J");

cutoff_upper = 0.5;
cutoff_lower = 0.05;
muJfit_lower = fit(J(P<cutoff_lower),mu(P<cutoff_lower),muJfittype,'StartPoint',[0.1 1 1]);
muJfit_upper = fit(J(P>cutoff_upper),mu(P>cutoff_upper),muJfittype,'StartPoint',[0.1 1 1]);

Jplot = sort(J);
plot(Jplot,muJ(muJfit_lower.mu_c,muJfit_lower.A,muJfit_lower.alpha,Jplot),'-','Color','#189100');
plot(Jplot,muJ(muJfit_upper.mu_c,muJfit_upper.A,muJfit_upper.alpha,Jplot),'-','Color','#ff7912');

figure; hold on; makeAxesLogLog;
xlabel('J'); ylabel('\phi')
for kk=1:length(mu)
    myColor = colorP(P(kk));
    %myColor = colorPhi(dataTable(kk,1));
    plot(J(kk),phi(kk),'o','Color',myColor)
end
prettyplot

phiJ = @(phi_J,B,alpha,J) phi_J./(1+B*J.^alpha); 
phiJfittype = fittype(phiJ,"Independent","J");

phiJfit_lower = fit(J(P<cutoff_lower),phi(P<cutoff_lower),phiJfittype,'StartPoint',[0.1 1 1]);
phiJfit_upper = fit(J(P>cutoff_upper),phi(P>cutoff_upper),phiJfittype,'StartPoint',[0.1 1 1]);

plot(Jplot,phiJ(phiJfit_lower.phi_J,phiJfit_lower.B,phiJfit_lower.alpha,Jplot),'-','Color','#189100');
plot(Jplot,phiJ(phiJfit_upper.phi_J,phiJfit_upper.B,phiJfit_upper.alpha,Jplot),'-','Color','#ff7912');
