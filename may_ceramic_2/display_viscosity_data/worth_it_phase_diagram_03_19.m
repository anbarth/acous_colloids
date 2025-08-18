%optimize_sigmastarV_03_19;
y = y_fmincon; 
%myModelHandle = @modelHandpickedSigmastarV;
myModelHandle = @modelSigmastarUa;

dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;


phi_list = unique(dataTable(:,1));

cmap_pos = orangey(256);
cmap_neg = purpley(256);
minLogE = -7.5;
maxLogE = 8.1;
colorPos = @(delta_E) cmap_pos(round(1+255*(log(delta_E)-minLogE)/(maxLogE-minLogE)),:);
colorNeg = @(delta_E) cmap_pos(round(1+255*(log(-1*delta_E)-minLogE)/(maxLogE-minLogE)),:);


for phiNum = 7
%for phiNum=6:13
    
    phi = phi_list(phiNum);
    markerCode = strcat('-',my_vol_frac_markers(phiNum));
    
    
    fig_eta = figure;
    ax_eta = axes('Parent', fig_eta);
    ax_eta.XLabel.String = 'Acoustic energy density{\it U_a} (Pa)';
    ax_eta.YLabel.String = 'rate (1/s)';
    ax_eta.Title.String = strcat("\phi=",num2str(phi));
    hold(ax_eta,'on');
    ylim([1e-3 1e1])

    colormap(ax_eta,viridis(256));
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
    
    rate_list = logspace(log10(min(all_rate_list)),log10(max(all_rate_list)),22);
    v_list = logspace(log10(5),log10(80),20);

    ua_list = acoustic_energy_density(v_list);
    delta_sigma_mat = zeros(length(rate_list),length(v_list));
    for ii = 1:length(rate_list)
        rate = rate_list(ii);
        sigma0V = CSS*sigma_predicted(rate,phi,0,dataTable,y,myModelHandle);

        for jj = 1:length(v_list)
            v = v_list(jj);
            sigma = CSS*sigma_predicted(rate,phi,v,dataTable,y,myModelHandle);
            delta_sigma_mat(ii,jj) = sigma0V-sigma;
        end
    end
    markerSize=100;
    [ua_mat,rate_mat] = meshgrid(ua_list,rate_list);
    scatter(ua_mat(:),rate_mat(:),markerSize,log(abs(delta_sigma_mat(:)-ua_mat(:))),"filled",'s')
    neg_data = delta_sigma_mat(:)-ua_mat(:) < 0;
    scatter(ua_mat(neg_data),rate_mat(neg_data),markerSize,"filled",'sk')

    %pos_data = delta_sigma_mat(:)-ua_mat(:) > 0;
    %neg_data = delta_sigma_mat(:)-ua_mat(:) < 0;
    %deltaE = delta_sigma_mat(:)-ua_mat(:);
    %scatter(ua_mat(pos_data),rate_mat(pos_data),[],colorPos(deltaE(pos_data)),'filled','s');
    %scatter(ua_mat(neg_data),rate_mat(neg_data),[],colorNeg(deltaE(neg_data)),'filled','s');

    c1 = colorbar;
    minDeltaE = min(log(abs(delta_sigma_mat(:)-ua_mat(:))));
    maxDeltaE = max(log(abs(delta_sigma_mat(:)-ua_mat(:))));
    myticks = linspace(minDeltaE,maxDeltaE,4);
    c1.Ticks = myticks;
    c1.TickLabels = num2cell(round(exp(myticks)*100)/100);
end
