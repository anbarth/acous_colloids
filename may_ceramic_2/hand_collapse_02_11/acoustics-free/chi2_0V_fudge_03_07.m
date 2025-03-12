optimize_C_fudge_03_07;
y = y_fmincon_0V;

P = length(y);
N = size(acoustics_free_data,1);
dof = N-P;


chi2 = @(y) sum(get_residuals(acoustics_free_data,y,@modelHandpickedAllExp0VFudge).^2);

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


show_F_vs_x(acoustics_free_data,y,@modelHandpickedAllExp0VFudge,'ColorBy',2,'ShowLines',true,'ShowErrorBars',true,'ShowInterpolatingFunction',true)
xlim([1e-5 1.5])
prettyPlot;

show_F_vs_xc_x(acoustics_free_data,y,@modelHandpickedAllExp0VFudge,'ColorBy',2,'ShowLines',true,'ShowErrorBars',true,'ShowInterpolatingFunction',true)
prettyPlot;

