dataTable = may_ceramic_09_17;

f1  = @(sigma,sigmastar) exp(-sigmastar./sigma);
f2 = @(sigma,sigmastar) sigma./(sigma+sigmastar);
f3 = @(sigma,sigmastar) sigma./sqrt(sigma.^2 + sigmastar^2);
f4 = @(sigma,sigmastar) 1-exp(-sigma/sigmastar);

[eta0,sigmastar,phimu,phi0] = wyart_cates(dataTable,f1,true); title('f=exp(\sigma^*/\sigma)')
disp([eta0,sigmastar,phimu,phi0])
[eta0,sigmastar,phimu,phi0] = wyart_cates(dataTable,f2,true); title('f=\sigma/(\sigma+\sigma^*)')
disp([eta0,sigmastar,phimu,phi0])
[eta0,sigmastar,phimu,phi0] = wyart_cates(dataTable,f3,true); title('f=\sigma/sqrt(\sigma^2+\sigma^*^2)')
disp([eta0,sigmastar,phimu,phi0])
[eta0,sigmastar,phimu,phi0] = wyart_cates(dataTable,f4,true); title('f=1-exp(\sigma/\sigma^*)')
disp([eta0,sigmastar,phimu,phi0])