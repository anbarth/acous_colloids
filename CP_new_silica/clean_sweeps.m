my_data = clean_data_09_11;

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

phi_high = [.48,.53];
minPhi = .4;
maxPhi = .55;
%cmap = flipud(viridis(256)); 
cmap = turbo;

for ii=1:length(phi_high)
    phi = phi_high(ii);
    myData = my_data(my_data(:,1)==phi & my_data(:,3)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    gamma_dot = sigma./eta;
    plot(sigma,eta, '-d','Color',myColor);
    %plot(sigma,sigma.*gamma_dot,'-o','Color',myColor);
end

plot(tween20_02_06_asc(:,1),tween20_02_06_asc(:,2),'-o','Color','k');
plot(tween20_02_06_des(:,1),tween20_02_06_des(:,2),'-o','Color','b');

%colormap(cmap);
%c = colorbar;
%c.Ticks = [phi_high];
%caxis([minPhi maxPhi])

xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');