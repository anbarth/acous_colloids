dataTable = may_ceramic_09_17;
load("y_09_19_ratio_with_and_without_Cv.mat")
y_optimal = y_Cv;


P = 116 - 13 - 5*6 - 2;
N = size(dataTable,1);
dof = N-P;


chi2 = @(y) sum(getResiduals(dataTable,y).^2);

chi2_optimal = chi2(y_optimal);

% this is how high chi2 needs to get for me to feel worried
% if you're getting this chi2, then the answer to "how often would i expect
% to see a chi2 value higher than this one?" is only 5% of the time
chi2_cutoff = chi2inv(0.95,dof);

paramNum = 3;
constrainedValue_guess = -0.4;

%paramNum = 3;
%paramRangeLow = y_optimal(paramNum);
%paramRangeHigh = -0.5;

% cost fxn is (chi2-chi2_cutoff)^2
% so we're looking for the constrained value that forces chi^2
% up to the cutoff value
%chi2_cost_fxn = @(constrainedValue) (chi2_constrained(dataTable,y_optimal,paramNum,constrainedValue)-chi2_cutoff)^2;

%opts = optimoptions('fmincon','Display','iter','MaxFunctionEvaluations',15,'OptimalityTolerance',1);
%myCriticalConstrainedValue = fmincon(chi2_cost_fxn,constrainedValue_guess,[],[],[],[],[],[],[],opts);


%myCriticalConstrainedValue = fminbnd(chi2_cost_fxn,paramRangeLow,paramRangeHigh,options);

options = optimset('Display','iter','TolX',abs(y_optimal(paramNum)*0.001));
chi2_fxn = @(constrainedValue) chi2_constrained(dataTable,y_optimal,paramNum,constrainedValue)-chi2_cutoff;
[myCriticalConstrainedValue,fval,exitflag,output]  = fzero(chi2_fxn,constrainedValue_guess,options);