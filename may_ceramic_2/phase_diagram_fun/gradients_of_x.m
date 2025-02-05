data_table = may_ceramic_09_17;

figure; hold on;
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma')


load("01_12_optimal_params.mat")
%myModelHandle = @modelHandpickedAll; paramsVector = y_full_fmin_lsq;
myModelHandle = @modelSmoothFunctions; paramsVector = y_smooth_fmin_lsq;

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
    scatter(phi,sigma,100,myColor(F),'filled');
end

% plot gradient of x
myXfun = @(p) smoothFunctionX(p(1),p(2),volt_to_plot,paramsVector);
for kk=1:size(data_table,1)
    V = data_table(kk,3);
    if V ~= volt_to_plot
        continue
    end
    phi = data_table(kk,1);
    sigma = data_table(kk,2);
    
    gradX = myGradient(myXfun,[phi,sigma]);
    quiver(phi,sigma,gradX(1),gradX(2),0.005,'Color',[0 0 0],'LineWidth',3)
end

%for x = 1-[0.022 0.046 0.1 0.22 0.46 1]
for x = 10.^(-1:0.1:0) 
%for x = [0.56 0.57 0.58]
%for x =  [10.^(-4:0) 1-[0.022 0.046 0.1 0.22 0.46]]
%for x = [1 0.56 0.32 0.18 0.1 0.01]
%for x = 1/0.0797
   [myPhi,mySigma] = smoothFunctionsConstantX(x,voltNum,paramsVector);
   plot(myPhi,mySigma,'k-','LineWidth',1.5)
end
colorbar;

%xline(0.6106+0.01)
%xline(0.6106-0.01)
%yline(0.5+0.01)
%yline(0.5-0.01)

xlim([0.1 0.7])
ylim([1e-3 1e3])
%xlim([0.57 0.64])
%ylim([5 100])