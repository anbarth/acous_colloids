my_data = ceramic_data_table_02_21_b;

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';

phi_high = [.3, .40,.48];
minPhi = .3;
maxPhi = .5;
%cmap = flipud(viridis(256)); 
cmap = turbo;

for ii=1:length(phi_high)
    phi = phi_high(ii);
    myData = my_data(my_data(:,1)==phi & my_data(:,3)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    
    plot(sigma,eta, '-d','Color',myColor);
end



%colormap(cmap);
%c = colorbar;
%c.Ticks = [phi_high];
%caxis([minPhi maxPhi])

xlabel('\sigma (Pa)');
ylabel('\eta (Pa s)');