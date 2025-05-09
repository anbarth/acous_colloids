data_table = may_ceramic_09_17;


% load up desired parameters
load("optimized_params_02_11.mat")
paramsVector = y_fminsearch; myModelHandle=@modelHandpickedAllExp;
[x_all,F_all,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(data_table, paramsVector);
phi0=paramsVector(2);


% set up plot stuff
figure; hold on;
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma')
Fmin = min(F_all);
Fmax = max(F_all);
cmap = plasma(256);
colormap(cmap)
myColor = @(F) cmap(round(1+255*(log(F)-log(Fmin))/(log(Fmax)-log(Fmin))),:);
volt_list = [0 5 10 20 40 60 80];

% pick two voltages
lowVoltNum=1;
highVoltNum=7;
V_low = volt_list(lowVoltNum);
V_high = volt_list(highVoltNum);


% show zero-volt viscosity as heatmap
volt_for_eta = 0;
for kk=1:size(data_table,1)
    V = data_table(kk,3);
    if V ~= volt_for_eta
        continue
    end
    phi = data_table(kk,1);
    sigma = data_table(kk,2);
    eta = data_table(kk,4);
    F = eta*(phi0-phi)^2;
    scatter(phi,sigma,500,myColor(F),'filled','s');
end

% overlay lines of constant x
for x =  [10.^(-4:-1) 0.2 0.4 0.6 0.8 1 1-[0.046 0.1 0.15 0.22 0.32 0.46]]
%for x = 1-[0.022 0.046 0.1 0.22 0.46 1]
%for x =  [10.^(-4:0) 1-[0.046 0.1 0.15 0.22 0.32 0.46]]
   [myPhi1,mySigma1] = handpickedAllConstantX(data_table,x,lowVoltNum,paramsVector);
   [myPhi2,mySigma2] = handpickedAllConstantX(data_table,x,highVoltNum,paramsVector);
   plot(myPhi1,mySigma1,'k-s','LineWidth',1.5)
   plot(myPhi2,mySigma2,'r-s','LineWidth',1.5)
end
colorbar;

xlim([0.4 0.65])
ylim([1e-2 10^(2.5)])