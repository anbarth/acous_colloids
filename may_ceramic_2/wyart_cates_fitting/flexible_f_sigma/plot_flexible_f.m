mySig = logspace(-4,4);
figure; hold on; ax1=gca; ax1.XScale='log';
plot(mySig,flexible_f(mySig,f_params))