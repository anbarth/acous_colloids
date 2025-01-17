myTable = readmatrix("data.csv");
stresses = myTable(1,2:end);
phis = myTable(2:end,1);
%numDataPts = (size(myTable,1)-1)*(size(myTable,2)-1);
ness_data_table = zeros(0,5);

for ii=2:size(myTable,1)
    for jj=2:size(myTable,2)
        myPhi = phis(ii-1);
        myStress = stresses(jj-1);
        myEta = myTable(ii,jj);
        if myEta < 0 || myEta > 1e5 
            continue
        end
        ness_data_table(end+1,:) = [myPhi myStress 0 myEta 0];
    end
end