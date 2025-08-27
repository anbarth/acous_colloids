optimize_sigmastarV_03_19;
y = y_fmincon; 
myModelHandle = @modelHandpickedSigmastarV;
%myModelHandle = @modelSigmastarUa;

dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;

c = 2000;
A = pi*(19/2*1e-3)^2;
h = 0.211e-3;

phi_list = unique(dataTable(:,1));
for phiNum = [7,12]
%for phiNum=6:13
    L = {};
    phi = phi_list(phiNum);
    markerCode = strcat('-',my_vol_frac_markers(phiNum));

    % set up figure
    fig_eta = figure;
    ax_eta = axes('Parent', fig_eta);
    ax_eta.XLabel.String = 'Acoustic power P_{acous} (W)';
    ax_eta.YLabel.String = '\Delta P_{stress} (W)';
    ax_eta.Title.String = strcat("\phi=",num2str(phi));
    hold(ax_eta,'on');
    cmap = jet(256);
    colormap(ax_eta,cmap);
    xlim([0.044905934284051,44.90593428405083])
    xticks([10^-1 10^0 10^1])
    %if phiNum<13
        %ylim([1e-3 1e4])
        %yticks([1e-2 1e0 1e2 1e4])
    %end
    
    % pick out data
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)>0, :);
    myData0V = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    
    rate_list = myData(:,2)./myData(:,4);
    minLogRate = log(min(rate_list));
    maxLogRate = log(max(rate_list));
    %maxLogRate = 0.5;

    for ii=1:size(myData,1)
        % get data from this row
        phi = myData(ii,1);
        sigma = CSS*myData(ii,2);
        V = myData(ii,3);
        eta = CSS*myData(ii,4);
        rate = sigma/eta;
        
        % predict sigma0V
        sigma0V = CSS*sigma_predicted(rate,phi,0,dataTable,y,myModelHandle);
    
        myColor = cmap(round(1+255*(log(rate)-minLogRate)/(maxLogRate-minLogRate)),:);
    
        deltaEta = max(CSS*myData(ii,5),eta*0.15);
        delta_phi = 0.02;
        delta_eta_volumefraction = eta*2*(0.7-phi)^(-1)*delta_phi;
        delta_eta_total = sqrt(deltaEta.^2+delta_eta_volumefraction.^2);
    
        delta_rate = rate * delta_eta_total/eta;
        
        %plot(ax_eta,acoustic_energy_density(V),sigma0V-sigma, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
        plot(ax_eta,acoustic_energy_density(V)*c*A,rate*(sigma0V-sigma)*A*h/2, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    
    end
        
    xfake = logspace(-2,2);
    plot(xfake,xfake,'k--');

    c1 = colorbar(ax_eta);
    clim(ax_eta,[minLogRate maxLogRate]);
    myticks = linspace(minLogRate,maxLogRate,5);
    c1.Ticks = myticks;
    c1.TickLabels = num2cell(round(exp(myticks)*100)/100);
    %legend(L)
    
    
    
    
    prettyPlot;
    myfig = gcf;
    myfig.Position=[457,250,414,343];
    
    ax1=gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';
    


end
