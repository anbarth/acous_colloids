%optimize_sigmastarV_03_19;

CSS = (50/19)^3;

y = y_fmincon;
dataTable = may_ceramic_09_17;
myModelHandle = @modelHandpickedSigmastarV;

minSigma = min(unique(dataTable(:,2)));
maxSigma = max(unique(dataTable(:,2)));

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y);

volt_list = [0 5 10 20 40 60 80];
phi_list = unique(dataTable(:,1));
cmap2 = viridis(256);
myColorPhi = @(phi) cmap2(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];
for jj=1:length(volt_list)
    v = volt_list(jj);
    figure; hold on; makeAxesLogLog; ylabel('Shear stress \sigma (Pa)'); xlabel('Shear rate (1/s)');
    title(v)
    for ii=1:length(phi_list)
        phi = phi_list(ii);
        myData = dataTable(:,1)==phi & dataTable(:,3)==v;
        if sum(myData)==0
            continue
        end
        mySigma = dataTable(myData,2)*CSS;
        myEta = eta(myData)*CSS; 
        myEtaErr = delta_eta(myData)*CSS;

        [mySigma,sortIdx]=sort(mySigma);
        myEta=myEta(sortIdx);
        myEtaErr=myEtaErr(sortIdx);

        myRate = mySigma./myEta;
        myRateErr = myRate.*myEtaErr./myEta;
        
        % plot data
        errorbar(myRate,mySigma,myRateErr,"horizontal",my_vol_frac_markers(ii),'Color',myColorPhi(phi),'MarkerFaceColor',myColorPhi(phi))

        % plot predictions
        %sigma_fake=logspace(log10(minSigma),log10(maxSigma))';
        sigma_fake=1/CSS*logspace(-3,4.5)';
        myEtaHat = viscosity_prediction(phi,sigma_fake,v,dataTable,y,myModelHandle);

        sigma_fake=sigma_fake*CSS;
        myEtaHat=myEtaHat*CSS;
        plot(sigma_fake./myEtaHat,sigma_fake,'Color',myColorPhi(phi),'LineWidth',1)
        
        
    end
    prettyPlot;

    

    if v==0
        xlim([1e-5 1e2])
        ylim([1e-2 1e4])
        xticks([1e-4 1e-2 1e0 1e2])
        yticks([1e-2 1e0 1e2 1e4])
    else
        xlim([1e-3 1e2])
        ylim([1e-1 1e4])
        xticks([1e-2 1e0 1e2])
        yticks([1e0 1e2 1e4])
    end

    myfig = gcf;
    myfig.Position=[416,213,346,390];
end