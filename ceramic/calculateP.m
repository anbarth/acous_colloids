function P = calculateP(phi,sigma,V,dataTable)

eta_0V = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma & dataTable(:,3)==0,4);
gamma_dot_0V = sigma/eta_0V;
P = V^2/sigma/gamma_dot_0V;

end