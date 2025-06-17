function phi = invD(my_D,D,phi_list,phi0,D0,alpha)

phi = zeros(size(my_D));
for i=1:length(my_D)
    if my_D(i) < min(D)
        phi(i)=NaN;
    elseif my_D(i) <= max(D)
        phi(i)= interp1(D,phi_list,my_D(i));
    else
        phi(i) = phi0 - (my_D(i)/D0)^(-1/alpha);
    end
end

end