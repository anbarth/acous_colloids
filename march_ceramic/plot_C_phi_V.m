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


for jj=1:size(G,2)
%for jj = 1:2
    myC = C'.*G(:,jj);
    voltage = volt_list(jj);
    myColor = cmap(round(1+255*voltage/100),:);
    plot(phi_list,myC,'-o','Color',myColor,'LineWidth',1);
end