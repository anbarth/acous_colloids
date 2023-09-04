phis = [44,46,48,50,52,53,54,55];
for ii = 1:length(phis)
    matFileName = strcat('phi_0',num2str(phis(ii)),'.mat');
    load(matFileName);
end
data_by_vol_frac = {phi_044,phi_046,phi_048,phi_050,phi_052,phi_053,phi_054,phi_055};
vol_frac_markers = ['^','v','s','d','p','h','o','*'];


figure; hold on;
cmap = viridis(256);
colormap(cmap);

ax1 = gca;
%ax1.XScale = 'log';
ax1.YScale = 'log';

%for ii = 1:length(data_by_vol_frac)
for ii = 5
    
   
    phi = phis(ii)/100;
    phi_data = data_by_vol_frac{ii};
    sigma = stress_list(1:size(phi_data,2));
    
    for jj = 2:length(sigma)

        myStress = sigma(jj);
        myColor = cmap(round(1+255*(log(myStress)-log(sigma(2)))/(log(sigma(end))-log(sigma(2)))),:);

        eta = phi_data(:,jj); % viscosities for just this stress

        myMarker = vol_frac_markers(ii);
        plot(volt_list,eta,'-o','Color',myColor,'MarkerEdgeColor',myColor,...
            'MarkerFaceColor',myColor,'LineWidth',1);
        %scat.MarkerFaceAlpha = .7;
        
    end
    xlabel('V')
    ylabel('\eta')
    xticks([0 5 10 20 40 60 80 100]);
    %legend(string((sigma(2:end))))
    %xlabel('1/x-1/x_c')
    %ylabel('H')
    %title(strcat('\phi=',num2str(phi),', all voltages'));
    %saveas(gcf,strcat('\phi_',phis(ii),'_all_voltages.fig'));
    %

end
%legend('44%','46%','48%','50%','52%','53%','54%','55%');

cbh = colorbar ; %Create Colorbar
%cbh.Ticks = log(sigma(2:end)); 
%cbh.TickLabels = sigma(2:end);
cbh.Ticks = linspace(log(5),log(700),3);
cbh.TickLabels = exp(linspace(log(5),log(700),3));
caxis([log(sigma(2)) log(sigma(end))]);
%xWC = f(sigma) ./ (-1*phi + phi0);
