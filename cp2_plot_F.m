my_vol_frac_markers = ['>','s','o','d','h'];


cp2_collapse_parameters;



vol_frac_plotting_range = 1:4;
volt_plotting_range = 1:8;
colorBy = 4; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = viridis(256); 
fig1 = figure;
ax1 = axes('Parent', fig1,'XScale','log','YScale','log');
ax1.XLabel.String = "\sigma";
ax1.YLabel.String = "f(\sigma)";
ax1.XLim = [10^(0.5),10^3.5];
colormap(ax1,cmap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stressTable = cp_data_01_18;
phi_list = [44,48,50,54];
volt_list = [0,5,10,20,40,60,80,100];

sigma_min = 0.03*CSS;
sigma_max = 160*CSS;
sigma_fake = logspace(log10(sigma_min),log10(sigma_max));
hold(ax1,'on');
plot(sigma_fake,f(sigma_fake),'r');

sigmastar2 = 15;
k2=1;
f2 = @(sigma) exp(-(sigmastar2 ./ sigma).^k2);
plot(sigma_fake,f2(sigma_fake),'b--');

for ii = vol_frac_plotting_range
    for jj = volt_plotting_range
        voltage = volt_list(jj);
        phi = phi_list(ii)/100;
        myData = stressTable( stressTable(:,1)==phi & stressTable(:,2)==voltage,:);
        sigma_rheo = myData(:,3);
        sigma = sigma_rheo*CSS;
        
       
        myColor = cmap(round(1+255*(phi-0.44)/(0.55-0.44)),:);

        
        my_f_mod = f_mod(ii,1:length(sigma))';
        my_f = f(sigma).*my_f_mod;
        myMarker = my_vol_frac_markers(ii);

        hold(ax1,'on');
        scatter(ax1,sigma,my_f,[],myColor,'filled',myMarker);
 
    end
end

c1 = colorbar(ax1);
caxis(ax1,[.44 .55]);
c1.Ticks = phi_list/100;
