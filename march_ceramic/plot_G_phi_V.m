collapse_params;
stressTable = march_data_table_05_02;
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80,100];

figure;
hold on;
cmap = plasma(256);
colormap(cmap);
cbar = colorbar;
clim([0 100]);
cbar.Ticks = [0,5,10,20,40,60,80,100];
xlabel('\phi')
ylabel('G')

for jj=size(G,2):-1:1
    myG = G(:,jj);
    voltage = volt_list(jj);
    myColor = cmap(round(1+255*voltage/100),:);
    plot(phi_list,myG,'-o','Color',myColor,'LineWidth',1);
end


%%%%%%%%%%%%%%%%%%

figure;
hold on;
cmap = viridis(256);
colormap(cmap);
cbar = colorbar;
minPhi = 0.1997;
maxPhi = 0.6;
clim([minPhi maxPhi]);
cbar.Ticks = phi_list;
xlabel('V')
ylabel('G')


for ii=size(G,1):-1:1
    myG = G(ii,:);
    phi = phi_list(ii);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    plot(volt_list,myG,'-o','Color',myColor,'LineWidth',1);
end