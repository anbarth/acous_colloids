function [goodness,xc] = goodnessOfCollapseWithCGparams(x,print)
% x = [C, G, sigma*, phi0]

if nargin < 2
    print = 0;
end


C = x(1:6);
G = x(7:14);
sigmastar = x(15);
if length(x) > 15
    phi0 = x(16);
else
    phi0 = 0.58;
end
f = @(sig)exp(-(sigmastar ./ sig).^(1));


global volt_list stress_list phi_list data_by_vol_frac

x_all = zeros(0,1);
F_all = zeros(0,1);

for ii = 1:6

    for jj = 1:length(volt_list)

        phi = phi_list(ii)/100;
        phi_data = data_by_vol_frac{ii};
        sigma = stress_list(1:size(phi_data,2));
      
        eta = phi_data(jj,:); % viscosities for just this voltage
        xWC = G(jj)*C(ii)*f(sigma) ./ (-1*phi + phi0);
        FWC = eta*(phi0-phi)^2;
        
        x_all(end+1:end+length(xWC)) = xWC;
        F_all(end+1:end+length(FWC)) = FWC;
    end
end

% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);

[goodness,xc] = goodnessOfCollapse(x_all,F_all,print);


end

