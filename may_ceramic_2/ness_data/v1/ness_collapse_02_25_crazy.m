load("ness_data_02_25.mat")
dataTable = ness_data_table;
dataBelowSJ = dataTable(dataTable(:,4)<1e6,:);

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


phi0 = 0.6482; % from ness_find_phi0_exclude_lower_phi

F = dataTable(:,4).*(phi0-dataTable(:,1)).^2;
eta0 = min(F)*0.9;

y_init = [eta0,phi0,-1];
myModelHandle = @modelNessCrazy;

show_F_vs_x(dataTable,y_init,myModelHandle,'ShowLines',true,'ColorBy',2,'PhiRange',10:-1:1)
%xlim([1e-4 2])
%show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowLines',true,'ColorBy',2,'PhiRange',10:-1:1)
%return

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = modelNessCrazy(dataTable, y_init);

figure; hold on;
cmap = viridis(256);
myColor = @(phi) cmap(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);
for ii=1:length(phi_list)
    phi = phi_list(ii);
    myData = dataTable(:,1)==phi;
    myX = x(myData);
    mySigma = dataTable(myData,2);
    plot(mySigma,myX,'o-','Color',myColor(phi),'LineWidth',1);
    
end
ax1=gca;
ax1.XScale='log';
xlabel('\sigma')
ylabel('x')



figure; hold on; makeAxesLogLog;
stress_list = dataTable(dataTable(:,1)==0.55,2);
cmap = winter(256);
myColor = @(stress) cmap(round(1+255*(log(stress)-log(min(stress_list)))/(log(max(stress_list))-log(min(stress_list)))),:);
L = {};
for kk=1:length(stress_list)
    stress = stress_list(kk);
    myData = dataTable(:,2)==stress;
    myX = x(myData);
    myPhi = dataTable(myData,1);
    plot(phi0-myPhi,myX,'o-','Color',myColor(stress),'LineWidth',1);
    L{end+1} = num2str(stress);

    if kk==1
        myPoints = phi0-myPhi < 0.05;
        p = polyfit(log(phi0-myPhi(myPoints)),log(myX(myPoints)),1);
        dphi = phi0-myPhi(myPoints);
        plot(dphi,0.99*exp(polyval(p,log(dphi))),'k-','LineWidth',1.5)
        disp(p(1))
        L{end+1}='fit';
    end
end
xlabel('\phi')
ylabel('x')
legend(L)
%xlim()