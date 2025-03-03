%optimize_C_jardy_02_11;
y_optimal = y_fmincon_0V;
myModelHandle = @modelHandpickedAllExp0V;

jacobian = numeric_jacobian(acoustics_free_data,y_optimal,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% "straightforward" way to calculate eigenvalues isnt the best, you can get
% negative evals which should NOT be possible for JtJ
%[vecs,vals_matrix] = eig(hessian); 
%vals = diag(vals_matrix);

% instead, use SVD! very numerically robust and stable, for some reason
% J^T J = V Sigma U^T U Sigma V^T = V Sigma^2 V^T, and so the columns of V are the eigenvectors and the eigenvalues are the singular values (in Sigma) squared
[U,S,V] = svd(jacobian); 
vals=flip(diag(S).^2);
vecs=V;

figure; hold on; ax1=gca;ax1.YScale='log';
plot(vals,'o')
disp(vals(vals<=0))
xlabel('#')
ylabel('eigenvalue')

%return
% display eigenvectors
figure; hold on;
ax1=gca;ax1.YScale='log';
%for ii=1:size(vecs,2)
for ii=19
    plot(abs(vecs(:,ii)),'-o')
end
legend;