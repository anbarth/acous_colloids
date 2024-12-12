function y_reduced_new = shift_xmax_to_val(dataTable,y_reduced_old,xmax_new)

[x,~,~] = calc_x_F(dataTable,reducedParamsToFullParams(y_reduced_old));
xmax_old = max(x);

[eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params] = unzipReducedParams(y_reduced_old);

% now i want to multiply everything by xmax_new/xmax_old
% which is equivalent to multiplying Q by xmax_old/xmax_new
a = xmax_old/xmax_new; 
q0params = q0params*a^(1/alpha);
q1params = q1params*a^(1/(alpha+b));

y_reduced_new = zipReducedParams(eta0, phi0, delta, A, width, sigmastarParams, alpha, b, q0params, q1params);

end