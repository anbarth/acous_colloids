stressTable = march_data_table_05_02;

N = size(stressTable,1); % num data points
P = length(paramsVector); % num parameters

sse = collapseSSE(paramsVector,stressTable);
J = collapseJacobian(paramsVector,stressTable);

JtJ_untrim = transpose(J)*J;
% 0 columns of J correspond to params which don't affect the SSE
% eg C values for phi,sigma pairs that are missing
zero_columns = all(JtJ_untrim==0);

Jtrim = J(:,~zero_columns);
JtJ = transpose(Jtrim)*Jtrim; 
%TODO maybe P should not include the parameters that i trim out here

big_ol_matrix = JtJ*sse/(N-P);

parameter_variance_trim = diag(big_ol_matrix);
parameter_std_err_trim = sqrt(parameter_variance_trim);

parameter_std_err = zeros(size(paramsVector));
counter = 1;
for ii=1:length(parameter_std_err)
    if zero_columns(ii)
        parameter_std_err(ii)=0;
    else
        parameter_std_err(ii)=parameter_std_err_trim(counter);
        counter = counter+1;
    end
end

paramUncertainty = parameter_std_err*tinv(0.975,N-P);