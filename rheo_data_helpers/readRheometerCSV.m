clear a;
myCells = readcell('02_20_48%.csv','Delimiter','\t');

% optionally input struct field names in order ahead of time
%structNames = {};

% find all the tests
testNameRows = find(strcmp(myCells,'Test:'));
resultNameRows = find(strcmp(myCells,'Result:'));
allNameRows = [testNameRows;resultNameRows];

% cycle through tests
for ii = 1:length(resultNameRows)
    % find my "result" row
    myRow = resultNameRows(ii);
    
    % find the corresponding "test" row
    myTestNameRow = 1;
    for jj = 1:length(testNameRows)
        if testNameRows(jj) > myRow
            break
        end
        myTestNameRow = testNameRows(jj);
    end
    
    % prompt user for struct field name
    %myStructName = strcat('unnamed',num2str(ii));
    resultName = myCells{myRow,2};
    testName = myCells{myTestNameRow,2};
    name = strcat(testName,", ",resultName);
    myStructName = input(strcat(name,": "));
    %myStructName = structNames{ii};

    % read headers and units
    headers = myCells(myRow+2,2:end);
    units = myCells(myRow+3,2:end);
    
    % this test ends where the next test begins
    if ii<length(resultNameRows)
        myEnd = min(allNameRows(allNameRows>myRow))-1;
    else
        myEnd = size(myCells,1);
    end
    myRows = myCells(myRow+1:myEnd,:);
    
    % find interval rows so we can exclude them from the numeric data  
    myIntervalRows = find(strcmp(myRows,'Interval and data points:'));
    myDataRows = true(size(myRows,1),1);
    for jj=1:size(myDataRows,1)
        % each interval row comes with 3 rows of non-data
        if any(jj == myIntervalRows) || any(jj-1 == myIntervalRows) || any(jj-2 == myIntervalRows)
            myDataRows(jj) = false;
        end
    end
    
    % pick out just the data: excluding header rows
    % also excluding first column bc it's always just blank
    myData = myRows(myDataRows,2:end);
    
    % find missing values and replace them with 0
    myMissingCells = cellfun(@ismissing,myData);
    if any(myMissingCells,'all')
        %disp("missing value(s) replaced with 0");
        myData(myMissingCells) = {0};
    end
    
    %data = cell2mat(myCells(myRow+4:myEnd,2:end));
    %data = cell2mat(myRows(myDataRows,2:end));
    data = cell2mat(myData);
    
    %a.(bigStructName).(myStructName).name = name;
    %a.(bigStructName).(myStructName).headers = headers;
    %a.(bigStructName).(myStructName).data = data;
    a.(myStructName).name = name;
    a.(myStructName).headers = headers;
    a.(myStructName).units = units;
    a.(myStructName).data = data;
end
%save('phi_v_50_cs_DPG.mat', '-struct', 'a');
return

% structNames = {'sample1_sweep'
% 'sample1_0Vtrain_60Vprobe'
% 'sample1_80Vtrain_60Vprobe'
% 'sample2_20Vtrain_60Vprobe'
% 'sample2_40Vtrain_60Vprobe'
% 'sample2_60Vtrain_60Vprobe'
% 'sample2_sweep'
% 'sample3_sweep'
% 'sample3_10Vtrain_40Vprobe'
% 'sample3_0Vtrain_60Vprobe'
% 'sample3_10Vtrain_60Vprobe'
% 'sample3_0Vtrain_80Vprobe'
% 'sample8_sweep'
% 'sample8_0Vcessation'};
