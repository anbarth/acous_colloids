%phi = [0.2, 0.3, 0.4, 0.44, 0.52, 0.56, 0.59];
%       0.2    0.3   0.4   0.44  0.52 0.56 0.59
%eta = [0.098, 0.16, 0.33, 0.36, 0.8, 1.7, 1.7];
phi = [0.1999,  0.2503, 0.2997, 0.3500, 0.4003, 0.44];
eta = [0.098,  0.125, 0.16, 0.22, 0.3, 0.4];
eta_err = [0.01,0.01,0.01, 0.01, 0.05, 0.05];
eta12_err = 1/2*eta.^(-3/2).*eta_err;

p = polyfit(phi,eta.^(-1/2),1);

figure; hold on;
errorbar(phi,eta.^(-1/2),eta12_err,'ok');
errorbar(0.59,1.5^(-1/2),0.5*1/2*(1.5)^(-3/2),'db')
plot([phi,0.7],p(1)*[phi,0.7]+p(2),'-r');
disp(-p(2)/p(1))
%disp()


myEta = [0.36,0.8,1.5,1.7];
myPhiPredicted = (myEta.^(-1/2)-p(2))/p(1);
disp(myPhiPredicted)
scatter(myPhiPredicted,myEta.^(-1/2),'db')

myPhi = 0.59;
myEta12 = p(1)*myPhi+p(2);
myEtaPredicted = myEta12^(-2);
disp(myEtaPredicted);
scatter(0.59,3^(-1/2),'ro')