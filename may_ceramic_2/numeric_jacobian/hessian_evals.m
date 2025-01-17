dataTable = may_ceramic_09_17;
load("01_12_optimal_params.mat")
myModelHandle = @modelHandpickedAll; myParams = y_full_fmin_lsq;
%myModelHandle = @modelSmoothFunctions; myParams = y_smooth_fmin_lsq;
%myModelHandle = @modelLogHandpickedAll; myParams = y_optimal_fmin_lsq;
%yModelHandle = @modelHandpickedAll; myParams = y_optimal;

% display hessian eigenvalues
jacobian = numeric_jacobian(dataTable,myParams,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% "straightforward" way to calculate eigenvalues isnt the best, you can get
% negative evals which should NOT be possible for JtJ
%[vecs,vals_matrix] = eig(hessian); 
%vals = diag(vals_matrix);

% instead, use SVD! very numerically robust and stable, for some reason
[U,S,V] = svd(jacobian); 
vals=flip(diag(S).^2);

figure; hold on; ax1=gca;ax1.YScale='log';
plot(vals,'o')
disp(vals(vals<=0))

return
% display eigenvectors
figure; hold on;
ax1=gca;ax1.YScale='log';
%for ii=1:size(vecs,2)
for ii=14
    plot(abs(vecs(:,ii)),'-o')
end
legend;

