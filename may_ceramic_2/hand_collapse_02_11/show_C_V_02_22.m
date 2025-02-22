load("optimized_params_02_11.mat");
y_optimal = y_fminsearch;
alpha = 0.0174; % from determine_CIs_on_D0V

get_confints_02_22;

volt_list = [0,5,10,20,40,60,80];
phi_list = unique(may_ceramic_09_17(:,1));

figure; hold on;
%ax1=gca; ax1.XScale='log'; ax1.YScale='log';

cmap = plasma(256);
colormap(cmap);

cbar = colorbar;
clim([0 80]);
cbar.Ticks = [0,5,10,20,40,60,80];
ylabel('C')
xlabel('\phi')

for jj=1:size(D,2)
    %if jj>1; continue; end
    myD = D(:,jj);
    myD_err = D_err(:,jj);
    myPhi = phi_list;
    voltage = volt_list(jj);

    myD_err = myD_err(myD~=0);
    myPhi = myPhi(myD~=0);
    myD = myD(myD~=0);

    myC = myD .* (phi0-myPhi).^alpha;
    myC_err=myD_err;

    myColor = cmap(round(1+255*voltage/80),:);
    errorbar(myPhi,myC,myC_err,'-o','Color',myColor,'LineWidth',1.5,'MarkerFaceColor',myColor);
    %plot(phi0-myPhi,myC,'-o','Color',myColor,'LineWidth',1);
end
prettyPlot;