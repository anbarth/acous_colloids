%optimize_sigmastarV_03_19;
y = y_fmincon; myModelHandle = @modelHandpickedSigmastarV;

dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;


phi_list = unique(dataTable(:,1));
for phiNum = 13
%for phiNum=6:13
    
    phi = phi_list(phiNum);
    markerCode = strcat('-',my_vol_frac_markers(phiNum));
    
    
    fig_eta = figure;
    ax_eta = axes('Parent', fig_eta);
    ax_eta.XLabel.String = 'Acoustic energy density{\it U_a} (Pa)';
    ax_eta.YLabel.String = 'rate (1/s)';
    ax_eta.Title.String = strcat("\phi=",num2str(phi));
    hold(ax_eta,'on');
    cmap = winter(256);
    colormap(ax_eta,cmap);
    prettyPlot;
    myfig = gcf;
    myfig.Position=[457,250,414,343];
    
    ax1=gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';
    

    %myData = dataTable(dataTable(:,1)==phi , :);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)>0, :);
    myData0V = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    
    all_rate_list = myData0V(:,2)./myData0V(:,4);
    minLogRate = log(min(all_rate_list));
    maxLogRate = log(max(all_rate_list));
    
    rate_list = logspace(log10(min(all_rate_list)),log10(max(all_rate_list)),8);
    v_list = [5 10 20 40 60 80]; 
    ua_list = acoustic_energy_density(v_list);
    delta_sigma_mat = zeros(length(rate_list),length(v_list));
    for ii = 1:length(rate_list)
        rate = rate_list(ii);
        solveMe =  @(logsigma) exp(logsigma)/viscosity_prediction(phi,exp(logsigma),0,dataTable,y,myModelHandle)-rate;
        sigma0V = CSS*exp(fzero(solveMe,1.5));

        for jj = 1:length(v_list)
            v = v_list(jj);
            solveMe =  @(logsigma) exp(logsigma)/viscosity_prediction(phi,exp(logsigma),v,dataTable,y,myModelHandle)-rate;
            sigma = CSS*exp(fzero(solveMe,1.5));
            delta_sigma_mat(ii,jj) = sigma0V-sigma;
        end
    end
    [ua_mat,rate_mat] = meshgrid(ua_list,rate_list);
    scatter(ua_mat(:),rate_mat(:),[],delta_sigma_mat(:)-ua_mat(:),"filled",'s')
    

end
