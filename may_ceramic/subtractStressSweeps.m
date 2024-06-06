function [sigma, delta_eta] = subtractStressSweeps(sweep2, sweep1)

sigma1 = sweep1(:,1);
eta1 = sweep1(:,2);
sigma2 = sweep2(:,1);
eta2 = sweep2(:,2);

[sigma, indices1, indices2] = intersect(sigma1,sigma2);
delta_eta = (eta2(indices2) - eta1(indices1))./eta1(indices1);

end