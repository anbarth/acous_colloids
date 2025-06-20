% import data and params
data_table = may_ceramic_09_17;
smoothen_C_acous_free_03_19;
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
xlim([0.4 0.73])
ylim(CSS*[1e-2 10^(2.5)])

% set up cmap for F or eta
Fmin = min(F_all);
Fmax = max(F_all);
etamin = min(eta);
etamax = max(eta);
cmap = plasma(256);
colormap(cmap)
colorbar;
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
    scatter(phi,sigma*CSS,400,myColor(eta),'filled','s');

    % mark DST points with an X
   % ii = find(phi_list==phi);
   % if (ii==13 && (sigma==0.3 || sigma==0.5)) || (ii==12 && (sigma==0.2 || sigma==0.3))
  % if (ii==13 && (sigma==0.3 || sigma==0.5)) 
  %      scatter(phi,sigma*CSS,100,'kx','LineWidth',1)
   %end
end

%myAlpha=alpha;
myAlpha=0.5;
%mySigmastar = sigmastar/alpha*myAlpha;
%D0 = D(end)*(phi0-phi_list(end))^myAlpha;
%D0 = D(end)*(phi0-phi_list(end))^myAlpha * 0.86;
D0 = D(end)*(phi0-phi_list(end))^myAlpha * 0.9;

phimu = invD(1,D,phi_list,phi0,D0,myAlpha);
disp(phimu)

% plot jamming line
xc=1;
mySigma = logspace(-3,3)';
myPhi = interpConstantX(xc,mySigma,phi0,sigmastar,D,myAlpha,D0,phi_list);
plot(myPhi,mySigma*CSS,'k-','LineWidth',1.5)

% plot DST line
% mySigma = logspace(-3,3)';
% myPhi = getDST(mySigma,sigmastar,paramsVector,myAlpha,D0,phi_list);
% plot(myPhi,mySigma*CSS,'k-','LineWidth',1.5)

% plot crossover line
% set up phi_crossover
A = paramsVector(4);
eta0 = paramsVector(1);
delta = paramsVector(3);
xi0 = (A/eta0)^(1/(-2-delta));
xstar = (xi0+1)^(-1*myAlpha);
mySigma = logspace(-3,3,1000)';
phi_crossover = interpConstantX(xstar,mySigma,phi0,sigmastar,D,myAlpha,D0,phi_list);
plot(phi_crossover,mySigma*CSS,'k-','LineWidth',1.5)

figure; hold on;
Dfake=linspace(0,2)';
phifake = invD(Dfake,D,phi_list,phi0,D0,myAlpha);
%plot(phifake,Dfake,'b-');
%plot(phi_list,D,'bo');
plot(phifake,Dfake.*(phi0-phifake).^myAlpha,'b-');
plot(phi_list,D'.*(phi0-phi_list).^myAlpha,'bo');