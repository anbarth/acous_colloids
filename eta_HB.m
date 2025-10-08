function eta = eta_HB(sigma,sigma_y,k,n)

if sigma > sigma_y
    eta = k*sigma*(sigma-sigma_y)^(-1/n);
else
    eta = Inf;
end

end