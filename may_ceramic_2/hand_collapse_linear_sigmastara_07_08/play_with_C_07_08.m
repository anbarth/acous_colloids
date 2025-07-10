dataTable = may_ceramic_09_17;

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar0V,phimu,phi0] = wyart_cates(dataTable,f,false);
%sigmastar = sigmastar0V*ones(1,numV);
%phi_fudge = zeros(size(phi_list))';
%return

% not important here
delta = -1; A = 0.02; width = 1;


% guess D
D_0V = [0.0005 0.005 0.05 0.1 0.3 0.6 0.8 0.9 0.9 1 1 1 1.025]*1/1.01/1.02;


%y_handpicked_02_11 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
y_handpicked_07_08 = [eta0, phi0, delta, A, width, sigmastar0V, D_0V];

return
phiRange = 13:-1:1;
show_F_vs_xc_x(dataTable,y_handpicked_07_08, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_x(dataTable,y_handpicked_07_08, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true); xlim([1e-5 1.5])
return

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_0V,'o');