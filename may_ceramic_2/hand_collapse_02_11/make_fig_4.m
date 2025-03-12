%smooth_C_03_11

show_F_vs_x(data_table,y_logistic,@modelLogisticCV_CSV)
prettyPlot;

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelLogisticCV_CSV(data_table, y_logistic);


volt_list = [0 5 10 20 40 60 80];
phi_list = unique(data_table(:,1));
cmap2 = viridis(256);
myColorPhi = @(phi) cmap2(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];
for jj=5:7
    v = volt_list(jj);
    figure; hold on; makeAxesLogLog; xlabel('\sigma'); ylabel('\eta');
    title(v)
    for ii=1:length(phi_list)
        phi = phi_list(ii);
        myData = data_table(:,1)==phi & data_table(:,3)==v;
        if isempty(myData)
            continue
        end
        mySigma = data_table(myData,2);
        myEta = eta(myData);
        myEtaErr = delta_eta(myData);
        myEtaHat = eta_hat(myData);

        [mySigma,sortIdx]=sort(mySigma);
        myEta=myEta(sortIdx);
        myEtaErr=myEtaErr(sortIdx);
        myEtaHat=myEtaHat(sortIdx);

        errorbar(mySigma,myEta,myEtaErr,my_vol_frac_markers(ii),'Color',myColorPhi(phi),'MarkerFaceColor',myColorPhi(phi))
        plot(mySigma,myEtaHat,'Color',myColorPhi(phi))
        
        
    end
    prettyPlot;
end