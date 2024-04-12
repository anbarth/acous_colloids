function dataTable = getAcousDataTableRows(myVolumeFractionStruct,showPlots)

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
        myT = myRow(4);

        [eta,delta_eta,sloppy] = getAcousticViscosity(myRheoData,myT,showPlots);
        if sloppy
            continue
        end
        
        dataTable(end+1,1:5) = [myPhi,mySigma,myVolt,eta,delta_eta];
    end
    
end

end