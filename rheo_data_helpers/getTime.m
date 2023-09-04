function time = getTime(rheoData)

timeColumn = find(strcmp(rheoData.headers,'Time'));
time = rheoData.data(:,timeColumn);

end