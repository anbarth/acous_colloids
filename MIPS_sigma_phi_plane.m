% set up
MIPS_with_stress_frictional;

% pick an E and a range of (phi, sigma)
E=0;
phi_low = 0.3;
phi_high = phi0-0.01;
sigma_low = 0;
sigma_high = 100;

% make the E-phi plane
figure; hold on;
xlabel('\phi'); ylabel('sigma')
xlim([phi_low phi0]); ylim([sigma_low sigma_high])

% define a colormap for viscosity (NOTE that there's cutoff values!)
minEta = 1e1; maxEta = 1e4;
cmap = viridis(256); colormap(cmap);
colorEta = @(eta) cmap( min(256,max(1,round(1+255*(log(eta)-log(minEta))/(log(maxEta)-log(minEta))))) ,:);

% calculate eta for discrete values of phi, sigma
sigma = linspace(sigma_low,sigma_high,60);
phi = linspace(phi_low,phi_high,60);
eta_mat = zeros(length(phi),length(E));
for i=1:length(phi)
    for j=1:length(sigma)
        % use the appropriate formula if (phi,E) is in the 2 phase region
        if E > Estar && phi(i) > phi1(E,sigma(j)) && phi < phi2(E,sigma(j)) 
            eta = eta_binodal(phi(i),E,sigma(j));
        else
            eta = eta_0V(phi(i),sigma(j));
        end
        
        % model the minimum rate resolution of the rheometer?
       % rate = sigma/eta;
       % if rate < 1e-5
       %     eta=Inf;
       % end

        %plot(phi(i),sigma(j),'s','Color',colorEta(eta))
        eta_mat(i,j) = eta;
    end
end

% plot values of eta in color 
% NOTE that there's a max cutoff imposed here
[sigma_mat,phi_mat] = meshgrid(sigma,phi);
eta_color_mat = min(eta_mat,1e5);
scatter(phi_mat(:),sigma_mat(:),[],log(eta_color_mat(:)),"filled",'s')