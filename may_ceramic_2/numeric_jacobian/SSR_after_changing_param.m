function myResnorm = SSR_after_changing_param(dataTable,paramsVector,myModelHandle,paramNum,myParam)

y_init = paramsVector;
y_init(paramNum) = myParam;

% avoid crashing the optimizer
[~,~,~,F_hat,~,~,~] = myModelHandle(dataTable,y_init);
if any(imag(F_hat)~=0)
    myResnorm=Inf;
else 
    y = optimize_params_fix_one_param_loggily(dataTable,myModelHandle,y_init,paramNum,3);
    myResnorm = sum(get_residuals(dataTable, y, myModelHandle).^2);       
end

end