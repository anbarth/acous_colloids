load("ness_data_02_25.mat")
dataTable = ness_data_table;
dataTableRaw = ness_data_table_raw;
dataBelowSJ = dataTable(dataTable(:,4)<1e6,:);

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


phi0 = 0.6482; % from ness_find_phi0_exclude_lower_phi

f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar,phimu] = ness_wyart_cates_fix_phi0(dataBelowSJ,f,phi0,false);
%return

phiJ = [];
sigmaJ = [];
sigmaJ_plus = [];
sigmaJ_minus = [];
for ii=1:length(phi_list)
    phi = phi_list(ii);
    if phi < 0.59
        continue
    end
    stress = dataTable(dataTable(:,1)==phi,2);
    mySigmaJ = max(stress);
    stress_raw = sort(dataTableRaw(dataTableRaw(:,1)==phi,2));
    stress_raw_index = find(stress_raw==mySigmaJ);
    mySigmaJ_minus = stress_raw(stress_raw_index-1);
    mySigmaJ_plus = stress_raw(stress_raw_index+1);

    sigmaJ(end+1)=mySigmaJ;
    sigmaJ_plus(end+1)=mySigmaJ_plus;
    sigmaJ_minus(end+1)=mySigmaJ_minus;
    phiJ(end+1)=phi;
end

figure; hold on; ax1=gca; ax1.YScale='log';
xlabel('\phi')
ylabel('\sigma_J')
errorbar(phiJ,sigmaJ,sigmaJ-sigmaJ_minus,sigmaJ_plus-sigmaJ,'-o')

figure; hold on; %ax1=gca; ax1.YScale='log';
makeAxesLogLog;
f = @(sigma) exp(-sigmastar./sigma);
xlabel('\phi_0-\phi')
ylabel('f(\sigma_J)')
errorbar(phi0-phiJ,f(sigmaJ),f(sigmaJ)-f(sigmaJ_minus),f(sigmaJ_plus)-f(sigmaJ),'-o')
