%collapse_params;
load("y_optimal_08_13.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,8);

stressTable = pranav_data_table;
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80,100];

figure;
hold on;

cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 100]);
cbar.Ticks = [0,5,10,20,40,60,80,100];
%ylim([0 0.2])
xlim([phi_list(1) 0.6])
xline(phi0)
ylabel('C')
xlabel('\phi')

for jj=1:size(C,2)
    myC = C(:,jj);
    myPhi = phi_list+phi_fudge';
    voltage = volt_list(jj);

    myPhi = myPhi(myC ~= 0);
    myC = myC(myC~=0);

    myC = myC .* (phi0-myPhi).^1;

    myColor = cmap(round(1+255*voltage/100),:);
    plot(myPhi,myC,'-o','Color',myColor,'LineWidth',1.5);
end

% for jj=1:size(C2,2)
%     myC = C2(:,jj);
%     myPhi = phi_list;
%     voltage = volt_list(jj);
% 
%     myPhi = myPhi(myC ~= 0);
%     myC = myC(myC~=0);
% 
%     %myC = myC .* (phi0-myPhi).^1;
% 
%     myColor = cmap(round(1+255*voltage/80),:);
%     plot(myPhi,myC,'--o','Color',myColor,'LineWidth',1);
% end

return
figure;
hold on;

cmap = viridis(256);
colormap(cmap);

cbar = colorbar;
minPhi = min(phi_list);
maxPhi = max(phi_list);
clim([minPhi maxPhi]);
cbar.Ticks = phi_list;
%ylim([0 0.2])
ylabel('C')
xlabel('V')

for ii=1:size(C,1)
    if ii==6
        continue
    end
    myC = C(ii,:);
    phi = phi_list(ii);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

    myVolt = volt_list(myC ~= 0);
    myC = myC(myC ~= 0);

    plot(myVolt,myC,'-o','Color',myColor,'LineWidth',1);
end

