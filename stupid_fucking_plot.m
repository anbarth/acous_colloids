cmap = viridis(256); 
figure; hold on;
colormap(cmap);
%return
for ii=1:8
    voltage = volt_list(ii);
    myColor = cmap(round(1+255*voltage/100),:);
    plot(phi_list,C(ii,:),'-o','Color',myColor,'MarkerFaceColor',myColor);
end

c1 = colorbar;
caxis([0 100]);
c1.Ticks = [0,5,10,20,40,60,80,100];