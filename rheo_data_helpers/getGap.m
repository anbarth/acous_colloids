function d = getGap(rheoData)

gapColumn = find(strcmp(rheoData.headers,'Gap'));

if strcmp('[mm]',rheoData.units{gapColumn})
    unitFactor = 1;
else
    unitFactor = 0;
    disp("check stress units?")
end

d = rheoData.data(:,gapColumn)*unitFactor;

end