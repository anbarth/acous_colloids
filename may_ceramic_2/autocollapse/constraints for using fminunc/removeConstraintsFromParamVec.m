function yRestricted = removeConstraintsFromParamVec(y,constraints)

yRestricted = zeros(1,sum(isnan(constraints)));
counter = 1;
for ii=1:length(constraints)
    if isnan(constraints(ii))
        yRestricted(counter) = y(ii);
        counter = counter+1;
    end
end

end