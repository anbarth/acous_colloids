function f_vals = flexible_f(sigma,f_params)

%f_params = x(4:end);
numSigmoids = length(f_params)/2;

f1 = @(sigma,sigmastar,k) exp(-(sigmastar./sigma).^k);

f_vals = zeros(size(sigma));


for ii=1:2:length(f_params)
    f_vals = f_vals + 1/numSigmoids*f1(sigma,f_params(ii),f_params(ii+1));
end

end