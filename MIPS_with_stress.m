phi0 = 0.64;


eta0 = 1;
sigma=100;

% activity-free rheology: eta ~ (phi0-phi)^-2
%eta_0V = @(phi) eta0*(phi0-phi).^(-2);
eta_0V = @(phi) min(1e7,eta0*(phi0-phi).^(-2));

% parameters describing the shape of the phase boundary in the E-phi plane
a_left = @(sigma) 0.1-0.085/100*sigma;
a_right = @(sigma) 0.03;
Emin = 1;
phistar = 0.6;

% left & right branches of the phase boundary in the E-phi plane
phi1 = @(E,sigma) phistar - a_left(sigma)*(E-Emin).^(1/2);
phi2 = @(E,sigma) min(phi0, phistar + a_right(sigma)*(E-Emin).^(1/2));

% calculating the viscosity for a suspension in the 2-phase region:
% n1, n2 are particle number densities of phase 1 and phase 2
% eta = n1 eta1 + n2 eta2
n1 = @(phi,phi1,phi2) phi1/phi * (phi2-phi)/(phi2-phi1);
n2 = @(phi,phi1,phi2) phi2/phi * (phi-phi1)/(phi2-phi1);
eta1 = @(E,sigma) eta_0V(phi1(E,sigma));
eta2 = @(E,sigma) eta_0V(phi2(E,sigma));
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
eta_mat = zeros(length(phi),length(E));

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

        plot(phi(i),E(j),'s','Color',colorEta(eta))
        eta_mat(i,j) = eta;
    end
end
%return
eta = logspace(log10(minEta),log10(maxEta),20);
cmap = viridis(256);

E_fine = linspace(0,5*Emin);
for i=1:length(eta)
    phi_equi = phi_equi_viscosity(eta(i),E_fine,sigma);
    inside_binodal = phi_equi>phi1(E_fine,sigma) & phi_equi<phi2(E_fine,sigma);
    outside_binodal = ~inside_binodal & ~isnan(phi_equi);
    phi_inside = phi_equi(inside_binodal);
    E_inside = E_fine(inside_binodal);

    E_outside = E_fine(outside_binodal);
    phi_outside = phi0-(eta(i)/eta0)^(-1/2)*ones(size(E_outside));

    phi_equi = [phi_outside,phi_inside];
    E_equi = [E_outside,E_inside];
    plot(phi_equi,E_equi,'Color',colorEta(eta(i)));
end


% [E_mat,phi_mat] = meshgrid(E,phi);
% scatter(phi_mat(:),E_mat(:),[],log(eta_mat(:)),"filled",'s')
% 
% E_finer = linspace(0,Emin*5,1000);
% phi_finer = linspace(0,phi0-0.01,1000);
% [E_finer_mat,phi_finer_mat] = meshgrid(E_finer,phi_finer);
% eta_interpolated = interp2(E_mat,phi_mat,eta_mat,E_finer_mat,phi_finer_mat);
% 
% eta = logspace(log10(minEta),log10(maxEta),10);
% for i=1:length(eta)
%     epsilon=0.05;
%     near_eta = eta_interpolated/eta(i) < 1+epsilon & eta_interpolated/eta(i) > 1-epsilon;
%     plot(phi_finer_mat(near_eta),E_finer_mat(near_eta))
% end
