load("optimized_params_02_11.mat")
%paramsVector = y_fminsearch; myModelHandle=@modelHandpickedAllExp;

[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(y_fminsearch,13); 
D_no_voltage = repmat(D(:,1),7);
phi_fudge = zeros(1,13);
y_handpicked_all_0V = zipParamsHandpickedAll(eta0,phi0,delta,A,width,sigmastar,D_no_voltage,phi_fudge);

show_F_vs_xc_x(may_ceramic_09_17,y_fminsearch,@modelHandpickedAllExp)
show_F_vs_xc_x(may_ceramic_09_17,y_handpicked_all_0V,@modelHandpickedAllExp)


%smooth_C_03_11;
%paramsVector = y_logistic; myModelHandle=@modelLogisticCV;

y_logistic_0V = y_logistic;
y_logistic_0V(13) = 0;

show_F_vs_xc_x(may_ceramic_09_17,y_logistic,@modelLogisticCV)
show_F_vs_xc_x(may_ceramic_09_17,y_logistic_0V,@modelLogisticCV)