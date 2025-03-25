play_with_sigmastar_03_19;

makePlot = false;

V_data = [volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list];
sigmastar_data = [sigmastar_6,sigmastar_7,sigmastar_8,sigmastar_9,sigmastar_10,sigmastar_11,sigmastar_12,sigmastar_13];

sigmastar_avg = zeros(1,7);
sigmastar_std = zeros(1,7);
for jj=1:7
    volt = volt_list(jj);
    sigmastar_avg(jj)=mean(sigmastar_data(V_data==volt));
    sigmastar_std(jj)=std(sigmastar_data(V_data==volt));
end

% use average values for next step
sigmastar = sigmastar_avg;

y = [eta0, phi0, delta, A, width, sigmastar, D];
%show_F_vs_xc_x(dataTable,y,@modelHandpickedSigmastarV,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1:7,'ColorBy',1,'ShowInterpolatingFunction',false)




if makePlot
    figure; hold on;
    xlabel('V')
    ylabel('\sigma^*')
    minPhi = min(phi_list); maxPhi = max(phi_list); cmap = viridis(256); myColor = @(phi) cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    for my_phi_num = 6:13
        phi = phi_list(my_phi_num);
        mySigmastar = sigmastar_list_full(my_phi_num-5,:);
        myVoltList = volt_list(mySigmastar~=0);
        mySigmastar = mySigmastar(mySigmastar~=0);
        plot(myVoltList,mySigmastar,'o','Color',myColor(phi),'MarkerFaceColor',myColor(phi));
    end

    errorbar(volt_list,sigmastar_avg,sigmastar_std,'ok','MarkerFaceColor','k')
    
    % quadratic to guide the eye
    %pSigmastar = polyfit(V_data,sigmastar_data,2);
    %V = linspace(0,80);
    %plot(V,pSigmastar(1)*V.^2+pSigmastar(2)*V+pSigmastar(3),'--k','LineWidth',2);
end





