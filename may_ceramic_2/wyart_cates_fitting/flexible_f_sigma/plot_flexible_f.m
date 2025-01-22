mySig = logspace(-4,4);
figure; hold on; ax1=gca; ax1.XScale='log';
plot(mySig,flexible_f(mySig,f_params))

% numSigmoids = length(f_params)/2;
% f1 = @(sigma,sigmastar,k) exp(-(sigmastar./sigma).^k);
% for ii=1:2:length(f_params)
%     f_vals = f_vals + 1/numSigmoids*f1(sigma,f_params(ii),f_params(ii+1));
% end