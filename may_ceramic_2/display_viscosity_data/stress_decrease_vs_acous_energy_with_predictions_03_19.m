%optimize_sigmastarV_03_19;
y = y_fmincon; 
myModelHandle = @modelHandpickedSigmastarV;
%myModelHandle = @modelSigmastarUa;

dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;


phi_list = unique(dataTable(:,1));
for phiNum = 10
%for phiNum=6:13
    L = {};
    phi = phi_list(phiNum);
    markerCode = strcat('-',my_vol_frac_markers(phiNum));
    
    
    fig_eta = figure;
    ax_eta = axes('Parent', fig_eta);
    ax_eta.XLabel.String = 'Acoustic energy density{\it U_a} (Pa)';
    ax_eta.YLabel.String = '\sigma+U_a (Pa)';
    ax_eta.Title.String = strcat("\phi=",num2str(phi));
    hold(ax_eta,'on');
    cmap = winter(256);
    colormap(ax_eta,cmap);
    

    %myData = dataTable(dataTable(:,1)==phi , :);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)>0, :);
    myData0V = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    
    rate_list = myData0V(:,2)./myData0V(:,4);
    minLogRate = log(min(rate_list));
    maxLogRate = log(max(rate_list));
    
    
    for rate = logspace(log10(min(rate_list)),log10(max(rate_list)),8)

        sigma0V = CSS*sigma_predicted(rate,phi,0,dataTable,y,myModelHandle);

        myColor = cmap(round(1+255*(log(rate)-minLogRate)/(maxLogRate-minLogRate)),:);
        v_list = [5 10 20 40 60 80];
        sigma_list = zeros(size(v_list));
        for kk = 1:length(v_list)
            v = v_list(kk);
            sigma_list(kk) = CSS*sigma_predicted(rate,phi,v,dataTable,y,myModelHandle);
        end
        plot(acoustic_energy_density(v_list),sigma_list+acoustic_energy_density(v_list),'Color',myColor)
        %yline(sigma0V,'Color',myColor)
        L{end+1} = num2str(rate);
    end
    
    %xfake = logspace(-1,1.4);
    %plot(xfake,xfake,'k--');

    c1 = colorbar(ax_eta);
    clim(ax_eta,[minLogRate maxLogRate]);
    legend(L)
    
    
    
    
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
