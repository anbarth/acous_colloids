function plot_C_phi_V(stressTable, paramsVector)
%collapse_params;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); fxnType = 2;
%load("y_optimal_lsqnonlin_08_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%y_optimal = y_optimal_fmin_1; [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); fxnType = 2;
%load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04; [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
%load("y_fmin_09_12.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13);
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];
alpha = 0.25;

figure;
hold on;

cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 80]);
cbar.Ticks = [0,5,10,20,40,60,80];
xlim([0.15 0.75])
xline(phi0)
ylabel('C')
xlabel('\phi')

for jj=1:size(C,2)
    myC = C(:,jj);
    myPhi = phi_list+phi_fudge';
    voltage = volt_list(jj);


    myPhi = myPhi(myC ~= 0);
    myC = myC(myC~=0);

    myC = myC .* (phi0-myPhi).^alpha;

    myColor = cmap(round(1+255*voltage/80),:);
    plot(myPhi,myC,'-o','Color',myColor,'LineWidth',1.5);
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

