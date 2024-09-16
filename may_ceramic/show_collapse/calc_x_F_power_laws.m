function [x,F,delta_F] = calc_x_F_power_laws(stressTable,phi0,beta)

phi_list = unique(stressTable(:,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = size(stressTable,1);
x = zeros(N,1);
F = zeros(N,1);
delta_F = zeros(N,1);

phi_fudge = zeros(size(phi_list));

for kk = 1:N
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta = stressTable(kk,4);        
    delta_eta = max(stressTable(kk,5),eta*0.05);
    delta_phi = 0.01;

    ii = find(phi == phi_list);

    my_phi_fudge = phi_fudge(ii);
    x(kk) = sigma / (phi0-(phi+my_phi_fudge))^beta;
    F(kk) = eta*(phi0-(phi+my_phi_fudge))^2;
    delta_F(kk) = F(kk) .* (eta.^(-2).*delta_eta.^2 + 4/(phi0-(phi+my_phi_fudge))^2*delta_phi^2 ).^(1/2);
end





end