for ii=1:14
    wiggle_param(may_ceramic_09_17,y_optimal_fmin_lsq,@modelSmoothFunctions,ii);
    hold on;
    title(ii)
end