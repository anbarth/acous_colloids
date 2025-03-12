%optimize_logistic_C_02_18;
%y = y_lsq_smooth_0V;
%myModelHandle = @modelLogisticCExp0V;
%optimize_C_jardy_02_11;
y = y_lsq_0V; alpha = 0.02;
myModelHandle = @modelHandpickedAllExp0V;

dataTable = may_ceramic_09_17(may_ceramic_09_17(:,3)==0,:);

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y);
phi0 = y(2);

phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));

phiCmap = viridis(256);
myPhiColor = @(phi) phiCmap(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);

sigmaCmap = winter(256);
myStressColor = @(sig) phiCmap(round(1+255*(log(sig)-min(log(stress_list)))/(max(log(stress_list))-min(log(stress_list)))),:);

figure; hold on;

for ii=1:length(phi_list)
    phi = phi_list(ii);
    myDataIndices = dataTable(:,1)==phi;
    
    uf = x(myDataIndices)*(phi0-phi)^alpha;
    uphi = (phi0-phi)*ones(size(uf));

    uf = sort(uf);
    
    plot(uphi,uf,'-o','Color',myPhiColor(phi));

end

for kk=1:length(stress_list)
    sig = stress_list(kk);
    myDataIndices = dataTable(:,2)==sig;
    
    phi = dataTable(myDataIndices,1);
    uf = x(myDataIndices).*(phi0-phi).^alpha;
    uphi = phi0-phi;

    [uphi,sortIdx] = sort(uphi);
    uf = uf(sortIdx);
    
    plot(uphi,uf,'-o','Color','k');

end

