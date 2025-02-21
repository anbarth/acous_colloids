stressTable = may_ceramic_09_17;
phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];

load("optimized_params_02_11.mat")
y = y_fminsearch;
[eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParamsHandpickedAll(y,13);
% appropriate guess at alpha
alpha=0.01;

% compute confidence intervals
jacobian = numeric_jacobian(stressTable,y,@modelHandpickedAllExp);
hessian = transpose(jacobian)*jacobian;
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, D_err, phi_fudge_err] = unzipParamsHandpickedAll(confInts',13);



cmap = plasma(256);
% colormap(cmap);
% cbar = colorbar;
% clim([0 80]);
% cbar.Ticks = [0,5,10,20,40,60,80];



logisticFit = fittype("L/(1+exp(-k*(x-x0)))");
logistic = @(L,k,x0,x) L./(1+exp(-k*(x-x0)));

Ls = zeros(7,1);
ks = zeros(7,1);
phistars = zeros(7,1);

for jj=1:size(D,2)

    figure; hold on;
    %ax1=gca; ax1.XScale='log'; ax1.YScale='log';
    ylabel('C')
    xlabel('\phi')
    %if jj>1; continue; end
    myD = D(:,jj);
    myD_err = real(D_err(:,jj));
    myPhi = phi_list+phi_fudge';
    voltage = volt_list(jj);


    myPhi = myPhi(myD~=0 & ~isnan(myD));
    myD_err = myD_err(myD~=0 & ~isnan(myD));
    myD = myD(myD~=0 & ~isnan(myD));
    

    myC = myD .* (phi0-myPhi).^alpha;
    myC_err = myD_err .* (phi0-myPhi).^alpha;
   

    myColor = cmap(round(1+255*voltage/80),:);
    errorbar(myPhi,myC,myC_err,'o','Color',myColor,'LineWidth',1);


    cFit = fit(myPhi,myC,logisticFit,'StartPoint',[0.95, 50, 0.4],'Weights',1./myC_err);

    Ls(jj)=cFit.L;
    ks(jj)=cFit.k;
    phistars(jj)=cFit.x0;

    plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,phi_list),'Color',myColor);
    
    xlim([0.1 0.7])
    ylim([0 1])


end

figure; plot(volt_list,Ls,'o-');
figure; plot(volt_list,ks,'o-');
figure; plot(volt_list,phistars,'o-');