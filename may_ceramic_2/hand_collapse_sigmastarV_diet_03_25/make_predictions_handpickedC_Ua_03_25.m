build_smooth_sigmastar_Ua_03_25;

CSS = (50/19)^3;

y = y_smooth_restricted;
dataTable = may_ceramic_09_17;
myModelHandle = @modelHandpickedSigmastarV_CSV;

% collapse all data
%show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',1); xlim([1e-5 1.5])
%show_F_vs_xc_x(dataTable,y,myModelHandle,'ColorBy',1);

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
        mySigma = dataTable(myData,2)*CSS;
        myEta = eta(myData); % taken from output of model, so it already includes CSV
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
    xlim([0.5 1e4])
    ylim([5 2e4])
    xticks([1 1e2 1e4])
    yticks([1e1 1e4])
    myfig = gcf;
    myfig.Position=[50,50,287,323];
end