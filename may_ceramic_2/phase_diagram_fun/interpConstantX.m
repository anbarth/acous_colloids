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
    if my_D < min(D)
        phi(ii)=NaN;
    elseif my_D <= max(D)
        phi(ii) = interp1(D,phi_list,my_D);
    else
        phi(ii) = phi0 - (my_D/D0)^(-1/alpha);
    end
end

end
