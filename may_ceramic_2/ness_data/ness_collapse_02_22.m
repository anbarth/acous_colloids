load("ness_data_02_15.mat")
dataTable = ness_data_table_exclude_low_phi;
dataBelowSJ = dataTable(dataTable(:,4)<1e6,:);

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


phi0 = 0.6482; % from ness_find_phi0_exclude_lower_phi

f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar,phimu] = ness_wyart_cates_fix_phi0(dataBelowSJ,f,phi0,true);
%return

C = ones(1,length(phi_list));

D = (phi0-phimu)./(phi0-phi_list)';
D = D.*C;
D = D/1.2; % to ensure all data fall below x=1

%[eta0, phi0, delta, A, width, sigmastar, D]
y_init = [eta0,phi0,-3,eta0,0.5,sigmastar,D];
myModelHandle = @modelNessExp;

show_F_vs_x(dataTable,y_init,myModelHandle,'ShowLines',true,'ColorBy',2,'PhiRange',10:-1:1)
xlim([1e-4 2])