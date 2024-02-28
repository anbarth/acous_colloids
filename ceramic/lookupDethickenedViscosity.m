function eta = lookupDethickenedViscosity(phi,sigma,V,allData)

% allData should be something like {phi48,phi53...}
for ii = 1:length(allData)
    % rheoStructSet is something like phi48
    rheoStructSet = allData{ii};
    fn=fieldnames(rheoStructSet);
    %loop through the fields
    for jj = 1:numel(fn)
        % myRheoData is something like phi48.sig10_60V
        myRheoData = rheoStructSet.(fn{jj});
        %disp(myRheoData)
        if myRheoData.acous == 0
            continue
        end
        
        for kk = 1:size(myRheoData.acous,1) 
            myRow = myRheoData.acous(kk,:);
            myPhi = myRow(1);
            mySigma = myRow(2);
            myVolt = myRow(3);
            myT = myRow(4);
    
            if myPhi == phi && mySigma == sigma && myVolt == V
                % found the entry you asked for!
                eta = getAcousticViscosity(myRheoData,myT,true);
                return;
            end
        end

    end

end

% failure :(
eta = -1;