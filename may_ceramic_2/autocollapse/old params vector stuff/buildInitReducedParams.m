fit_sigmastar_10_28;
sigmastarParams = p;

fit_C_phi_V;
close all;
b = myB;
phistarParams = pa;
Cphi0params = pc;

alpha=0.1;

[eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParams(y_handpicked_10_28,13);
y_reduced_10_29 = zipReducedParams(eta0, phi0, delta, alpha, A, width, sigmastarParams, b, phistarParams, Cphi0params);

%y_sig_min_2 = reducedParamsToFullParams(yReduced,phi_list);