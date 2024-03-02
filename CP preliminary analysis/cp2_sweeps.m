my_cp_data = cp_data_01_18;

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

%phi_low = [.2,.25,.3,.35,.4];
phi_low = [.2,.3,.35,.4];
phi_high = [.44,.48,.5,.54];
minPhi = .2;
maxPhi = .55;
%cmap = flipud(viridis(256)); 
cmap = turbo;

for ii=1:length(phi_low)
    phi = phi_low(ii);
    myData = cp_low_phi(cp_low_phi(:,1)==phi, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = CSS*myData(:,2);
    eta = CSV/1000*myData(:,3);
    gamma_dot = sigma./eta;
    plot(sigma,eta, '-o','Color',myColor);
    %plot(sigma,sigma.*gamma_dot, '-o','Color',myColor);
end
for ii=1:length(phi_high)
    phi = phi_high(ii);
    myData = my_cp_data(my_cp_data(:,1)==phi & my_cp_data(:,2)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = CSS*myData(:,3);
    eta = CSV/1000*myData(:,4);
    gamma_dot = sigma./eta;
    plot(sigma,eta, '-o','Color',myColor,'LineWidth',1);
    %plot(sigma,sigma.*gamma_dot,'-o','Color',myColor);
end
colormap(cmap);
c = colorbar;
c.Ticks = [phi_low,phi_high];
caxis([minPhi maxPhi])

xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');
box on;