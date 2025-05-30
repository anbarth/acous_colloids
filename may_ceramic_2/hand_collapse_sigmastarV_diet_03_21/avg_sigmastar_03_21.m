play_with_sigmastar_03_21;

makePlot = false;
volt_list = [0 5 10 20 40 60 80];

%V_data = [volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list,volt_list];
%sigmastar_data = [sigmastar_6,sigmastar_7,sigmastar_8,sigmastar_9,sigmastar_10,sigmastar_11,sigmastar_12,sigmastar_13];

V_mat = repmat(volt_list,8,1);
%phi_mat = repmat(phi_list(6:13),1,7);

sigmastar_vec = sigmastar_list(:);
V_vec = V_mat(:);

% cut out zero entries
s = sigmastar_vec~=0;
sigmastar_vec = sigmastar_vec(s);
V_vec = V_vec(s);

sigmastar_avg = zeros(1,7);
sigmastar_std = zeros(1,7);
for jj=1:7
    volt = volt_list(jj);
    sigmastar_avg(jj)=mean(sigmastar_vec(V_vec==volt));
    sigmastar_std(jj)=std(sigmastar_vec(V_vec==volt));
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
        mySigmastar = sigmastar_list(my_phi_num-5,:);
        myVoltList = volt_list(mySigmastar~=0);
        mySigmastar = mySigmastar(mySigmastar~=0);
        plot(myVoltList,mySigmastar,'o','Color',myColor(phi),'MarkerFaceColor',myColor(phi));
    end

    s = sigmastar_avg~=0;
    errorbar(volt_list(s),sigmastar_avg(s),sigmastar_std(s),'ok','MarkerFaceColor','k')
    
    % quadratic to guide the eye
    %pSigmastar = polyfit(V_data,sigmastar_data,2);
    %V = linspace(0,80);
    %plot(V,pSigmastar(1)*V.^2+pSigmastar(2)*V+pSigmastar(3),'--k','LineWidth',2);
end





