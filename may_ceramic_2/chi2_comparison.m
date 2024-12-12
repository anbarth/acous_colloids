dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
load("y_09_19_ratio_with_and_without_Cv.mat")
%y_overfit = y_Cv;
y_overfit = y_handpicked_10_28;
% eta0, phi0, delta, A, width = 5 params
% sigma*(V) = 3 params
% C(phi,V) = 59 params (=7*13-5*6-2)
P_overfit = 5+3+59;
N = size(dataTable,1);
dof_overfit = N-P_overfit;

%load("y_reduced_10_29.mat")
y_fewerParams = reducedParamsToFullParams(y_red_handpicked,phi_list);
% eta0, phi0, delta, A, width = 5 params
% sigma*(V) = 3 params
% C(phi,V) = 6 params (alpha, beta, q0, q1)
P_fewerParams = 5+3+6;
dof_fewerParams = N-P_fewerParams;


%chi2 = @(y) sum(getResiduals(dataTable,y).^2);
chi2 = @(y) sum(fitToInterpolatingFxnThenGetResiduals(dataTable,y).^2);

% you expect chi2/dof to be around 1
disp(chi2(y_overfit)/dof_overfit);
disp(chi2(y_fewerParams)/dof_fewerParams);

% neither of them is exactly one. how "bad" is that?
% this number answers the question, "how often would i expect to see a chi2
% value smaller than this one?"
% you "want" it to be like, 50% (which happens around chi2/dof=1)
disp(chi2cdf(chi2(y_overfit),dof_overfit))
disp(chi2cdf(chi2(y_fewerParams),dof_fewerParams))



% this is how high chi2 needs to get for me to feel worried
% if you're getting this chi2, then the answer to "how often would i expect
% to see a chi2 value higher than this one?" is only 5% of the time
chi2_cutoff = chi2inv(0.95,dof_overfit);
% 1-chi2cdf(chi2_cutoff,dof) % returns 5%
