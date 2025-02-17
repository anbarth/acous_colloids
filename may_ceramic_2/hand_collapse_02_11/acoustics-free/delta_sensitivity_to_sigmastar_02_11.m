dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar0V,phimu,phi0] = wyart_cates(may_ceramic_09_17,f,false);

delta = -0.8; A = 0.04; width = 0.8;
% guess C
D = zeros(numPhi,numV);
D_0V = [0.0005 0.005 0.05 0.1 0.3 0.6 0.8 0.9 0.9 1 1 1 1.025]*1/1.01/1.02;
D(:,1) = D_0V;

%y_handpicked_02_11 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
y_handpicked_1 = [eta0, phi0, delta, A, width, sigmastar0V, D_0V];
%return

sigmastar_alt = 2;
D_2 = D_0V;
D_2(end) = 0.98;
y_handpicked_2 = [eta0, phi0, delta, A, width, sigmastar_alt, D_2];


phiRange = 13;
%show_F_vs_xc_x(dataTable,y_handpicked_1, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_handpicked_2, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)

%show_F_vs_x(dataTable,y_handpicked_02_11, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
return

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_0V,'o');