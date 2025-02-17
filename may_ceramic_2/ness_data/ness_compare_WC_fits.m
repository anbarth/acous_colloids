phi0 = 0.6482; % from ness_find_phi0_exclude_lower_phi

f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar,phimu] = ness_wyart_cates_fix_phi0(dataTable,f,phi0,true);
disp(sigmastar)

f = @(sigma,sigmastar) sigma./(sigma+sigmastar);
[eta0,sigmastar,phimu] = ness_wyart_cates_fix_phi0(dataTable,f,phi0,true);
disp(sigmastar)
