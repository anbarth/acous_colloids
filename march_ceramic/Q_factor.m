function Q = Q_factor(phi,sigma,Q_table)

%Q_table = Q_tab_k05(phi);
%if ~Q_table
%    Q=1;
%    return
%end

my_Q_table = Q_table(Q_table(:,1)==phi,2:3);
qIndex = find(my_Q_table(:,1)==sigma);
if qIndex
    Q=my_Q_table(qIndex,2);
else
    if sigma>0.05
        % if sigma is high, give a warning
        % but for low sigma, those values are supposed to be Q=1 anyway
        disp(strcat("sigma value ",num2str(sigma)," not found in Q"))
    end
    Q=1;
end


end