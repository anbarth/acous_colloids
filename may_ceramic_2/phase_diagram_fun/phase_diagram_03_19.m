% import data and params
data_table = may_ceramic_09_17;
%smoothen_C_acous_free_03_19;
alpha = -myft2.p1;
D0 = exp(myft2.p2);

myModelHandle = @modelHandpickedAllExp0V; paramsVector = y_lsq_0V;
[x_all,F_all,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(data_table, paramsVector);
phi0=paramsVector(2);
sigmastar = paramsVector(6);
D = paramsVector(7:end);
phi_list = unique(data_table(:,1));

CSS=(50/19)^3;
%CSS=1;

% pick V
voltNum=1;
volt_list = [0 5 10 20 40 60 80];
volt_to_plot = volt_list(voltNum);


% set up fig
figure; hold on;
ax1=gca;
ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma (Pa)')

% set up cmap for F or eta
Fmin = min(F_all);
Fmax = max(F_all);
etamin = min(eta);
etamax = max(eta);
cmap = plasma(256);
colormap(cmap)
%myColor = @(F) cmap(round(1+255*(log(F)-log(Fmin))/(log(Fmax)-log(Fmin))),:);
myColor = @(eta) cmap(round(1+255*(log(eta)-log(etamin))/(log(etamax)-log(etamin))),:);



% plot F data or eta data
for kk=1:size(data_table,1)
    V = data_table(kk,3);
    if V ~= volt_to_plot
        continue
    end
    phi = data_table(kk,1);
    sigma = data_table(kk,2);
    eta = data_table(kk,4);
    F = eta*(phi0-phi)^2;
    scatter(phi,sigma*CSS,500,myColor(eta),'filled','s');
end

mySigma = logspace(-3,3)';
%for x=[0.5 0.9 0.95 1]
myAlpha=1;
%mySigmastar = sigmastar/alpha*myAlpha;
D0 = D(end)*(phi0-phi_list(end))^myAlpha;
mySigmastar = sigmastar;
for x=1
    myPhi = interpConstantX(x,mySigma,phi0,mySigmastar,D,myAlpha,D0,phi_list);
    plot(myPhi,mySigma*CSS,'k-','LineWidth',1.5)
end
colorbar;

xlim([0.4 0.73])
ylim(CSS*[1e-2 10^(2.5)])