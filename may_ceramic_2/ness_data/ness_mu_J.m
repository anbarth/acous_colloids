dataTable = chris_table_04_25;

%dataTable = dataTable(dataTable(:,6)>0.5,:);
%dataTable = dataTable(dataTable(:,6)<0.05,:);

phi = dataTable(:,1);
sigma = dataTable(:,2);
eta = dataTable(:,4);
P = dataTable(:,6);
rate = sigma./dataTable(:,4);

mu = sigma./P;
J = rate./P;

defineColorMaps;

%% mu(J)
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

%% phi(J)
figure; hold on; makeAxesLogLog;
xlabel('J'); ylabel('\phi')
for kk=1:length(mu)
    myColor = colorP(P(kk));
    %myColor = colorPhi(dataTable(kk,1));
    plot(J(kk),phi(kk),'o','Color',myColor)
end
prettyplot

phiJ = @(phi_J,B,beta,J) phi_J./(1+B*J.^beta); 
phiJfittype = fittype(phiJ,"Independent","J");

phiJfit_lower = fit(J(P<cutoff_lower),phi(P<cutoff_lower),phiJfittype,'StartPoint',[0.1 1 1]);
phiJfit_upper = fit(J(P>cutoff_upper),phi(P>cutoff_upper),phiJfittype,'StartPoint',[0.1 1 1]);

plot(Jplot,phiJ(phiJfit_lower.phi_J,phiJfit_lower.B,phiJfit_lower.beta,Jplot),'-','Color','#189100');
plot(Jplot,phiJ(phiJfit_upper.phi_J,phiJfit_upper.B,phiJfit_upper.beta,Jplot),'-','Color','#ff7912');

%% eta vs phiJ-phi
Jphi = @(phi_J,B,beta,phi) (1/B*(phi_J./phi-1)).^(1/beta);
etaPhi = @(mu_c,A,alpha,phi_J,B,beta,phi)  muJ(mu_c,A,alpha,Jphi(phi_J,B,beta,phi)) ./ Jphi(phi_J,B,beta,phi);

figure; hold on; makeAxesLogLog;
xlabel('\phi_{0,2}-\phi'); ylabel('\eta'); prettyplot;
for kk=1:length(phi)
    myColor = colorP(P(kk));
    plot(phiJfit_upper.phi_J-phi(kk),eta(kk),'o','Color',myColor);
end
phiplot = sort(phi);
dphiplot = phiJfit_upper.phi_J-phiplot;
plot(dphiplot,etaPhi(muJfit_lower.mu_c,muJfit_lower.A,muJfit_lower.alpha,phiJfit_lower.phi_J,phiJfit_lower.B,phiJfit_lower.beta,phiplot),'-','Color','#189100');
plot(dphiplot,etaPhi(muJfit_upper.mu_c,muJfit_upper.A,muJfit_upper.alpha,phiJfit_upper.phi_J,phiJfit_upper.B,phiJfit_upper.beta,phiplot),'-','Color','#ff7912');
plot(dphiplot,dphiplot.^(-1/phiJfit_upper.beta),'k--')

figure; hold on; makeAxesLogLog;
xlabel('\phi_{0,1}-\phi'); ylabel('\eta'); prettyplot;
for kk=1:length(phi)
    myColor = colorP(P(kk));
    plot(phiJfit_lower.phi_J-phi(kk),eta(kk),'o','Color',myColor);
end
phiplot = sort(phi);
dphiplot = phiJfit_lower.phi_J-phiplot;
plot(phiJfit_lower.phi_J-phiplot,etaPhi(muJfit_lower.mu_c,muJfit_lower.A,muJfit_lower.alpha,phiJfit_lower.phi_J,phiJfit_lower.B,phiJfit_lower.beta,phiplot),'-','Color','#189100');
plot(phiJfit_lower.phi_J-phiplot,etaPhi(muJfit_upper.mu_c,muJfit_upper.A,muJfit_upper.alpha,phiJfit_upper.phi_J,phiJfit_upper.B,phiJfit_upper.beta,phiplot),'-','Color','#ff7912');
plot(dphiplot,dphiplot.^(-1/phiJfit_lower.beta),'k--')

%% eta vs phi

figure; hold on; makeAxesLogLog;
xlabel('\phi'); ylabel('\eta'); prettyplot;
for kk=1:length(phi)
    myColor = colorP(P(kk));
    %myColor = colorSigma(sigma(kk));
    plot(phi(kk),eta(kk),'o','Color',myColor);
end
phiplot = sort(phi);
plot(phiplot,etaPhi(muJfit_lower.mu_c,muJfit_lower.A,muJfit_lower.alpha,phiJfit_lower.phi_J,phiJfit_lower.B,phiJfit_lower.beta,phiplot),'-','Color','#189100');
plot(phiplot,etaPhi(muJfit_upper.mu_c,muJfit_upper.A,muJfit_upper.alpha,phiJfit_upper.phi_J,phiJfit_upper.B,phiJfit_upper.beta,phiplot),'-','Color','#ff7912');