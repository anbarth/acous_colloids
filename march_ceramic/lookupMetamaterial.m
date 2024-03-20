function [avg,height] = lookupMetamaterial(phi,sigma,freq,allData)

% allData should be something like {phi48,phi53...}
for ii = 1:length(allData)
    % rheoStructSet is something like phi48
    rheoStructSet = allData{ii};
    fn=fieldnames(rheoStructSet);
    %loop through the fields
    for jj = 1:numel(fn)
        % myRheoData is something like phi48.sig10_60V
        myRheoData = rheoStructSet.(fn{jj});
        if myRheoData.acous == 0
            continue
        end
        
        for kk = 1:size(myRheoData.acous,1) 
            myRow = myRheoData.acous(kk,:);
            myPhi = myRow(1);
            mySigma = myRow(2);
            myFreq = myRow(4);
    
            if myPhi == phi && mySigma == sigma && myFreq == freq
                % found the entry you asked for!
                myTstart = myRow(5);
                myTend = myRow(6);
                [avg,height] = metamaterialEnvelope(myRheoData,myTstart,myTend,true,myPhi);
                return
            end
        end

    end

end

% failure :(
avg = -1;
height = -1;