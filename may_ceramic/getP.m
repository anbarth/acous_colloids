function P = getP(dataTable)

P = zeros(size(dataTable,1),1);
for kk = 1:size(dataTable,1)
    phi = dataTable(kk,1);
    sigma = dataTable(kk,2);
    V = dataTable(kk,3);  
    eta_0V = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma & dataTable(:,3)==0,4);
    gamma_dot_0V = sigma/eta_0V;
    P(kk) = V^2/sigma/gamma_dot_0V;
end

end