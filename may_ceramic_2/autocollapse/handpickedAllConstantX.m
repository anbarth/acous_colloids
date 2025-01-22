function [phi, sigma] = handpickedAllConstantX(dataTable,x,paramsVector)
[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(paramsVector,13); 
V = 0;

phi = unique(dataTable(:,1));
%dphi = phi0-phi;
D = D(:,1);
Q = 1./D;

finv = @(y) y*sigmastar(1)./(1-y);
sigma = finv(x*Q);

phi = phi(sigma>0);
sigma = sigma(sigma>0);

end