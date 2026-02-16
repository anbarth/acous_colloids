% set up
MIPS_with_stress_frictional;
%MIPS_yield_stress;

% pick an E and a range of (phi, sigma)
E=0;
phi_low = 0.4;
phi_high = phi0-0.01;
sigma_low = 0;
sigma_high = 10;

% make the E-phi plane
figure; hold on; prettyplot
xlabel('\phi'); ylabel('\sigma')
xlim([phi_low phi0]); ylim([sigma_low sigma_high])

% draw the binodal
sig_plot=linspace(sigma_low,sigma_high);
plot(phi1(E,sig_plot),sig_plot,'Color','k');
plot(phi2(E,sig_plot),sig_plot,'Color','k');

% draw binodal at different Es
cmap = viridis(6);
sig_plot=linspace(sigma_low,sigma_high);
l = [1.5,1.75,2,2.5,3,4];
for ii=1:length(l)
    plot(phi1(Estar*l(ii),sig_plot),sig_plot,'Color',cmap(ii,:));
    plot(phi2(Estar*l(ii),sig_plot),sig_plot,'Color',cmap(ii,:));
end

return


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
        if E > Estar && phi(i) > phi1(E,sigma(j)) && phi(i) < phi2(E,sigma(j)) 
            eta = eta_binodal(phi(i),E,sigma(j));
        else
            eta = eta_0V(phi(i),sigma(j));
        end
        
        % model the minimum rate resolution of the rheometer?
       % rate = sigma/eta;
       % if rate < 1e-5
       %     eta=Inf;
       % end

        plot(phi(i),sigma(j),'s','Color',colorEta(eta))
        eta_mat(i,j) = eta;
    end
end

% plot values of eta in color 
% NOTE that there's a max cutoff imposed here
[sigma_mat,phi_mat] = meshgrid(sigma,phi);
eta_color_mat = min(eta_mat,1e5);
scatter(phi_mat(:),sigma_mat(:),[],log(eta_color_mat(:)),"filled",'s')