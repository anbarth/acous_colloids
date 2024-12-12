function P = getP_singlevalue(phi,sigma,V,dataTable)

P = zeros(size(sigma));
for kk = 1:length(sigma)
    mySigma = sigma(kk);
    eta_0V = dataTable(dataTable(:,1)==phi & dataTable(:,2)==mySigma & dataTable(:,3)==0,4);
    gamma_dot_0V = mySigma/eta_0V;
    P(kk) = V^2/mySigma/gamma_dot_0V;
end

end