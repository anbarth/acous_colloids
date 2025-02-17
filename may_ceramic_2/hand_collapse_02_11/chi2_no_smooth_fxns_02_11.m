dataTable = may_ceramic_09_17;
load("optimized_params_02_11.mat");
y = y_fminsearch;

P = 116 - 13 - 5*6 - 2;
N = size(dataTable,1);
dof = N-P;


chi2 = @(y) sum(get_residuals(dataTable,y,@modelHandpickedAllExp).^2);

chi2_optimal = chi2(y);
disp(chi2_optimal/dof)

% this number answers, "given a bunch of trials, how often would i expect
% to see a chi2 value higher than this one?"
%disp(1-chi2cdf(chi2_optimal,dof))
% the answer seems to be: every time! does that indicate we're overfitting?

disp(chi2cdf(chi2_optimal,dof))

% this is how high chi2 needs to get for me to feel worried
% if you're getting this chi2, then the answer to "how often would i expect
% to see a chi2 value higher than this one?" is only 5% of the time
%chi2_cutoff = chi2inv(0.95,dof);