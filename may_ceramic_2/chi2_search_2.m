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

%interval_left = interval_right - 0.5;
%interval_right = y_optimal(paramNum);

interval_left = y_optimal(paramNum);
interval_right = 0;

%chi2_left = chi2_constrained(dataTable,y_optimal,paramNum,my_param);

params = zeros(0,1);
chi2s = zeros(0,1);
my_constrained_chi2 = Inf;
while abs(my_constrained_chi2-chi2_cutoff) > 100
    % evaluate chi2 in middle of interval
    interval_mid = (interval_left+interval_right)/2;
    my_param = interval_mid;
    my_constrained_chi2 = chi2_constrained(dataTable,y_optimal,paramNum,my_param);

    % store values
    disp([my_param my_constrained_chi2]);
    params(end+1) = my_param;
    chi2s(end+1) = my_constrained_chi2;

    if abs(my_constrained_chi2-chi2_cutoff) < 100
        break
    elseif my_constrained_chi2-chi2_cutoff < 0
        % search the left half-interval
        %interval_right = interval_mid;
        interval_left = interval_mid;
    else
        % search the right half-interval
        %interval_left = interval_mid;
        interval_right = interval_mid;
    end
end

figure; hold on;
scatter(params,chi2s);
yline(chi2_cutoff);
xline(my_param)
%disp(my_param)
%disp(my_constrained_chi2)