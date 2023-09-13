function dataTable = fillDataTable(dataTable,lookupTable,rheoData,phi,V,sigma)

myT = lookupTable(lookupTable(:,1)==phi & lookupTable(:,2)==V & lookupTable(:,3)==sigma,4);

if myT == 0
    % if myT==0, that means there was no dethickening
    % use the baseline viscosity for the data table
    % that should already be an earlier entry in data table
   eta = dataTable(dataTable(:,1)==phi & dataTable(:,2)==0 & dataTable(:,3)==sigma,4);
else
    eta = getDethickenedViscosityWrapper(rheoData,myT,myT+10);
end

dataTable(end+1,1:4) = [phi,V,sigma,eta];

end