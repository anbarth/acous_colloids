clear a;
myCells = readcell('06_21_2025_barrier.csv','Delimiter','\t');

% optionally input struct field names in order ahead of time
structNames = {};

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
    if isnumeric(resultName)
        resultName = num2str(resultName);
    end
    testName = myCells{myTestNameRow,2};
    name = strcat(testName,", ",resultName);
    %myStructName = input(strcat(name,": "));
    if ii <= length(structNames)
        myStructName = structNames{ii};
    else
        myStructName = input(strcat(name,": "));
    end

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
    if size(myData,1)==0
        continue
    end
    
    % find 'invalid' points and remove them (this is listed in the
    % first column, which i assume to be point no.)
    myInvalidRows = ~cellfun(@isnumeric,myData(:,1));
    myData(myInvalidRows,:)=[];
    
    % find missing values and replace them with 0
    myMissingCells = cellfun(@ismissing,myData);
    myData(myMissingCells) = {0};


    % SO niche but this column has non-numeric (datetime) entries
    % and so it has to be dealt with separately smh
    if find(strcmp(headers,'Time of Day'))
        % extract the datetime column and store it in its own field
        datetime_index = find(strcmp(headers,'Time of Day'));
        datetime_cells = myData(:,datetime_index);
        datetime_column = NaT(size(datetime_cells));
        for jj=1:length(datetime_column)
            datetime_column(jj) = datetime_cells{jj};
        end
        a.(myStructName).datetime = datetime_column;

        % remove the offending column from other places
        myData(:,datetime_index) = [];
        headers(datetime_index) = [];
        units(datetime_index) = [];
    end
    
    %data = cell2mat(myCells(myRow+4:myEnd,2:end));
    %data = cell2mat(myRows(myDataRows,2:end));
    data = cell2mat(myData);
    
    a.(myStructName).name = name;
    a.(myStructName).headers = headers;
    a.(myStructName).units = units;
    a.(myStructName).data = data;
end



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

% structNames = {'phi44_stress_sweep'
% 'phi44_sig02_cess'
% 'phi44_sig02_rev'
% 'phi44_sig2_cess'
% 'phi44_sig2_rev'
% 'phi44_sig20_cess'
% 'phi44_sig20_rev'
% 'phi59_stress_sweep_init'
% 'phi59_stress_sweep'
% 'phi59_sig05_0V_cess'
% 'phi59_sig05_0V_rev'
% 'phi59_sig1_0V_cess'
% 'phi59_sig1_0V_rev'
% 'phi59_sig1p2_0V_cess'
% 'phi59_sig1p2_0V_rev'
% 'phi59_sig2_40V_cess'
% 'phi59_sig2_40V_rev'
% 'phi59_sig4p6_40V_cess'
% 'phi59_sig4p6_40V_rev'
% 'phi59_sig4p6_0V_cess'
% 'phi59_sig4p6_0V_rev'
% 'phi59_sig5p6_40V_badreversal'
% 'phi59_sig5p6_40V_cess'
% 'phi59_sig5p6_0V_cess'
% 'phi59_sig5p6_40V_rev'
% 'phi59_stress_sweep_2hr'
% 'phi59_sig5p6_0V_rev'};

