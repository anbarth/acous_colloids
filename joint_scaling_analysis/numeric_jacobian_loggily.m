function jacobian = numeric_jacobian_loggily(dataTable,myParams,myModelHandle, varargin)

jacobian = numeric_jacobian(dataTable,myParams,myModelHandle);
for p=1:length(myParams)
    myParam = myParams(p);
    jacobian(:,p) = myParam * jacobian(:,p);
end


end