% pls pls pls run play_with_CV before this to populate y!!!
play_with_CV_lsq_02_11;

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
        plot(myVoltList,mySigmastar,'o','Color',myColor(phi),'MarkerFaceColor',myColor(phi));
    end
end


V_data = [volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list];
sigmastar_data = [sigmastar_6,sigmastar_7,sigmastar_8,sigmastar_9,sigmastar_10,sigmastar_11,sigmastar_12,sigmastar_13];
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

% use quadratic values for next step?
%sigmastar = (pSigmastar(1)*volt_list.^2+pSigmastar(2)*volt_list+pSigmastar(3))';
% use average values for next step?
sigmastar = sigmastar_avg;

y = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
%show_F_vs_x(dataTable,y,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1:7,'ColorBy',2,'ShowInterpolatingFunction',false)



