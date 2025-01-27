function [phi, sigma] = handpickedAllConstantX(dataTable,x,voltNum,paramsVector)
[eta0, phi0, delta, A, width, sigmastar, D] = unzipParamsHandpickedAll(paramsVector,13); 
%V = 0;
%volt_list = [0 5 10 20 40 60 80];

phi = unique(dataTable(:,1));
%dphi = phi0-phi;
D = D(:,voltNum);
Q = 1./D;

finv = @(y) y*sigmastar(voltNum)./(1-y);
sigma = finv(x*Q);

phi = phi(sigma>0);
sigma = sigma(sigma>0);

end