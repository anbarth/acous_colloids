function phi = invD(my_D,D,phi_list,phi0,D0,alpha)

    if my_D < min(D)
        phi=NaN;
    elseif my_D <= max(D)
        phi= interp1(D,phi_list,my_D);
    else
        phi = phi0 - (my_D/D0)^(-1/alpha);
    end

end