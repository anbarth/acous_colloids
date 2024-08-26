phi = [0.2, 0.3, 0.4, 0.44, 0.52, 0.56, 0.59];
eta = [0.095, 0.165, 0.33, 0.38, 0.8, 1.7, 1.7];
eta_solvent = 1.4/25;

%p = polyfit(phi,(eta/eta_solvent).^(-1/2),1);

ft1 = fittype('1-a*x');
myfit = fit(phi',(eta/eta_solvent).^(-1/2)',ft1);

figure;
plot(myfit,phi',(eta/eta_solvent).^(-1/2)');

%figure; hold on;
%plot(phi,eta.^(-1/2),'ok');
%plot(phi,p(1)*phi+p(2),'-r');
%disp(-p(2)/p(1))

