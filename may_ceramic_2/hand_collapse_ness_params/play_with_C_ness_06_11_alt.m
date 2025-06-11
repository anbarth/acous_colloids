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

% from chris' simulations
delta = -2.7;
alpha = 0.5;

% not important here
A = 0.02; width = 1;


% guess D
D = [ 0.0002    0.0017    0.0175    0.0375    0.1219    0.4    0.6    0.65    0.67    0.73    0.73    0.74    0.7584];
y_handpicked_06_11 = [eta0, phi0, delta, A, width, sigmastar0V, D];

%return
phiRange = 13:-1:1;
show_F_vs_xc_x(dataTable,y_handpicked_06_11, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
prettyplot
show_F_vs_x(dataTable,y_handpicked_06_11, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true);
xlim([1e-5 1.5])
prettyplot
return

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_0V,'o');