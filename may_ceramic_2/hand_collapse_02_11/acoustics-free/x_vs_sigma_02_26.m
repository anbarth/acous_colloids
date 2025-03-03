%optimize_C_jardy_02_11;

dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);
y = y_lsq_0V;

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpickedAllExp0V(dataTable, y);

figure; hold on;
cmap = viridis(256);
myColor = @(phi) cmap(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);
for ii=1:length(phi_list)
    phi = phi_list(ii);
    myData = dataTable(:,1)==phi;
    myX = x(myData);
    mySigma = dataTable(myData,2);
    [mySigma,sortIdx] = sort(mySigma);
    myX = myX(sortIdx);
    plot(mySigma,myX,'o-','Color',myColor(phi),'LineWidth',1);
    
end
ax1=gca;
ax1.XScale='log';
xlabel('\sigma')
ylabel('x')