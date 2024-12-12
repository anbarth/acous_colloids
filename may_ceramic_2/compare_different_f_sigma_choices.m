dataTable = may_ceramic_09_17;
load("different_f_sigma.mat");
%show_F_vs_x(dataTable,y_exp,'ShowInterpolatingFunction',false,'VoltRange',1,'ColorBy',2,'ShowLines',true); title('exp');
%show_F_vs_x(dataTable,y_ratio,'ShowInterpolatingFunction',false,'VoltRange',1,'ColorBy',2,'ShowLines',true); title('ratio');
%show_F_vs_x(dataTable,y_tanh,'ShowInterpolatingFunction',false,'VoltRange',1,'ColorBy',2,'ShowLines',true); title('tanh');

[eta0, phi0, delta, A, width, sigmastar_exp, C, phi_fudge] = unzipParams(y_exp,13);
[eta0, phi0, delta, A, width, sigmastar_ratio, C, phi_fudge] = unzipParams(y_ratio,13);
[eta0, phi0, delta, A, width, sigmastar_tanh, C, phi_fudge] = unzipParams(y_tanh,13);
disp([sigmastar_exp(1) sigmastar_ratio(1)  sigmastar_tanh(1) ])

figure;
plot_C_phi(dataTable,y_exp);
plot_C_phi(dataTable,y_ratio);
plot_C_phi(dataTable,y_tanh);
legend('exp','ratio','tanh');