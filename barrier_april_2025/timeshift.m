function newRheoStruct = timeshift(rheoStruct,shift)

timeColumn = find(strcmp(rheoStruct.headers,'Time'));
time = rheoStruct.data(:,timeColumn);
newTime = time+shift;

newRheoStruct=rheoStruct;
newRheoStruct.data(:,timeColumn)=newTime;

end