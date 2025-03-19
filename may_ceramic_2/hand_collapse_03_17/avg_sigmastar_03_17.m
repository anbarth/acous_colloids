% pls pls pls run play_with_CV before this to populate y!!!
play_with_CV_03_17;

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
    %mySigmastar = sigmastar_list_full(my_phi_num-5,:);
    myVoltList = volt_list(mySigmastar~=0);
    mySigmastar = mySigmastar(mySigmastar~=0);
    if makePlot
        plot(myVoltList,mySigmastar,'o','Color',myColor(phi),'MarkerFaceColor',myColor(phi));
    end
end

volts_matrix = repmat(volt_list',8,1);
phi_matrix = repmat(phi_list(6:13),1,7);

V_data = volts_matrix(:);
sigmastar_data = sigmastar_list(:);
V_data = V_data(sigmastar_data~=0);
sigmastar_data = sigmastar_data(sigmastar_data~=0);

% plot averages
sigmastar_avg = zeros(1,7);
sigmastar_std = zeros(1,7);
for jj=1:7
    volt = volt_list(jj);
    sigmastar_avg(jj)=mean(sigmastar_data(V_data==volt));
    sigmastar_std(jj)=std(sigmastar_data(V_data==volt));
end
if makePlot
    errorbar(volt_list,sigmastar_avg,sigmastar_std,'ok','MarkerFaceColor','k')
end


% fit a quadratic to guide the eye
pSigmastar = polyfit(V_data,sigmastar_data,2);
V = linspace(0,80);
if makePlot
    plot(V,pSigmastar(1)*V.^2+pSigmastar(2)*V+pSigmastar(3),'--k','LineWidth',2);
end

% use average values for next step
sigmastar = sigmastar_avg;
sigmastar(isnan(sigmastar))=0;

y_handpicked_03_17 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
%show_F_vs_x(dataTable,y,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1:7,'ColorBy',2,'ShowInterpolatingFunction',false)



