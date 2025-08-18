optimize_sigmastarV_03_19;
y = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;

dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;


phi_list = unique(dataTable(:,1));
for phiNum = 10
%for phiNum=6:13
    
    phi = phi_list(phiNum);
    markerCode = strcat('-',my_vol_frac_markers(phiNum));
    
    
    fig_eta = figure;
    ax_eta = axes('Parent', fig_eta);
    ax_eta.XLabel.String = 'Acoustic energy density{\it U_a} (Pa)';
    ax_eta.YLabel.String = 'Shear stress \sigma (Pa)';
    ax_eta.Title.String = strcat("\phi=",num2str(phi));
    hold(ax_eta,'on');
    cmap = winter(256);
    colormap(ax_eta,cmap);
    

    %myData = dataTable(dataTable(:,1)==phi , :);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)>0, :);
    sigma_list = CSS*myData(:,2);
    eta_list = CSS*myData(:,4);
    rate_list = sigma_list./eta_list;
    minLogRate = log(min(rate_list));
    maxLogRate = log(max(rate_list));
    

    for ii=1:size(myData,1)
    
        phi = myData(ii,1);
        sigma = CSS*myData(ii,2);
        V = myData(ii,3);
        eta = CSS*myData(ii,4);
        rate = sigma/eta;
    
        myColor = cmap(round(1+255*(log(rate)-minLogRate)/(maxLogRate-minLogRate)),:);
    
        deltaEta = max(CSS*myData(ii,5),eta*0.15);
        delta_phi = 0.02;
        delta_eta_volumefraction = eta*2*(0.7-phi)^(-1)*delta_phi;
        delta_eta_total = sqrt(deltaEta.^2+delta_eta_volumefraction.^2);
    
        delta_rate = rate * delta_eta_total/eta;
        
    
        plot(ax_eta,acoustic_energy_density(V),sigma, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    
    end
    
    for rate = logspace(log10(min(rate_list)),log10(max(rate_list)),5)
        myColor = cmap(round(1+255*(log(rate)-minLogRate)/(maxLogRate-minLogRate)),:);
        v_list = [0 5 10 20 40 60 80];
        sigma_list = zeros(size(v_list));
        for kk = 1:length(v_list)
            v = v_list(kk);
            solveMe =  @(logsigma) exp(logsigma)/viscosity_prediction(phi,exp(logsigma),v,dataTable,y,myModelHandle)-rate;
            sigma_list(kk) = exp(fzero(solveMe,1.5));
        end
        plot(acoustic_energy_density(v_list),sigma_list*CSS,'Color',myColor)
    end
    
    
    c1 = colorbar(ax_eta);
    clim(ax_eta,[minLogRate maxLogRate]);
    %legend(L)
    
    
    
    
    prettyPlot;
    myfig = gcf;
    myfig.Position=[457,250,414,343];
    
    ax1=gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';
    
    %yticks([10 100]);
    %xlim([0.05 50])
    %xticks([10^-1 10^0 10^1])
    %ylim([9 165])
    
    %title(phi)

end
