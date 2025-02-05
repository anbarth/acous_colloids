dataTable = may_ceramic_09_17;

figure; hold on;
ax1 = gca;
ax1.YScale = 'log';
ax1.XLabel.String = '\phi';
ax1.YLabel.String = '\sigma';



dataTable = may_ceramic_09_17;
load("01_12_optimal_params.mat")
myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
[x_all,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, paramsVector);


minx = min(x_all);
maxx = 1;
cmap = viridis(256); 
myColor = @(x) cmap(round(1+255*(log(x)-log(minx))/(log(maxx)-log(minx))),:);

for ii = 1:length(dataTable)
    if dataTable(ii,3) ~= 0
        continue
    end

    phi = dataTable(ii,1);
    sigma = dataTable(ii,2);
    x = x_all(ii);
    
    scatter(phi,sigma,[],myColor(x),'filled','o');
end

colorbar;
clim([log(minx) log(maxx)])

x_show = [x_crossover];

Csmooth = @(p,a,b) 1./(1+((phi0-p)/a).^b);
myA = 0.32;
myB = 6.5;
for ii=1:length(x_show)
    thisX = x_show(ii);
    phi_fake = linspace(0.2,0.61);
    sigma_fake = sigmastar(1) ./ log(1/thisX * Csmooth(phi_fake,myA,myB));
    plot(phi_fake,sigma_fake,'-','Color',myColor(thisX),'LineWidth',1);
end