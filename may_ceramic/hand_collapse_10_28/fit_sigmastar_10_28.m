% pls pls pls run play_with_CV before this to populate y!!!
play_with_CV;

makePlot = false;

% plot sigmastar(V) for all volume fractions
if makePlot
    figure; hold on;
    xlabel('V')
    ylabel('\sigma^*')
end
minPhi = 0.17; maxPhi = 0.62; cmap = viridis(256); myColor = @(phi) cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
for my_phi_num = 6:13
    phi = phi_list(my_phi_num);
    mySigmastar = sigmastar_list(my_phi_num-5,:);
    myVoltList = volt_list(mySigmastar~=0);
    mySigmastar = mySigmastar(mySigmastar~=0);
    if makePlot
        plot(myVoltList,mySigmastar,'-o','Color',myColor(phi),'MarkerFaceColor',myColor(phi));
    end
end

% fit a quadratic
V_data = [volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list];
sigmastar_data = [sigmastar_6,sigmastar_7,sigmastar_8,sigmastar_9,sigmastar_10,sigmastar_11,sigmastar_12,sigmastar_13];
V_data = V_data(sigmastar_data~=0);
sigmastar_data = sigmastar_data(sigmastar_data~=0);
pSigmastar = polyfit(V_data,sigmastar_data,2);
V = linspace(0,80);
if makePlot
    plot(V,pSigmastar(1)*V.^2+pSigmastar(2)*V+pSigmastar(3),'-k','LineWidth',2);
end

sigmastar = (pSigmastar(1)*volt_list.^2+pSigmastar(2)*volt_list+pSigmastar(3))';
y = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);
%show_F_vs_x(dataTable,y,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1:7,'ColorBy',2,'ShowInterpolatingFunction',false)



