%collapse_params;
%load("y_optimal_05_08.mat")
load("y_optimal_05_10_constrained.mat")
%load("y_optimal_05_10_constrained_abs.mat")
[eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,9);
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
ylim([0 0.2])

for jj=1:size(C,2)
%for jj = 1:2
    myC = C(:,jj);
    voltage = volt_list(jj);
    myColor = cmap(round(1+255*voltage/100),:);
    plot(phi_list,myC,'-o','Color',myColor,'LineWidth',1);
end

figure;
hold on;

cmap = viridis(256);
colormap(cmap);

cbar = colorbar;
minPhi = min(phi_list);
maxPhi = max(phi_list);
clim([minPhi maxPhi]);
cbar.Ticks = phi_list;
ylim([0 0.2])

for ii=1:size(C,1)
    myC = C(ii,:);
    phi = phi_list(ii);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    plot(volt_list,myC,'-o','Color',myColor,'LineWidth',1);
end

