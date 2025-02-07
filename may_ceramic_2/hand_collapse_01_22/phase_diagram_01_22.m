data_table = may_ceramic_09_17;

%calcCollapse_acous_free_01_22;
paramsVector = y_optimal;

figure; hold on;
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma')


[x_all,F_all,delta_F,F_hat,eta,delta_eta,eta_hat] = modelHandpicked0V(data_table, paramsVector);

phi0=paramsVector(2);

Fmin = min(F_all(F_all>0));
Fmax = max(F_all);

cmap = plasma(256);
colormap(cmap)
myColor = @(F) cmap(round(1+255*(log(F)-log(Fmin))/(log(Fmax)-log(Fmin))),:);


voltNum=1;

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

for sigma=logspace(-3,3,1000)
    %disp(phiJHandpicked0V(sigma,data_table,paramsVector))
    plot(phiJHandpicked0V(sigma,data_table,paramsVector),sigma,'k.')
end


% WC prediction for the phase boundary
[eta0,sigmastar,phimu,phi0WC] = wyart_cates(data_table);
myPhi = [linspace(phimu,phi0WC-0.011) phi0WC-logspace(-2,-4)];
Q = @(p) (phi0WC-p)/(phi0WC-phimu);
%plot(myPhi,sigmastar*(Q(myPhi)./(1-Q(myPhi))),'-r')
for x = 1
   [myPhi,mySigma] = wyartCatesConstantX(x,sigmastar,phimu,phi0WC);
   plot(myPhi,mySigma,'k-','LineWidth',1.5)
end

%xlim([0.4 0.65])
%ylim([1e-2 10^(2.5)])