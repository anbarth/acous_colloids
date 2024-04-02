function Q = Q_factor(phi,sigma)

Q_table = Q_tab(phi);
if ~Q_table
    Q=1;
    return
end

qIndex = find(Q_table(:,1)==sigma);
if qIndex
    Q=Q_table(qIndex,2);
else
    disp(strcat("sigma value ",num2str(sigma)," not found in Q"))
    Q=1;
end


end