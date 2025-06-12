dataTable = may_ceramic_09_17;

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar0V,phimu,phi0] = wyart_cates(dataTable,f,false);
sigmastar0V = sigmastar0V*10;
%sigmastar = sigmastar0V*ones(1,numV);
%phi_fudge = zeros(size(phi_list))';
%return

% not important here
delta = -0.5; A = 2; width = 1;


% guess D
D_0V = [1e-20 1e-20 1e-6 1e-5 1e-4 1e-3 0.1 0.3 0.4 0.8 0.8 0.9 1.1]*0.85;


%y_handpicked_02_11 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
y_handpicked_03_19 = [eta0, phi0, delta, A, width, sigmastar0V, D_0V];

%return
phiRange = 13:-1:1;
show_F_vs_xc_x(dataTable,y_handpicked_03_19, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_x(dataTable,y_handpicked_03_19, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true); xlim([1e-10 1.5])
%show_cardy(dataTable,y_handpicked_03_19, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true); xlim([1e-3 200])
%x = logspace(-3,2);
%plot(x,A*x.^delta,'b-')
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