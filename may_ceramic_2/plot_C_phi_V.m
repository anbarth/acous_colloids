function plot_C_phi_V(stressTable, paramsVector)
%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); fxnType = 2;
%load("y_optimal_lsqnonlin_08_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%y_optimal = y_optimal_fmin_1; [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); fxnType = 2;
%load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04; [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
%load("y_fmin_09_12.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 

[eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParamsHandpickedAll(paramsVector,13);
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];
alpha = 0;

figure; hold on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';

cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 80]);
cbar.Ticks = [0,5,10,20,40,60,80];
%xlim([0.15 0.65])
%xline(phi0)
ylabel('D')
xlabel('\phi_0-\phi')

for jj=1:size(D,2)
    %if jj>1; continue; end
    myC = D(:,jj);
    myPhi = phi_list+phi_fudge';
    voltage = volt_list(jj);


    myPhi = myPhi(myC ~= 0);
    myC = myC(myC~=0);

    myC = myC .* (phi0-myPhi).^alpha;

    myColor = cmap(round(1+255*voltage/80),:);
    %plot(myPhi,myC,'-o','Color',myColor,'LineWidth',1.5);
    plot(phi0-myPhi,myC,'-o','Color',myColor,'LineWidth',1);
end

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

for ii=1:size(D,1)
    if ii==6
        continue
    end
    myC = D(ii,:);
    phi = phi_list(ii);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

    myVolt = volt_list(myC ~= 0);
    myC = myC(myC ~= 0);

    plot(myVolt,myC,'-o','Color',myColor,'LineWidth',1);
end

