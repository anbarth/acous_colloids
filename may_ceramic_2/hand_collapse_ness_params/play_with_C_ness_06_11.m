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


% guess B
B = [0.025 0.05 0.1 0.2 0.5 0.8 1 1 1 1 1 1 1]*0.22;
dphi = phi0-phi_list';
D = B./dphi.^alpha;

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