dataTableFull = may_ceramic_09_17;
dataTable = dataTableFull(dataTableFull(:,3)==0,:);
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


myModelHandle = @modelWyartCatesAlpha;

f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar,phimu,phi0] = wyart_cates(dataTable,f,false);
alpha = 0.01;
delta = 2;
y_init = [eta0,sigmastar,phimu,phi0,alpha,delta];


show_cardy(dataTable,y_init,@modelWyartCatesAlpha,'ColorBy',2,'alpha',alpha,'ShowLines',true)
title(strcat('\alpha=',num2str(alpha)))