function P = calculateP(phi,sigma,V,dataTable)

eta_0V = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma & dataTable(:,3)==0,4);
gamma_dot_0V = sigma/eta_0V;

%P = V^2/sigma/gamma_dot_0V;
P = V^2/sigma/gamma_dot_0V*Q_factor(phi,sigma);
%P = V^2 * (0.678-phi)^3.83 / gamma_dot_0V;
return
%P = V^2/sigma/gamma_dot_0V*exp(-1/(0.68-phi));
%P = V^2/sigma/gamma_dot_0V*exp(-(1/(0.68-phi))^0.75);
%P = V^2;
%P = V^2/sigma^2;
%P = V^2/sigma^2/gamma_dot_0V/phi^2;
%P = V^2/sigma^0.5;
%P=V^2/gamma_dot_0V^0.5;

if phi == 0.44
    P = P*5;
elseif phi == 0.48
    P = P*2;
elseif phi == 0.56
    P = P*0.2;
elseif phi == 0.59
    P = P*0.05;
end




end