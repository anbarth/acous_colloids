%fit_D_phi_2_power_laws;
[eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(y_red_handpicked);

% overall translation
%q0new = 300; q1params(2) = q1params(2)*(q0new/q0params(2))^(alpha/(alpha+b)); q0params(2) = q0new;

%sigmastarParams(3) = 0.06;

y_red_fiddle = zipReducedParams(eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params);
show_F_vs_x(may_ceramic_09_17,reducedParamsToFullParams(y_red_fiddle),'ColorBy',2,'VoltRange',1,'ShowLines',true)