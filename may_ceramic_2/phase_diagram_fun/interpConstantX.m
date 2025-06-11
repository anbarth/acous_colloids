function phi = interpConstantX(x,sigma,phi0,sigmastar,D,alpha,D0,phi_list)
% model must be modelHandpickedAllExp0V

%phi0 = paramsVector(2);
%sigmastar = paramsVector(6);
%D = paramsVector(7:end);
f = @(sigma) exp(-sigmastar./sigma);

%sigma = logspace(-3,3)';
phi = zeros(size(sigma));
for ii=1:length(sigma)
    my_D = x/f(sigma(ii));
    %disp(my_D)
    phi(ii) = invD(my_D,D,phi_list,phi0,D0,alpha);
end

end
