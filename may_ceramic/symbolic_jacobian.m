syms PHI SIGMA V;
syms eta0 phi0 delta A h a2 a1 a0 alpha beta b1 b0 c1 c0;
syms eta x J f Q sigmastar q0 q1 xi xi0;
syms x_fun f_fun Q_fun sigmastar_fun q0_fun q1_fun;

eta = (phi0-PHI)^-2 * x^-2 * J;
x_fun = f / Q;

f_fun = SIGMA / (SIGMA + sigmastar);
sigmastar_fun = a2*V^2 + a1*V + a0;
f_fun = subs(f_fun,sigmastar,sigmastar_fun);

Q_fun = (q0*(phi0-PHI))^alpha + (q1*(phi0-PHI))^(alpha+beta);
q0_fun = b1*V + b0;
q1_fun = c1*V + c0;
Q_fun = subs(Q_fun,q0,q0_fun);
Q_fun = subs(Q_fun,q1,q1_fun);

x_fun = subs(x_fun,f,f_fun);
x_fun = subs(x_fun,Q,Q_fun);

J_fun = (A*eta0)^(1/2) * xi^((delta-2)/2) * ((xi/xi0)^h+(xi/xi0)^(-h))^((-2-delta)/(2*h));
J_fun = subs(J_fun, xi0, (A/eta0)^(1/(-2-delta))  );
J_fun = subs(J_fun, xi, 1/x-1);

eta = subs(eta,J,J_fun);
eta = subs(eta,x,x_fun);

params = [eta0 phi0 delta A h a2 a1 a0 alpha beta b1 b0 c1 c0];

% construct symbolic versions of [d_eta/d_theta1 ... d_eta/d_thetaP]
my_partials = sym(zeros(size(params)));
for ii=1:length(params)
    my_partials(ii) = diff(eta,params(ii));
end
%return
% each row of the jacobian is my_partials evaluated for each datapoint (PHI SIGMA V)
% for my params (eta0 phi0 ... c1 c0)
dataTable = may_ceramic_09_17;
% fit_D_phi_2_power_laws
paramsVector = y_red_handpicked;
%[eta0_val, phi0_val, delta_val, A_val, width_val, a2_val, a1_val, a0_val, alpha_val, beta_val, b1_val, b0_val, c1_val, c0_val] = unzipReducedParamsFlat(y)

% sub in parameter values
for ii=1:length(params)
    my_partials = subs(my_partials,params(ii),paramsVector(ii));
end

% this is slow AF
% maybe it'd be faster to first sub in all the (PHI, SIGMA, V)
% and save that column, which depends only on the form of the model and not
% the specific parameter values, then sub in the parameters
my_jacobian = zeros(size(dataTable,1),length(params));
for kk=1:size(my_jacobian,1)
    disp(kk)

    phi = dataTable(kk,1);
    sigma = dataTable(kk,2);
    volt = dataTable(kk,3);

    my_row = subs(my_partials,PHI,phi);
    my_row = subs(my_row,SIGMA,sigma);
    my_row = eval(subs(my_row,V,volt));

    my_jacobian(kk,:) = my_row;
end