phi0 = 0.64;
phistar = 0.6;
Emin = 1;
eta0 = 1;
phi=0.55;

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
xlabel('\sigma'); ylabel('E')


% plot eta
E = linspace(0,Emin*5,100);
sigma = linspace(0,100,100);
eta_mat = zeros(length(sigma),length(E));

minEta = 1e1; maxEta = 1e7;
colorEta = @(eta) cmap( min(256,max(1,round(1+255*(log(eta)-log(minEta))/(log(maxEta)-log(minEta))))) ,:);

cmap = viridis(256);
colormap(cmap);
for i=1:length(sigma)
    for j=1:length(E)
        if E(j) > Emin && phi > phi1(E(j),sigma(i)) && phi < phi2(E(j),sigma(i)) 
            eta = eta_binodal(phi,E(j),sigma(i));
        else
            eta = eta_0V(phi);
        end
        eta_mat(i,j) = eta;
        %scatter(sigma(i),E(j),[],log(eta),"filled",'s')
        %plot(phi(i),E(j),'s','Color',colorEta(eta))
    end
end


[E_mat,sigma_mat] = meshgrid(E,sigma);
%scatter(sigma_mat(:),E_mat(:),[],log(eta_mat(:)),"filled",'s')
eta_color_mat = min(eta_mat,1e5);
scatter(sigma_mat(:),E_mat(:),[],log(eta_color_mat(:)),"filled",'s')

% E_finer = linspace(0,Emin*5,1000);
% sigma_finer = linspace(0,100,1000);
% [E_finer_mat,sigma_finer_mat] = meshgrid(E_finer,sigma_finer);
% eta_interpolated = interp2(E_mat,sigma_mat,eta_mat,E_finer_mat,sigma_finer_mat);
%scatter(sigma_finer_mat(:),E_finer_mat(:),[],log(eta_interpolated(:)),'.')

return
eta = logspace(log10(minEta),log10(maxEta),10);
%eta = 10;
for i=1:length(eta)
    epsilon=0.05;
    near_eta = eta_interpolated/eta(i) < 1+epsilon & eta_interpolated/eta(i) > 1-epsilon;
    plot(sigma_finer_mat(near_eta),E_finer_mat(near_eta))
end

