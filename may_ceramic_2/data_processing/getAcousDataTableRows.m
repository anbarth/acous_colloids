function [dataTable,dateTimeList] = getAcousDataTableRows(myVolumeFractionStruct,showPlots)

%showPlots = true;
dataTable = zeros(0,6);
dateTimeList = NaT(0,1);

fn=fieldnames(myVolumeFractionStruct);
%loop through the fields
for i=1:numel(fn)
    myRheoData = myVolumeFractionStruct.(fn{i});
    % skip over non-acous test (eg stress sweeps)
    if myRheoData.acous == 0
        continue
    end
    
    for ii = 1:size(myRheoData.acous,1) 
        myRow = myRheoData.acous(ii,:);
        myPhi = myRow(1);
        mySigma = myRow(2);
        myVolt = myRow(3);
        myT = myRow(4);
        myDatetime = myRheoData.datetime(1);

        [eta,delta_eta,baseline_eta,sloppy] = getAcousticViscosity(myRheoData,myT,showPlots);
        if sloppy
            continue
        end
        
        dataTable(end+1,1:6) = [myPhi,mySigma,myVolt,eta,delta_eta,baseline_eta];
        dateTimeList(end+1,1) = myDatetime;
    end
end

% now cycle thru the rows and for eta=-1 (no dethickening noticeable)
% fill in the 0V value
for ii=1:size(dataTable,1)
    mySigma = dataTable(ii,2);
    myDethickenedEta = dataTable(ii,4);
    if myDethickenedEta == -1
        eta_0V = dataTable(dataTable(:,2)==mySigma & dataTable(:,3)==0,4);
        delta_eta_0V = dataTable(dataTable(:,2)==mySigma & dataTable(:,3)==0,5);
        dataTable(ii,4) = eta_0V;
        dataTable(ii,5) = delta_eta_0V;
        dataTable(ii,6) = eta_0V;
    end
end

% now cycle thru the rows and eject anything where
% the baseline value has deviated more than 10%
for ii=size(dataTable,1):-1:1
    mySigma = dataTable(ii,2);
    myBaseline = dataTable(ii,6);
    myDethickenedEta = dataTable(ii,4);
    myCorrectBaseline = dataTable(dataTable(:,2)==mySigma & dataTable(:,3)==0,4);
    if abs(myBaseline-myCorrectBaseline) > 0.25*myDethickenedEta
        dataTable(ii,:) = [];
        dateTimeList(ii) = [];
    end
end

dataTable = dataTable(:,1:5);

% for low stresses, no dethickening occurs
% fill in the higher-V values?
% did NOT use this for final dataset
% sigmaList = unique(dataTable(:,2));
% myPhi = dataTable(1,1);
% voltages = [5;10;20;40;60;80];
% for kk=1:length(sigmaList)
%     sigma = sigmaList(kk);
%     if sigma > 0.03
%         continue
%     end
%     eta = dataTable(dataTable(:,2)==sigma & dataTable(:,3)==0,4);
%     delta_eta = dataTable(dataTable(:,2)==sigma & dataTable(:,3)==0,5);
%     extraData = [myPhi*ones(size(voltages)), sigma*ones(size(voltages)), voltages, eta*ones(size(voltages)), delta_eta*ones(size(voltages))];
%     dataTable = [dataTable; extraData];
% end

end