%collapse_params;
%load("y_optimal_06_15.mat"); [eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,11); phi_fudge = zeros(1,11);
load("y_optimal_fudge_06_17.mat"); [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,11);
stressTable = may_ceramic_06_06;
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];

figure;
hold on;

cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 80]);
cbar.Ticks = [0,5,10,20,40,60,80];
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

    myColor = cmap(round(1+255*voltage/80),:);
    plot(myPhi,myC,'-o','Color',myColor,'LineWidth',1);
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

