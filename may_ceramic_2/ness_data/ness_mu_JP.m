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

%% plot and fit to mu(J,P)
figure; hold on; makeAxesLogLog;
xlabel('J'); ylabel('\mu')
for kk=1:length(mu)
    myColor = colorP(P(kk));
    %myColor = colorPhi(dataTable(kk,1));
    plot(J(kk),mu(kk),'o','Color',myColor)
end
prettyplot

muJ = @(mu_c,A,alpha,J) mu_c+A*J.^alpha; 
f = @(P,Pc) exp(-Pc./P);
muJP = @(mu_c1,A1,alpha1,mu_c2,A2,alpha2,Pc,J,P) muJ(mu_c1,A1,alpha1,J).*(1-f(P,Pc)) + muJ(mu_c2,A2,alpha2,J).*f(P,Pc);
muJPfittype = fittype(muJP,"Independent",["J","P"]);


m = fit([J,P],mu,muJPfittype,'StartPoint',[0.15 4 0.5 0.33 2.6 0.4 0.1]);

Jplot = sort(J);
for myP=logspace(-4,2,5)
    plot(Jplot,muJP(m.mu_c1,m.A1,m.alpha1,m.mu_c2,m.A2,m.alpha2,m.Pc,Jplot,myP),'-','Color',colorP(myP));
end

%% plot and fit to phi(J,P)
figure; hold on; makeAxesLogLog;
xlabel('J'); ylabel('\phi')
for kk=1:length(mu)
    myColor = colorP(P(kk));
    plot(J(kk),phi(kk),'o','Color',myColor)
end
prettyplot

phiJ = @(phi_J,B,alpha,J) phi_J./(1+B*J.^alpha); 
phiJP = @(phi_J1,B1,alpha1,phi_J2,B2,alpha2,Pc,J,P) phiJ(phi_J1,B1,alpha1,J).*(1-f(P,Pc)) + phiJ(phi_J2,B2,alpha2,J).*f(P,Pc);
phiJPfittype = fittype(phiJP,"Independent",["J","P"]);

p = fit([J,P],phi,phiJPfittype,'StartPoint',[0.64 1 0.5 0.6 1.3 0.4 0.1]);

for myP=logspace(-4,2,5)
    plot(Jplot,phiJP(p.phi_J1,p.B1,p.alpha1,p.phi_J2,p.B2,p.alpha2,p.Pc,Jplot,myP),'-','Color',colorP(myP));
end

%% eta(phi,sigma)??
finv(x,Pc) = -Pc./log(x);
PJphi = @(phi_J1,B1,alpha1,phi_J2,B2,alpha2,Pc,J,phi) finv( (phi-phiJ(phi_J1,B1,alpha1,J))/(phiJ(phi_J2,B2,alpha2,J)-phiJ(phi_J1,B1,alpha1,J)) , Pc );
sigmaJphi = @(mu_c1,A1,alpha1,mu_c2,A2,alpha2,Pc,J,phi) 
