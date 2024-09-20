function [x,F,delta_F] = calc_x_F(stressTable, paramsVector)


[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13); 


%f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);
f = @(sigma,jj) sigma./(sigmastar(jj)+sigma);
%f = @(sigma,jj) tanh(sigma/sigmastar(jj));
%f = @(sigma,jj) sigma.^2;


phi_list = unique(stressTable(:,1));
volt_list = [0,5,10,20,40,60,80];

%C = C.*repmat(linspace(1,0.9,7),13,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = size(stressTable,1);
x = zeros(N,1);
F = zeros(N,1);
delta_F = zeros(N,1);

%P_all = getP(stressTable);

for kk = 1:N
    phi = stressTable(kk,1);
    sigma = stressTable(kk,2);
    voltage = stressTable(kk,3);
    eta = stressTable(kk,4);        
    delta_eta = max(stressTable(kk,5),eta*0.05);
    delta_phi = 0.01;
    %P = P_all(kk);

    ii = find(phi == phi_list);
    jj = find(voltage == volt_list);


    %mySigmaStar = 0.2812;
    %mySigmaStar = 0.2812+P*0.000001; % looks good at low x
%     if P == 0
%         mySigmaStar = 0.2812;
%     else
%         %mySigmaStar = 0.2812+0.05*log(P);
%         %ymin = 0.1;
%         %xmin = 5;
%         %mySigmaStar = 0.2812 + (0.2812-ymin)/xmin^2 * (-2*xmin*log(P)+log(P)^2);
%         mySigmaStar = 0.2812 + 0.005*log(P)^2;
%     end

    %mySigmaStar = 0.2812+P*1+P^2*1e-9;
    %myF = exp(-mySigmaStar./sigma);
    %x(kk) = C(ii,jj)*myF;

    my_phi_fudge = phi_fudge(ii);
    x(kk) = C(ii,jj)*f(sigma,jj);
    F(kk) = eta*(phi0-(phi+my_phi_fudge))^2;
    delta_F(kk) = F(kk) .* (eta.^(-2).*delta_eta.^2 + 4/(phi0-(phi+my_phi_fudge))^2*delta_phi^2 ).^(1/2);
end





end