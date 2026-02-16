cmap= plasma(256);
volt_list = [0 5 10 20 40 60 80];
logMinE0 = log(acoustic_energy_density(5));
logMaxE0 = log(acoustic_energy_density(80));

dataTable = may_ceramic_09_17;
allData = {phi44_05_29,phi46_06_19,phi48_05_31,phi52_05_29,phi54_06_01,phi56_05_31,phi59_05_30,phi61_06_20};


phi_list = unique(dataTable(:,1));
phi = phi_list(13);
%sigma=2;
CSV = (50/19)^3;
CSS = (50/19)^3;
beta=2*pi/180;

figure; hold on; ax1=gca; ax1.YScale='log';
for sigma = 20
for jj=2:length(volt_list)
    V = volt_list(jj);
    E0 = acoustic_energy_density(V);
    if E0==0
        myColor = [0 0 0];
    else
        myColor = cmap(round(1+255*(log(E0)-logMinE0)/( logMaxE0-logMinE0 )),:);
    end
    [eta,t,tStart] = findThisPerturbationDisplayInfo(phi,sigma,V,allData);
    angular_velocity = sigma./eta*beta;
    plot(t-tStart,angular_velocity,'-','Color',myColor,'LineWidth',2);
end
end
xlim([-5 10])



xlabel('Time since perturbation (s)')
ylabel('Angular velocity (1/s)')
prettyPlot;


colormap(cmap);
c1=colorbar;
%clim([0 80]);
%c1.Ticks = [0,5,10,20,40,60,80];

myfig = gcf;
myfig.Position=[100,100,465,323];
ax1=gca;
ax1.YTick = [1e3 1e4];

return
%%
omega = 35; % Hz
sampling_rate = 10; % Hz
x = linspace(0,5,5/1e-3); % s
y = sin(x*omega); % real data
sampled_points = mod(x,1/sampling_rate) <= 1e-3;
figure; hold on;
plot(x,y,'-','Color',[0.5 0.5 0.5]);
plot(x(sampled_points),y(sampled_points),'kx-','LineWidth',2);
ylim([-1.5 1.5])