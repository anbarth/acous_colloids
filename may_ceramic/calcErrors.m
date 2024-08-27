% run calcCollapse first to populate jacobian etc
myBigMatrix = transpose(jacobian) * jacobian * resnorm / (size(jacobian,1)-size(jacobian,2));
errors = diag(myBigMatrix);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, C_err, phi_fudge_err] = unzipParamsCrossoverFudge(errors,numPhi);

% try pseudo inverse to deal with zero eigenvalues that lead to infinities
% in the inverse