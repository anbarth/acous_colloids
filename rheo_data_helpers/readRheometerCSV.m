clear a;
myCells = readcell('CP_new_silica/9_4_phi_53.csv','Delimiter','\t');


%structNames = {};
testNameRows = find(strcmp(myCells,'Test:'));
resultNameRows = find(strcmp(myCells,'Result:'));
allNameRows = [testNameRows;resultNameRows];
for ii = 1:length(resultNameRows)
    myRow = resultNameRows(ii);
    myTestNameRow = 1;
    for jj = 1:length(testNameRows)
        if testNameRows(jj) > myRow
            break
        end
        myTestNameRow = testNameRows(jj);
    end
    
    %myStructName = strcat('unnamed',num2str(ii));
    resultName = myCells{myRow,2};
    testName = myCells{myTestNameRow,2};
    name = strcat(testName,", ",resultName);
    myStructName = input(strcat(name,": "));
    %myStructName = structNames{ii};
    %disp(name);
    headers = myCells(myRow+2,2:end);
    units = myCells(myRow+3,2:end);
    if ii<length(resultNameRows)
        % hmmm so this is tricky bc sometimes the stopping point is a Test:
        % row and sometimes it's a Result: row... so how do i know where to
        % stop? (current solution seems to work)
        %myEnd = resultNameRows(ii+1)-1;
        myEnd = min(allNameRows(allNameRows>myRow))-1;
    else
        myEnd = size(myCells,1);
    end
    data = cell2mat(myCells(myRow+4:myEnd,2:end));
    
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
%54
{'sig160_100V'
'sig05_100V_rep3'
'sig05_100V_rep1_rep2'
'sig40_100V_rep1'
'sig40_100V_rep2'
'sig40_100V_rep3'
'sig40_5V_10s_application'
'sig40_varyfreq'
'sig1_5to60V'
'sig1_80to100V'
'sig1_100V_2'
'sig3_5to60V'
'sig3_80to100V'
'sig5_5to40V'
'sig5_60V'
'sig5_80V'
'sig5_100V'
'sig003'
'sig0045'
'sig006_5to40V'
'sig006_60to80V'
'sig009_5to80V'
'sig009_100V'
'sig015_5to60V'
'sig015_80to100V'
'sig03_5to80V'
'sig03_100V'
'sig05_5to40V'
'sig05_80V_60V_100V'
'sig075_5to60V_20V_10V'
'sig075_80to100V'
'sig2_5to80V'
'sig2_100V'
'sig8_5to60V'
'sig8_80to100V'
'sig20_5to40V'
'sig20_60V'
'sig20_80V'
'sig20_100V'
'sig40_5to40V'
'sig40_60V'
'sig40_80V'
'sig40_100V'
'sig80_5to40V'
'sig80_60to80V'
'sig80_100V'
'sig160_5to60V'
'sig160_80V'};

% 48
{'sig80'
'sig20_31p25V_10s_application'
'sig20_31p25V_rep'
'sig05_31p25V_rep'
'sig05_100V_rep'
'sig20_100V_rep'
'sig003'
'sig0045'
'sig006_5to80V'
'sig006_100V'
'sig009'
'sig015'
'sig03'
'sig5_5to60V'
'sig5_80to100V'
'sig05_5to80V'
'sig05_100V'
'sig075_5to60V'
'sig075_80to100V'
'sig1_5to80V'
'sig1_100V'
'sig2_5to40V_80V'
'sig2_60V_100V'
'sig3_5to40V'
'sig3_60to100V'
'sig8_5to60V'
'sig8_60to100V'
'sig20_5to40V'
'sig20_60to80V'
'sig20_100V'
'sig40_5to60V'
'sig40_80to100V'};

% 44
{'sig20_100V'
'sig10_10s_application'
'sig10_varyfreq'
'sig10_100V_rep1'
'sig10_100V_rep2'
'sig10_100V_rep3'
'sig10_100V_rep4'
'sig05_100V_rep1'
'sig05_100V_rep2'
'sig05_100V_rep3'
'sig05_10s_application_5V'
'sig003_5to40V'
'sig003_60to100V'
'sig0045_5to100V'
'sig006'
'sig009'
'sig05_5to60V'
'sig05_80V'
'sig05_100V'
'sig075_5to40V'
'sig075_60V'
'sig075_80V'
'sig075_100V'
'sig1_5to40V'
'sig1_60V'
'sig1_80V'
'sig1_100V'
'sig2_5to40V'
'sig2_60to80V'
'sig2_100V'
'sig3_5to40V'
'sig3_60to80V'
'sig3_100V'
'sig5p5_5to40V'
'sig5p5_60to80V'
'sig5p5_100V'
'sig015'
'sig015_100V'
'sig015_60V'
'sig03_5to20V'
'sig03_40V_20V'
'sig03_60V_80V'
'sig03_100V'
'sig10_5V'
'sig10_10to40V'
'sig10_60V'
'sig10_80V'
'sig10_100V'
'sig20_5to20V'
'sig20_40V'
'sig20_60V'
'sig20_80V'};

% 30
{'steady003Pa'
'steady001Pa'
'steady01Pa'
'steady03Pa'
'steady1Pa'
'steady03Pa_2'
'steady3Pa'}
