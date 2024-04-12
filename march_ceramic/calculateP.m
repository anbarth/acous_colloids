function P = calculateP(phi,sigma,V,dataTable)

eta_0V = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma & dataTable(:,3)==0,4);
gamma_dot_0V = sigma/eta_0V;

%P = V^2/sigma/gamma_dot_0V;

%Q_table = Q_tab_k075();
%P = V^2/sigma/gamma_dot_0V*Q_factor(phi,sigma,Q_table);

%P = V^2 * (0.678-phi)^3.83 / gamma_dot_0V;

P = V^2 / gamma_dot_0V;
q = [0.44,1;
    0.48,1;
    0.52,1;
    0.56,1;
    0.59,1];
P = P*q(q(:,1)==phi,2);

end