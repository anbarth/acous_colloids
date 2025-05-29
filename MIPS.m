phi0 = 0.64;
phistar = 0.58;
a = 0.1; % higher stress = skinner binodal = lower a
Emin = 1;
eta0 = 1;

%eta_0V = @(phi) eta0*(phi0-phi).^(-2);
eta_0V = @(phi) min(1e7,eta0*(phi0-phi).^(-2));
phi1 = @(E) phistar - a*(E-Emin).^(1/2);
phi2 = @(E) min(phi0, phistar + a*(E-Emin).^(1/2));
eta1 = @(E) eta_0V(phi1(E));
eta2 = @(E) eta_0V(phi2(E));
n1 = @(phi,phi1,phi2) phi1/phi * (phi2-phi)/(phi2-phi1);
n2 = @(phi,phi1,phi2) phi2/phi * (phi-phi1)/(phi2-phi1);
eta_binodal = @(phi,E)  n1(phi,phi1(E),phi2(E))*eta1(E) + n2(phi,phi1(E),phi2(E))*eta2(E);

phi_equi_viscosity = @(eta,E) phi1(E).*phi2(E).*(eta1(E)-eta2(E)) ./ ( eta*(phi2(E)-phi1(E))+eta1(E).*phi1(E)-eta2(E).*phi2(E) );

figure; hold on;
xlabel('\phi'); ylabel('E')
xlim([0.3 phi0])

% plot the binodal line
E = linspace(Emin,Emin*5);
plot(phi1(E),E,'k');
plot(phi2(E),E,'k');

% plot eta
E = linspace(0,Emin*5,30);
phi = linspace(0.3,phi0-0.01,20);

minEta = 1e1; maxEta = 1e7;
colorEta = @(eta) cmap( min(256,max(1,round(1+255*(log(eta)-log(minEta))/(log(maxEta)-log(minEta))))) ,:);

cmap = viridis(256);
colormap(cmap);
for i=1:length(phi)
    for j=1:length(E)
        if E(j) > Emin && phi(i) > phi1(E(j)) && phi(i) < phi2(E(j)) 
            eta = eta_binodal(phi(i),E(j));
        else
            eta = eta_0V(phi(i));
        end
        
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
    phi_equi = phi_equi_viscosity(eta(i),E);
    inside_binodal = phi_equi>phi1(E) & phi_equi<phi2(E);
    outside_binodal = ~inside_binodal & ~isnan(phi_equi);
    phi_inside = phi_equi(inside_binodal);
    E_inside = E(inside_binodal);

    E_outside = E(outside_binodal);
    phi_outside = phi0-(eta(i)/eta0)^(-1/2)*ones(size(E_outside));

    phi_equi = [phi_outside,phi_inside];
    E_equi = [E_outside,E_inside];
    plot(phi_equi,E_equi,'Color',colorEta(eta(i)));
end

