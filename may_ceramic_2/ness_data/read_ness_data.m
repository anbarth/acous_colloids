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
        if myPhi == 0.64
            continue
        end
        if myEta < 0 || myEta > 1e6 
            etaPreviousStress = myTable(ii,jj-1);
            if myEta>0 && etaPreviousStress > 0 && etaPreviousStress < 1e6
                ness_data_table(end+1,:) = [myPhi myStress 0 myEta 0];
            end
            continue
        end
        ness_data_table(end+1,:) = [myPhi myStress 0 myEta 0];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chris says to disregard these data because the softness might be
% affecting the critical behavior

myTable2 = readmatrix("data_phi63.5.csv");
stresses = myTable2(1,2:end);
phis = myTable2(2:end,1);

for ii=2:size(myTable2,1)
    for jj=2:size(myTable2,2)
        myPhi = phis(ii-1);
        myStress = stresses(jj-1);
        myEta = myTable2(ii,jj);
        if myEta < 0 || myEta > 1e6 
            if abs(0.0081-myStress)<0.00001
                ness_data_table(end+1,:) = [myPhi myStress 0 myEta 0];
            end
            continue
        end
        ness_data_table(end+1,:) = [myPhi myStress 0 myEta 0];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chris says to disregard these data because the softness might be
% affecting the critical behavior

myTable2 = readmatrix("data_phi64.csv");
stresses = myTable2(1,2:end);
phis = myTable2(2:end,1);

for ii=2:size(myTable2,1)
    for jj=2:size(myTable2,2)
        myPhi = phis(ii-1);
        myStress = stresses(jj-1);
        myEta = myTable2(ii,jj);
        if myEta < 0 || myEta > 1e6 
            etaPreviousStress = myTable2(ii,jj-1);
            if abs(myStress-0.0316) <= 0.0001
                ness_data_table(end+1,:) = [myPhi myStress 0 myEta 0];
            end
            continue
        end
        ness_data_table(end+1,:) = [myPhi myStress 0 myEta 0];
    end
end