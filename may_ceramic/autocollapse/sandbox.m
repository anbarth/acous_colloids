[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_init,13);
xi0 = (A/eta0)^(1/(-2-delta));
delta = -0.5;
%A = xi0^(-2-delta)*eta0;
A = 1;

y_alter = setParams(y_init,13,'width',0.5,'delta',delta,'A',A);
show_cardy(dataTable,y_alter,'ShowInterpolatingFunction',true,'alpha',alpha)