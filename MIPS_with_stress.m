phi0 = 0.64;
phistar = 0.6;
Emin = 1;
eta0 = 1;
sigma=100;

%a = @(sigma) 0.015; % high sigma
%a = @(sigma) 0.1; % low sigma
a2 = @(sigma) 0.03;

a = @(sigma) 0.1-0.085/100*sigma;
%eta_0V = @(phi) eta0*(phi0-phi).^(-2);
eta_0V = @(phi) min(1e7,eta0*(phi0-phi).^(-2));
phi1 = @(E,sigma) phistar - a(sigma)*(E-Emin).^(1/2);
phi2 = @(E,sigma) min(phi0, phistar + a2(sigma)*(E-Emin).^(1/2));
eta1 = @(E,sigma) eta_0V(phi1(E,sigma));
eta2 = @(E,sigma) eta_0V(phi2(E,sigma));
n1 = @(phi,phi1,phi2) phi1/phi * (phi2-phi)/(phi2-phi1);
n2 = @(phi,phi1,phi2) phi2/phi * (phi-phi1)/(phi2-phi1);
eta_binodal = @(phi,E,sigma)  n1(phi,phi1(E,sigma),phi2(E,sigma))*eta1(E,sigma) + n2(phi,phi1(E,sigma),phi2(E,sigma))*eta2(E,sigma);

phi_equi_viscosity = @(eta,E,sigma) phi1(E,sigma).*phi2(E,sigma).*(eta1(E,sigma)-eta2(E,sigma)) ./ ( eta*(phi2(E,sigma)-phi1(E,sigma))+eta1(E,sigma).*phi1(E,sigma)-eta2(E,sigma).*phi2(E,sigma) );

figure; hold on;
xlabel('\phi'); ylabel('E')
xlim([0.3 phi0])

% plot the binodal line
E = linspace(Emin,Emin*5);
plot(phi1(E,sigma),E,'k');
plot(phi2(E,sigma),E,'k');

% plot eta
E = linspace(0,Emin*5,30);
phi = linspace(0.3,phi0-0.01,20);

minEta = 1e1; maxEta = 1e7;

cmap = viridis(256);
colormap(cmap);
colorEta = @(eta) cmap( min(256,max(1,round(1+255*(log(eta)-log(minEta))/(log(maxEta)-log(minEta))))) ,:);

for i=1:length(phi)
    for j=1:length(E)
        if E(j) > Emin && phi(i) > phi1(E(j),sigma) && phi(i) < phi2(E(j),sigma) 
            eta = eta_binodal(phi(i),E(j),sigma);
        else
            eta = eta_0V(phi(i));
        end
        
       % rate = sigma/eta;
       % if rate < 1e-5
       %     eta=Inf;
       % end

        %scatter(phi(i),E(j),[],log(eta),"filled",'s')
        plot(phi(i),E(j),'s','Color',colorEta(eta))
    end
end
%return
eta = logspace(log10(minEta),log10(maxEta),20);
E = linspace(0,Emin*5);
cmap = viridis(256);

%eta = 10^2;
for i=1:length(eta)
    phi_equi = phi_equi_viscosity(eta(i),E,sigma);
    inside_binodal = phi_equi>phi1(E,sigma) & phi_equi<phi2(E,sigma);
    outside_binodal = ~inside_binodal & ~isnan(phi_equi);
    phi_inside = phi_equi(inside_binodal);
    E_inside = E(inside_binodal);

    E_outside = E(outside_binodal);
    phi_outside = phi0-(eta(i)/eta0)^(-1/2)*ones(size(E_outside));

    phi_equi = [phi_outside,phi_inside];
    E_equi = [E_outside,E_inside];
    plot(phi_equi,E_equi,'Color',colorEta(eta(i)));
end

