showPlots = true;


fn=fieldnames(phi53_09_04);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi53_09_04.(fn{i});
    for ii = 1:size(myRheoData.acous,1) 
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