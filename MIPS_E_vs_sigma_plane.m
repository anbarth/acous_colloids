% set up
%MIPS_with_stress_frictional;
%MIPS_yield_stress;
MIPS_with_stress_real_values;

% pick a volume fraction and a range of (sigma,E)
phi=0.58;
E_low = 0;
E_high = 10*Estar(0); %5*Estar;
sigma_low = 1;
sigma_high = 100;


% make the sigma-E plane
figure; hold on; prettyplot
xlabel('\sigma'); ylabel('E');
ax1=gca;ax1.XScale='log';
xlim([sigma_low sigma_high]); ylim([E_low E_high])

% define a colormap for viscosity
cmap = viridis(256); colormap(cmap);


% calculate eta for discrete values of sigma, E
E = linspace(E_low,E_high,100);
%sigma = linspace(sigma_low,sigma_high,100);
sigma = logspace(log10(sigma_low),log10(sigma_high),100);
eta_mat = zeros(length(sigma),length(E));
for i=1:length(sigma)
    for j=1:length(E)
        % use the appropriate formula if (phi,E) is in the 2 phase region
        if E(j) > Estar(sigma(i)) && phi > phi1(E(j),sigma(i)) && phi < phi2(E(j),sigma(i)) 
            eta = eta_binodal(phi,E(j),sigma(i));
        else
            eta = eta_0V(phi,sigma(i));
        end
        eta_mat(i,j) = eta;
    end
end

% plot values of eta in color 
[E_mat,sigma_mat] = meshgrid(E,sigma);
%eta_color_mat = eta_mat;
eta_color_mat = min(eta_mat,1e7); eta_color_mat = max(eta_color_mat,10);
scatter(sigma_mat(:),E_mat(:),[],log(eta_color_mat(:)),"filled",'s')

%jammed = eta_mat>3000;
%scatter(sigma_mat(jammed),E_mat(jammed),[],"filled",'s')

scatter(0,0,[],log(1e7))
scatter(0,0,[],log(10))


c1=colorbar;
ticklist = [1 10 100 1e3 1e4 1e5 1e6];
c1.Ticks = log(ticklist);
c1.TickLabels = num2cell(ticklist);

f=gcf; f.Position=[360,97.66666666666666,413.6666666666666,420];

return
% plot equi-viscosity lines by solving numerically
E_finer = linspace(E_low,E_high,1000);
sigma_finer = linspace(sigma_low,sigma_high,1000);
[E_finer_mat,sigma_finer_mat] = meshgrid(E_finer,sigma_finer);
eta_interpolated = interp2(E_mat,sigma_mat,eta_mat,E_finer_mat,sigma_finer_mat);
%scatter(sigma_finer_mat(:),E_finer_mat(:),[],log(eta_interpolated(:)),'.')
eta = logspace(log10(minEta),log10(maxEta),10);
%eta = 3000;
for i=1:length(eta)
    epsilon=0.01;
    near_eta = eta_interpolated/eta(i) < 1+epsilon & eta_interpolated/eta(i) > 1-epsilon;
    plot(sigma_finer_mat(near_eta),E_finer_mat(near_eta),'w-')
end


