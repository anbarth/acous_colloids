showPlots = true;


fn=fieldnames(phi56_02_21);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi56_02_21.(fn{i});
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

        eta = getAcousticViscosity(myRheoData,myT,showPlots);
        
        dataTable(end+1,1:4) = [myPhi,mySigma,myVolt,eta];
    end
    
end