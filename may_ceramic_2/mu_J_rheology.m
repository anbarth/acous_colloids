mu_c = 0.3;
A = 3;
alpha = 0.5;

phiJ = 0.64;
B = 1;
beta = 0.5;

eta_s = 1;

mu = @(J) mu_c + A*J.^alpha;
phi = @(J) phiJ ./ (1+B*J.^beta);
J = @(phi) (1/B*(phiJ/phi-1))^(1/beta);



figure; hold on; 
makeAxesLogLog;
xlabel('\sigma')
ylabel('\eta')


% lines of constant P, but varying phi
for P=logspace(-2,2,5)
    myJ = logspace(-8,3);
    sigma = mu(myJ)*P;
    rate = myJ*P/eta_s;
    myphi = phi(myJ);
    %plot(sigma, rate, 'k-')
    scatter(sigma, sigma./rate, [],myphi)
end

for myphi = [0.01 0.2 0.4 0.5 0.63]
    %rate = logspace(-10,0);
    %P = rate*eta_s./J(myphi);
    %sigma = P*mu(J(myphi));
    
    sigma = logspace(-3,4);
    rate = sigma .* J(myphi) / eta_s * 1./mu(J(myphi));

    plot(sigma,sigma./rate,'k-');
end