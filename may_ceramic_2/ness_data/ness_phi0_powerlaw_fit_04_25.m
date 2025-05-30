dataTable = chris_table_04_25;

figure; hold on; makeAxesLogLog;
xlabel('\phi_0-\phi')
ylabel('\eta')
prettyplot

phi = [];
eta = [];
sigma = [];
P = [];

for kk=1:size(dataTable,1)
    stress = dataTable(kk,2);
    if stress < 1e-3
        myPhi = dataTable(kk,1);
        myEta = dataTable(kk,4);

        phi(end+1) = myPhi;
        eta(end+1) = myEta;
        sigma(end+1) = dataTable(kk,2);
        P(end+1) = dataTable(kk,6);
    end
end


powerlaw = @(a,b,c,x) a*(c-x).^b;
powerlawfittype = fittype(powerlaw,'Independent','x');
phiFit = phi'; etaFit = eta';
%phiFit = phi(phi>0.57)'; etaFit = eta(phi>0.57)';
mypowfit = fit(phiFit,etaFit,powerlawfittype,'StartPoint',[1 -2 0.65],'Lower',[0 -Inf 0.6426],'Upper',[Inf 0 1],'Weights',(etaFit).^(-2));
phi0 = mypowfit.c;
disp(mypowfit)


plot(phi0-phi,eta,'ko');
%plot(phi0-phiFit,etaFit,'ko');
phiF = linspace(min(phi),max(phi));
plot(phi0-phiF,powerlaw(mypowfit.a,mypowfit.b,mypowfit.c,phiF),'r-')
%plot(phi0-phiF,powerlaw(1,-2,0.645,phiF),'r-')

return

% now try mu-J rheology
mu = sigma./P;
J = sigma./eta./P;
muJ = @(mu_c,A,alpha,J) mu_c+A*J.^alpha;
muJfittype = fittype(muJ,"Independent","J");
muJfit = fit(J',mu',muJfittype,'StartPoint',[0.15 4 0.5]);

Jphi = @(phi_J,B,beta,phi) (1/B*(phi_J./phi-1)).^(1/beta);
Jphifittype = fittype(Jphi,"Independent","phi");
Jphifit = fit(phi',J',Jphifittype,'StartPoint',[0.64 1 0.54],'Lower',[max(phi) 0 0],'Upper',[1 Inf Inf]);

etaPhi = @(mu_c,A,alpha,phi_J,B,beta,phi)  muJ(mu_c,A,alpha,Jphi(phi_J,B,beta,phi)) ./ Jphi(phi_J,B,beta,phi);
etaPhiFittype = fittype(etaPhi,"Independent","phi");
etaPhiFit = fit(phi',eta',etaPhiFittype,'StartPoint',[0.15 4 0.5 0.64 1 0.54],'Lower',[0 0 0 max(phi) 0 0],'Upper',[Inf Inf Inf 1 Inf Inf],'Weights',(eta').^(-2));

%plot(phi0-phiF,etaPhi(0.147,3.97,0.5,0.6397,1.06,0.54,phiF),'b-')
%plot(phi0-phiF,etaPhi(muJfit.mu_c,muJfit.A,muJfit.alpha,Jphifit.phi_J,Jphifit.B,Jphifit.beta,phiF),'b-')
plot(phi0-phiF,etaPhi(etaPhiFit.mu_c,etaPhiFit.A,etaPhiFit.alpha,etaPhiFit.phi_J,etaPhiFit.B,etaPhiFit.beta,phiF),'b-')