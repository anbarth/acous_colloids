build_smooth_parameters_03_25;

y = y_smooth_restricted;
dataTable = may_ceramic_09_17;
% TODO TODO TODO need to change this to a CSV model
myModelHandle = @modelLogisticCSigmastarV;

% collapse all data
show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',1); xlim([1e-5 1.5])
show_F_vs_xc_x(dataTable,y,myModelHandle,'ColorBy',1);

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y);

volt_list = [0 5 10 20 40 60 80];
phi_list = unique(dataTable(:,1));
cmap2 = viridis(256);
myColorPhi = @(phi) cmap2(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];
for jj=excluded_V_indices
    v = volt_list(jj);
    figure; hold on; makeAxesLogLog; xlabel('Shear stress \sigma (Pa)'); ylabel('Viscosity \eta (Pa s)');
    title(v)
    for ii=1:length(phi_list)
        phi = phi_list(ii);
        myData = dataTable(:,1)==phi & dataTable(:,3)==v;
        if isempty(myData)
            continue
        end
        mySigma = dataTable(myData,2)*19;
        myEta = eta(myData);
        myEtaErr = delta_eta(myData);
        myEtaHat = eta_hat(myData);

        [mySigma,sortIdx]=sort(mySigma);
        myEta=myEta(sortIdx);
        myEtaErr=myEtaErr(sortIdx);
        myEtaHat=myEtaHat(sortIdx);

        errorbar(mySigma,myEta,myEtaErr,my_vol_frac_markers(ii),'Color',myColorPhi(phi),'MarkerFaceColor',myColorPhi(phi))
        plot(mySigma,myEtaHat,'Color',myColorPhi(phi),'LineWidth',1)
        
        
    end
    prettyPlot;
    xlim([1 1e4])
end