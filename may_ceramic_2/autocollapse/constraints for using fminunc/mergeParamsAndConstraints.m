function y = mergeParamsAndConstraints(yRestricted,constraints)

y = constraints;
counter = 1;
for ii=1:length(y)
    if isnan(y(ii))
        y(ii) = yRestricted(counter);
        counter = counter+1;
    end
end

end