dataTable = may_ceramic_09_17;
load("y_09_19_ratio_with_and_without_Cv.mat")
y_optimal = y_Cv;

numParams = length(y_optimal);

rangeVals = zeros(numParams,2);
rangeVals(1,:) = 0.002;
rangeVals(2,:) = 0.01;
rangeVals(3,:) = 0.4;
rangeVals(4,:) = 0.005;
rangeVals(5,:) = 0.3;
rangeVals(6:12,:) = 0.2;
rangeVals(13,:) = [1e-8 0.1];
rangeVals(14,:) = [1e-8 0.1];
rangeVals(15:17,:) = 0.1;
for ii=0:13:13*6
    rangeVals(18+ii:21+ii,:) = 0.1;
    rangeVals(22+ii,:) = [0.05 0.05];
    rangeVals(23+ii,:) = [0.05 0.05];
    rangeVals(24+ii,:) = [0.03 0.03];
    rangeVals(25+ii,:) = [0.03 0.03];
end

numPts = 11;
epsilon = zeros(numParams,numPts);
ssr = zeros(numParams,numPts);
y_list = zeros(numParams,numPts,numParams);
for kk = 1:length(y_optimal)
%for kk=64
    % skip parameters constrained to 0
    disp(kk)
    tic
    if y_optimal(kk)==0
        continue
    end
    [thisEps, thisSSR, this_y_list]=uncertainty_generic_param_3(dataTable,y_optimal,kk,rangeVals(kk,1),rangeVals(kk,2),numPts);
    epsilon(kk,:)=thisEps;
    ssr(kk,:)=thisSSR;
    y_list(kk,:,:)=this_y_list;
    %figure; plot(thisEps,thisSSR,'-o');
    save myUncertainties.mat epsilon ssr y_list
    toc
end