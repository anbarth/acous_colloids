function dataTable = getMetamaterialRows(myVolumeFractionStruct,showPlots)

%showPlots = true;
dataTable = zeros(0,5);

fn=fieldnames(myVolumeFractionStruct);
%loop through the fields
for i=1: numel(fn)
    myRheoData = myVolumeFractionStruct.(fn{i});
    for ii = 1:size(myRheoData.acous,1) 
        % skip over non-acous test (eg stress sweeps)
        if myRheoData.acous == 0
            continue
        end

        myRow = myRheoData.acous(ii,:);
        myPhi = myRow(1);
        mySigma = myRow(2);
        myVolt = myRow(3);
        myFreq = myRow(4);
        myTstart = myRow(5);
        myTend = myRow(6);

        [avg,height] = metamaterialEnvelope(myRheoData,myTstart,myTend,showPlots);
        
        dataTable(end+1,1:6) = [myPhi,mySigma,myVolt,myFreq,avg,height];
    end
    
end

end