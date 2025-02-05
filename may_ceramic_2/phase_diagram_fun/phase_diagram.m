data_table = may_ceramic_09_17;

figure; hold on;
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma')


load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

% edit alpha
paramsVector(9)=0.5;

%play_with_CV_2_10_28;
%myModelHandle = @modelHandpickedAll; paramsVector = y_handpicked_10_28;

%paramsVector(21) = 0.2; % for phi=50%, was 0.83

[x_all,F_all,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(data_table, paramsVector);

phi0=paramsVector(2);



Fmin = min(F_all);
Fmax = max(F_all);

cmap = plasma(256);
colormap(cmap)
myColor = @(F) cmap(round(1+255*(log(F)-log(Fmin))/(log(Fmax)-log(Fmin))),:);


voltNum=7;

volt_list = [0 5 10 20 40 60 80];
volt_to_plot = volt_list(voltNum);
for kk=1:size(data_table,1)
    V = data_table(kk,3);
    if V ~= volt_to_plot
        continue
    end
    phi = data_table(kk,1);
    sigma = data_table(kk,2);
    eta = data_table(kk,4);
    F = eta*(phi0-phi)^2;
    scatter(phi,sigma,500,myColor(F),'filled','s');
end


%for x = 1-[0.022 0.046 0.1 0.22 0.46 1]
for x =  [10.^(-4:0) 1-[0.046 0.1 0.15 0.22 0.32 0.46]]
%for x = [1 0.56 0.32 0.18 0.1 0.01]
   [myPhi,mySigma] = smoothFunctionsConstantX(x,voltNum,paramsVector);
   %[myPhi,mySigma] = handpickedAllConstantX(data_table,x,voltNum,paramsVector);
   plot(myPhi,mySigma,'k-','LineWidth',1.5)
end
colorbar;

% WC prediction for the phase boundary
[eta0,sigmastar,phimu,phi0WC] = wyart_cates(data_table);
myPhi = [linspace(phimu,phi0WC-0.011) phi0WC-logspace(-2,-4)];
Q = @(p) (phi0WC-p)/(phi0WC-phimu);
%plot(myPhi,sigmastar*(Q(myPhi)./(1-Q(myPhi))),'-r')
for x = [1 0.56 0.32 0.18 0.1 0.01]
   [myPhi,mySigma] = wyartCatesConstantX(x,sigmastar,phimu,phi0WC);
   %plot(myPhi,mySigma,'k-','LineWidth',1.5)
end

xlim([0.4 0.65])
ylim([1e-2 10^(2.5)])