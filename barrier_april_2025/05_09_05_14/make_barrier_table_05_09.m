load("phi55_05_09.mat");
load("visco_std_05_09.mat");

CSS = (50/19)^3;
%CSS=1;

phi55_rheo_structs = {phi55_05_09.h2_sweep,phi55_05_09.h14_sweep,phi55_05_09.h09_sweep,...
    phi55_05_09.h06_sweep,phi55_05_09.h04_sweep,phi55_05_09.h03_sweep,phi55_05_09.h022_sweep,...
    phi55_05_09.h016_sweep,phi55_05_09.h01_sweep};

% make a table with columns: gap, stress, rate, ascending (1) or desc (2)
phi55table_05_09 = zeros(0,5);
for ii=1:length(phi55_rheo_structs)
    myRheoStruct = phi55_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,10,0);
    myDescSweepTable = getStressSweep(myRheoStruct,10,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myAscSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    phi55table_05_09 = [phi55table_05_09; myAscSweepTable; myDescSweepTable];
end

viscostd_rheo_structs = {visco_std_05_09.h09_sweep,visco_std_05_09.h06_sweep,visco_std_05_09.h04_sweep,...
    visco_std_05_09.h03_sweep,visco_std_05_09.h022_sweep,visco_std_05_09.h016_sweep,visco_std_05_09.h01_sweep};
viscostdtable_05_09 = zeros(0,5);
for ii=1:length(viscostd_rheo_structs)
    myRheoStruct = viscostd_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,5,0);
    myDescSweepTable = getStressSweep(myRheoStruct,5,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myAscSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    viscostdtable_05_09 = [viscostdtable_05_09; myAscSweepTable; myDescSweepTable];
end

% correct stress units
phi55table_05_09(:,2) = CSS*phi55table_05_09(:,2);
viscostdtable_05_09(:,2) = CSS*viscostdtable_05_09(:,2);

