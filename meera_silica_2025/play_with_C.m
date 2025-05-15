dataTable = meera_cs_table;


f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar,phimu,phi0] = wyart_cates(dataTable,f,false);
%sigmastar = 3;


D = [ 0.5   0.5   0.5   0.9    0.9   ...
      0.9    0.95    0.95    0.95    0.97   ...
      0.978    0.98   0.98    0.979    0.98   ...
      0.9799    0.9799    0.9799    0.9799   0.9799  ...
      0.98    0.98    0.98    0.98    0.98   ...
      0.980    0.98    0.98      0.98     0.98] * 1/0.98;


y = [eta0 0.65 delta A width sigmastar D];

phiRange = 30:-1:1;
show_F_vs_x(dataTable,y,@modelHandpicked,'PhiRange',phiRange,'ShowLines',true); %xlim([0.5 1.5])
show_F_vs_xc_x(dataTable,y,@modelHandpicked,'PhiRange',phiRange,'ShowLines',true); 