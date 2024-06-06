stressTable = may_ceramic_06_05;

collapse_params;

vol_frac_plotting_range = 1:11;
volt_plotting_range = 1:7;

phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_all = zeros(0,1);
F_all = zeros(0,1);


for ii = vol_frac_plotting_range
    for jj = volt_plotting_range
        voltage = volt_list(jj);
        phi = phi_list(ii);
        myData = stressTable( stressTable(:,1)==phi & stressTable(:,3)==voltage,:);
        sigma = myData(:,2);
        eta = myData(:,4);
        delta_eta = myData(:,5);

        xWC = C(ii)*f(sigma,jj);
        FWC = eta*(phi0-phi)^2;

        x_all(end+1:end+length(xWC)) = xWC;
        F_all(end+1:end+length(FWC)) = FWC;
    end
end

% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);

%disp(myC)
print = true;
goodness = goodnessOfCollapse(x_all,F_all,print);