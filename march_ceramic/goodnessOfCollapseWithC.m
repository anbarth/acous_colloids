function goodness = goodnessOfCollapseWithC(stressTable,myC,print)

if nargin < 3
    print = 0;
end

vol_frac_plotting_range = 1:5;
volt_plotting_range = 1;

collapse_params;
phi_list = [44,48,52,56,59];
volt_list = [0,5,10,20,40,60,80,100];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_all = zeros(0,1);
F_all = zeros(0,1);


for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii)/100;
        myData = stressTable( stressTable(:,1)==phi & stressTable(:,3)==voltage,:);
        sigma = myData(:,2);
        eta = myData(:,4);
        delta_eta = myData(:,5);

        
        % calculate nondimensionalized power
        P = zeros(size(sigma));
        for kk = 1:length(P)
            P(kk) = calculateP(phi,sigma(kk),voltage,stressTable);
        end


        xWC = myC(ii)*A(P).*f(sigma) ./ (-1*phi+phi0);
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
goodness = goodnessOfCollapse(x_all,F_all,print);


end