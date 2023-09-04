global CSS CSR CSV stress_list volt_list phi_list data_by_vol_frac vol_frac_markers;

CSS = (50/19)^3;
CSR = 19/50;
CSV = CSS/CSR;

stress_list = CSS*[0.1,0.2,0.4,0.8,1,2,4,8,10,20,40,80,100,200,400];
volt_list = [0,5,10,20,40,60,80,100];
phi_list = [44,46,48,50,52,53,54,55];
for ii = 1:length(phi_list)
    matFileName = strcat('phi_0',num2str(phi_list(ii)),'.mat');
    load(matFileName);
end
data_by_vol_frac = {phi_044,phi_046,phi_048,phi_050,phi_052,phi_053,phi_054,phi_055};
vol_frac_markers = ['^','>','s','o','d','p','h','v'];