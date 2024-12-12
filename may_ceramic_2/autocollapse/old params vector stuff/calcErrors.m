% run calcCollapse first to populate jacobian etc

%tolerance = logspace(-7,-5,10);
tolerance = 1e-10;
uncertainty = zeros(size(tolerance));

for ii = 1:length(tolerance)
    dof = size(jacobian,1)-size(jacobian,2);
    JtJ = transpose(jacobian) * jacobian;
    JtJinv = pinv(JtJ, tolerance(ii));
    varianceMatrix = JtJinv * resnorm / dof;
    errors = sqrt(diag(varianceMatrix))*tinv(0.975,dof);
    [eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, C_err, phi_fudge_err] = unzipParams(errors,numPhi);

    uncertainty(ii) = phi0_err;
end

% figure; hold on;
% ax1=gca; ax1.XScale = 'log'; ax1.YScale = 'log';
% plot(tolerance,uncertainty,'-o');
% title('delta')
