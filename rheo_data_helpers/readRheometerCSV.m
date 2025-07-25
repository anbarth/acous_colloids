clear a;
myCells = readcell('07_16_2025_phi61_barrier.csv','Delimiter','\t');

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
    
    data = cell2mat(myData);
    
    a.(myStructName).name = name;
    a.(myStructName).headers = headers;
    a.(myStructName).units = units;
    a.(myStructName).data = data;
end