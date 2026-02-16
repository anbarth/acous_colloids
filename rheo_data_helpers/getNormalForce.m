function N = getNormalForce(rheoData)

normalColumn = find(strcmp(rheoData.headers,'Normal Force'));

if strcmp('[N]',rheoData.units{normalColumn})
    unitFactor = 1;
else
    unitFactor = 0;
    disp("check N units?")
end



N = rheoData.data(:,normalColumn)*unitFactor;

end