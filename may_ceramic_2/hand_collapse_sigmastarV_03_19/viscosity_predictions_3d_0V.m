%optimize_C_jardy_03_19;
optimize_C_powerlaw_03_19;

y = y_lsq_0V;
%myModelHandle = @modelHandpickedAllExp0V;
myModelHandle = @modelHandpickedAllExpPowerLawF0V;
dataTable = may_ceramic_09_17(may_ceramic_09_17(:,3)==0,:);

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y);
phi = dataTable(:,1);
sigma = dataTable(:,2);

figure; hold on;
xlabel('log \sigma')
ylabel('\phi')
zlabel('\eta')
plot3(log(sigma),phi,log(eta),'bo')
plot3(log(sigma),phi,log(eta_hat),'ro')