% structNames = {'batch1_sample4_sponges_2_low_1'
% 'batch1_sample4_sponges_2_sweep_1'
% 'batch1_sample4_sponges_2_long_1'
% 'batch1_sample4_sponges_2_low_2'
% 'batch1_sample4_sponges_2_sweep_2'
% 'batch1_sample4_sponges_2_long_2'
% 'batch1_sample4_sponges_2_low_3'
% 'batch1_sample4_sponges_2_sweep_3'
% 'batch1_sample4_sponges_2_long_3'
% 'batch1_sample4_sponges_2_low_4'
% 'batch1_sample4_sponges_2_sweep_4'
% 'batch1_sample4_sponges_2_long_4'
% 'batch1_sample4_sponges_2_low_5'
% 'batch1_sample4_sponges_2_sweep_5'
% 'batch1_sample4_sponges_2_long_5'
% 'batch1_sample4_sponges_2_low_6'
% 'batch1_sample4_sponges_2_sweep_6'
% 'batch1_sample4_sponges_2_long_6'
% 'batch1_sample4_sponges_2_low_7'
% 'batch1_sample4_sponges_2_sweep_7'
% 'batch1_sample4_sponges_2_long_7'
% 'batch1_sample4_sponges_2_low_8'
% 'batch1_sample4_sponges_2_sweep_8'
% 'batch1_sample4_sponges_2_long_8'
% 'batch1_sample4_sponges_2_low_9'
% 'batch1_sample4_sponges_2_sweep_9'
% 'batch1_sample4_sponges_2_long_9'
% 'batch1_sample1_low_1'
% 'batch1_sample1_sweep_1'
% 'batch1_sample1_long_1'
% 'batch1_sample1_low_2'
% 'batch1_sample1_sweep_2'
% 'batch1_sample1_long_2'
% 'batch1_sample1_low_3'
% 'batch1_sample1_sweep_3'
% 'batch1_sample1_long_3'
% 'batch1_sample1_low_4'
% 'batch1_sample1_sweep_4'
% 'batch1_sample1_long_4'
% 'batch1_sample1_low_5'
% 'batch1_sample1_sweep_5'
% 'batch1_sample1_long_5'
% 'batch1_sample1_low_6'
% 'batch1_sample1_sweep_6'
% 'batch1_sample1_long_6'
% 'batch1_sample2_low_1'
% 'batch1_sample2_sweep_1'
% 'batch1_sample2_long_1'
% 'batch1_sample2_low_2'
% 'batch1_sample2_sweep_2'
% 'batch1_sample2_long_2'
% 'batch1_sample2_low_3'
% 'batch1_sample2_sweep_3'
% 'batch1_sample2_long_3'
% 'batch1_sample2_low_4'
% 'batch1_sample2_sweep_4'
% 'batch1_sample2_long_4'
% 'batch1_sample2_low_5'
% 'batch1_sample2_sweep_5'
% 'batch1_sample2_long_5'
% 'batch1_sample3_low_1'
% 'batch1_sample3_sweep_1'
% 'batch1_sample3_long_1'
% 'batch1_sample3_low_2'
% 'batch1_sample3_sweep_2'
% 'batch1_sample3_long_2'
% 'batch1_sample3_low_3'
% 'batch1_sample3_sweep_3'
% 'batch1_sample3_long_3'
% 'batch1_sample3_low_4'
% 'batch1_sample3_sweep_4'
% 'batch1_sample3_long_4'
% 'batch1_sample3_low_5'
% 'batch1_sample3_sweep_5'
% 'batch1_sample3_long_5'
% 'batch1_sample4_sponges_low_1'
% 'batch1_sample4_sponges_sweep_1'
% 'batch1_sample4_sponges_long_1'
% 'batch1_sample4_sponges_low_2'
% 'batch1_sample4_sponges_sweep_2'
% 'batch1_sample4_sponges_long_2'
% 'batch1_sample4_sponges_low_3'
% 'batch1_sample4_sponges_sweep_3'
% 'batch1_sample4_sponges_long_3'
% 'batch1_sample4_sponges_low_4'
% 'batch1_sample4_sponges_sweep_4'
% 'batch1_sample4_sponges_long_4'
% 'batch1_sample4_sponges_low_5'
% 'batch1_sample4_sponges_sweep_5'
% 'batch1_sample4_sponges_long_5'
% 'batch1_sample5_low_1'
% 'batch1_sample5_sweep_1'
% 'batch1_sample5_long_1'
% 'batch1_sample5_low_2'
% 'batch1_sample5_sweep_2'
% 'batch1_sample5_long_2'
% 'batch1_sample5_low_3'
% 'batch1_sample5_sweep_3'
% 'batch1_sample5_long_3'
% 'batch1_sample5_low_4'
% 'batch1_sample5_sweep_4'
% 'batch1_sample5_long_4'
% 'batch1_sample5_low_5'
% 'batch1_sample5_sweep_5'
% 'batch1_sample5_long_5'};


% {'phi44_sweep1'
% 'phi44_sig002'
% 'phi44_sig002_rev'
% 'phi44_sig002_stress_cess'
% 'phi44_sig002_rate_cess'
% 'phi44_sweep2'
% 'phi44_sig10'
% 'phi44_sig001'
% 'phi44_sig10_rev'
% 'phi44_sig10_stress_cess'
% 'phi44_sig10_rate_cess'
% 'phi44_sweep3'
% 'phi44_sig05'
% 'phi44_sig05_rev'
% 'phi44_sig05_stress_cess'
% 'phi44_sig05_rate_cess'
% 'phi61_low_sweep1'
% 'phi61_sweep1'
% 'phi61_sig001'
% 'phi61_sig002'
% 'phi61_sig002_rev'
% 'phi61_sig002_stress_cess'
% 'phi61_sig002_rate_cess'
% 'phi61_sweep2'
% 'phi61_sig015'
% 'phi61_sig015_rev'
% 'phi61_sig015_stress_cess'
% 'phi61_sig015_rate_cess'
% 'phi61_sweep3'
% 'phi61_sig009'
% 'phi61_sig009_rev'
% 'phi61_sig009_stress_cess'
% 'phi61_sig009_rate_cess'
% 'phi61_sweep4'
% 'phi61_sig01_60V'
% 'phi61_sig01_60V_rev'
% 'phi61_sig01_60V_stress_cess'
% 'phi61_sig01_60V_rate_cess'
% 'phi61_sweep5'
% 'phi61_sig05_60V'
% 'phi61_sig05_60V_rev'
% 'phi61_sig05_60V_stress_cessation_bad_timing'
% 'phi61_sig05_60V_stress_cessation'
% 'phi61_sig05_60V_rate_cessation'
% 'phi61_sweep6'
% 'phi61_sig07_60V'
% 'phi61_sig07_60V_rev_bad'
% 'phi61_sig07_60V_stress_cess'
% 'phi61_sig07_60V_rev'
% 'phi61_sig07_60V_rate_cess'
% 'phi61_sweep7'
% 'phi61_sig50_60V_stress_cessation'
% 'phi61_sig5'
% 'phi61_sig5_stress_cessation'};
