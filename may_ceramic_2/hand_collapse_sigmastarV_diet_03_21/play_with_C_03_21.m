build_restricted_data_table_03_21;
dataTable = restricted_data_table;

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
delta = -1; A = 0.03; width = 1;


% guess D
D_0V = [0 0.0005 0 0.1 0 0.45 0 0.85 0 0.98 0 1 0]*1/1.01/1.02;
D_0V(excluded_phi_indices) = 0;


%y_handpicked_02_11 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);
y_handpicked_03_21 = [eta0, phi0, delta, A, width, sigmastar0V, D_0V];

return
phiRange = included_phi_indices;
%phiRange = 12:-2:2;
show_F_vs_xc_x(dataTable,y_handpicked_03_21, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_x(dataTable,y_handpicked_03_21, @modelHandpickedAllExp0V,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
xlim([1e-5 1.5])
return

figure; hold on;
makeAxesLogLog;
plot(phi0-phi_list,D_0V,'o');