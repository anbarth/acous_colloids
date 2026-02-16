% set up
MIPS_with_stress_real_values;
%MIPS_with_stress_frictional;
%MIPS_yield_stress;


phi_low = 0.3;
phi_high = phi0-0.01;
E_low = 0;
E_high = 10*Estar(0); %5*Estar;

% make the E-phi plane
figure; hold on;
xlabel('\phi'); ylabel('E')
xlim([phi_low phi0+0.01]); ylim([E_low E_high])


% plot the binodal line for a few sigma

sigma_list = [0 5 20 100];
%sigma_list = 0;
cmap = cool(length(sigma_list));
for ii = 1:length(sigma_list)
    sigma = sigma_list(ii);
    E_binodal = linspace(Estar(sigma),E_high);
    color = cmap(ii,:);
    plot(phi1(E_binodal,sigma),E_binodal,'Color',color,'LineWidth',2);
    plot(phi2(E_binodal,sigma),E_binodal,'Color',color,'LineWidth',2);
end
xline(phi0,'k')
%xline(0.49,'b')
%xline(0.56,'b')
%xline(0.58,'b')

% cmap = viridis(6);
% l = [1.5,1.75,2,2.5,3,4];
% for ii=1:length(l)
%     yline(Estar*l(ii),'Color',cmap(ii,:))
% end

prettyplot

