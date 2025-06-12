dataTable = may_ceramic_09_17;

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar0V,phimu,phi0] = wyart_cates(dataTable,f,false);
sigmastar0V = sigmastar0V*100;
%sigmastar = sigmastar0V*ones(1,numV);
%phi_fudge = zeros(size(phi_list))';
%return

% not important here
delta = -1; A = 0.02; width = 1;


% guess D
D_0V = [1e-100 1e-100 1e-100 1e-80 1e-60 1e-40 1e-10 3e-10 0.00002 0.01 0.05 0.12 1.8]*0.5;


%y_handpicked_02_11 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
y_handpicked_03_19 = [eta0, phi0, delta, A, width, sigmastar0V, D_0V];

%return
phiRange = 13:-1:1;
show_F_vs_xc_x(dataTable,y_handpicked_03_19, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_x(dataTable,y_handpicked_03_19, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true); xlim([1e-30 1.5])
return
%%
dphi = phi0-phi_list;
l2 = 10:13;
linearfit = fittype('poly1');
myft2 = fit(log(dphi(l2)),log(D_0V(l2))',linearfit);
alpha = -myft2.p1;
disp(myft2)

figure; hold on;
makeAxesLogLog;
xlabel('\phi_0-\phi'); ylabel('D')
plot(dphi,D_0V,'ko','MarkerFaceColor','k');
plot(dphi(l2),dphi(l2).^myft2.p1*exp(myft2.p2),'b-')
prettyplot