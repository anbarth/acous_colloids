% set up
MIPS_with_stress_frictional;

% pick a volume fraction and a range of (sigma,E)
phi=0.55;
E_low = 0;
E_high = 5*Estar;
sigma_low = 0;
sigma_high = 100;


% make the sigma-E plane
figure; hold on;
xlabel('\sigma'); ylabel('E');
xlim([sigma_low sigma_high]); ylim([E_low E_high])

% define a colormap for viscosity
cmap = viridis(256); colormap(cmap);


% calculate eta for discrete values of sigma, E
E = linspace(E_low,E_high,100);
sigma = linspace(sigma_low,sigma_high,100);
eta_mat = zeros(length(sigma),length(E));
for i=1:length(sigma)
    for j=1:length(E)
        % use the appropriate formula if (phi,E) is in the 2 phase region
        if E(j) > Estar && phi > phi1(E(j),sigma(i)) && phi < phi2(E(j),sigma(i)) 
            eta = eta_binodal(phi,E(j),sigma(i));
        else
            eta = eta_0V(phi,sigma(i));
        end
        eta_mat(i,j) = eta;
    end
end

% plot values of eta in color 
% NOTE that there's a max cutoff imposed here
[E_mat,sigma_mat] = meshgrid(E,sigma);
eta_color_mat = min(eta_mat,1e5);
scatter(sigma_mat(:),E_mat(:),[],log(eta_color_mat(:)),"filled",'s')

% plot equi-viscosity lines by solving numerically
% E_finer = linspace(0,Emin*5,1000);
% sigma_finer = linspace(0,100,1000);
% [E_finer_mat,sigma_finer_mat] = meshgrid(E_finer,sigma_finer);
% eta_interpolated = interp2(E_mat,sigma_mat,eta_mat,E_finer_mat,sigma_finer_mat);
% scatter(sigma_finer_mat(:),E_finer_mat(:),[],log(eta_interpolated(:)),'.')
% eta = logspace(log10(minEta),log10(maxEta),10);
% for i=1:length(eta)
%     epsilon=0.05;
%     near_eta = eta_interpolated/eta(i) < 1+epsilon & eta_interpolated/eta(i) > 1-epsilon;
%     plot(sigma_finer_mat(near_eta),E_finer_mat(near_eta))
% end

