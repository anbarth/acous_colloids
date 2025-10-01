% set up
%MIPS_with_stress_frictional;
MIPS_yield_stress;

% pick a stress [0,100] and a range of (phi, E)
sigma=2;
phi_low = 0.3;
phi_high = phi0-0.01;
E_low = 0;
E_high = 5*Estar;

% make the E-phi plane
figure; hold on;
xlabel('\phi'); ylabel('E')
xlim([phi_low phi0]); ylim([E_low E_high])

% define a colormap for viscosity (NOTE that there's cutoff values, but theyre not currently used)
minEta = 1e1; maxEta = 1e7;
cmap = viridis(256); colormap(cmap);
%colorEta = @(eta) cmap( min(256,max(1,round(1+255*(log(eta)-log(minEta))/(log(maxEta)-log(minEta))))) ,:);

% plot the binodal line
E_binodal = linspace(Estar,Estar*5);
%plot(phi1(E_binodal,0),E_binodal,'k');
%plot(phi2(E_binodal,0),E_binodal,'k');

plot(phi1(E_binodal,sigma),E_binodal,'k');
plot(phi2(E_binodal,sigma),E_binodal,'k');

% cmap = viridis(6);
% l = [1.5,1.75,2,2.5,3,4];
% for ii=1:length(l)
%     yline(Estar*l(ii),'Color',cmap(ii,:))
% end

prettyplot
%return
% calculate eta for discrete values of phi, E
E = linspace(E_low,E_high,100);
phi = linspace(phi_low,phi_high,100);
eta_mat = zeros(length(phi),length(E));
for i=1:length(phi)
    for j=1:length(E)
        % use the appropriate formula if (phi,E) is in the 2 phase region
        if E(j) > Estar && phi(i) > phi1(E(j),sigma) && phi(i) < phi2(E(j),sigma) 
            eta = eta_binodal(phi(i),E(j),sigma);
        else
            eta = eta_0V(phi(i),sigma);
        end
        
        % model the minimum rate resolution of the rheometer?
       % rate = sigma/eta;
       % if rate < 1e-5
       %     eta=Inf;
       % end

        eta_mat(i,j) = eta;
    end
end


% plot equi-viscosity lines by solving for them numerically
[E_mat,phi_mat] = meshgrid(E,phi);
scatter(phi_mat(:),E_mat(:),[],log(eta_mat(:)),"filled",'s')
%scatter(0,0,[],log(1e7))

E_finer = linspace(0,Estar*5,1000);
phi_finer = linspace(0,phi0-0.01,1000);
[E_finer_mat,phi_finer_mat] = meshgrid(E_finer,phi_finer);
eta_interpolated = interp2(E_mat,phi_mat,eta_mat,E_finer_mat,phi_finer_mat);

eta = logspace(log10(minEta),log10(maxEta),10);
for i=1:length(eta)
    epsilon=0.01;
    near_eta = eta_interpolated/eta(i) < 1+epsilon & eta_interpolated/eta(i) > 1-epsilon;
    %plot(phi_finer_mat(near_eta),E_finer_mat(near_eta),'w')
end

c1=colorbar;
%ticklist = [4,6,8,10,12,14];
ticklist = [1 10 100 1e3 1e4 1e5 1e6 1e7];
c1.Ticks = log(ticklist);
c1.TickLabels = num2cell(ticklist);


% plot equi-viscosity lines analytically (ONLY WORKS FOR FRICTIONLESS RHEOLOGY)
% eta_show_lines = logspace(log10(minEta),log10(maxEta),20);
% E_fine = linspace(0,5*Estar);
% for i=1:length(eta_show_lines)
%     phi_equi = phi_equi_viscosity(eta_show_lines(i),E_fine,sigma);
%     inside_binodal = phi_equi>phi1(E_fine,sigma) & phi_equi<phi2(E_fine,sigma);
%     outside_binodal = ~inside_binodal & ~isnan(phi_equi);
%     phi_inside = phi_equi(inside_binodal);
%     E_inside = E_fine(inside_binodal);
% 
%     E_outside = E_fine(outside_binodal);
%     phi_outside = phi0-(eta_show_lines(i)/eta0)^(-1/2)*ones(size(E_outside));
% 
%     phi_equi = [phi_outside,phi_inside];
%     E_equi = [E_outside,E_inside];
%     plot(phi_equi,E_equi,'Color',colorEta(eta_show_lines(i)));
% end
