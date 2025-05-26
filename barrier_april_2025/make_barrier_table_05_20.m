load("phi61_05_20.mat");

CSS = (50/19)^3;
%CSS=1;

phi61_rheo_structs = {phi61_05_20.h2_sweep,phi61_05_20.h14_sweep,phi61_05_20.h09_sweep,...
    phi61_05_20.h06_sweep,phi61_05_20.h04_sweep,phi61_05_20.h03_sweep_60s,phi61_05_20.h022_sweep_60s,...
    phi61_05_20.h016_sweep_60s,phi61_05_20.h01_sweep_60s};

% make a table with columns: gap, stress, rate, ascending (1) or desc (2)
phi61table_05_20 = zeros(0,5);
for ii=1:length(phi61_rheo_structs)
    myRheoStruct = phi61_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,10,0);
    myDescSweepTable = getStressSweep(myRheoStruct,10,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myAscSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    phi61table_05_20 = [phi61table_05_20; myAscSweepTable; myDescSweepTable];
end

% correct stress units
phi61table_05_20(:,2) = CSS*phi61table_05_20(:,2);

visco_std_rheo_structs = {visco_std_05_20.h06_sweep,visco_std_05_20.h04_sweep,visco_std_05_20.h03_sweep,...
    visco_std_05_20.h022_sweep,visco_std_05_20.h016_sweep,visco_std_05_20.h01_sweep};

% make a table with columns: gap, stress, rate, ascending (1) or desc (2)
visco_std_table_05_20 = zeros(0,5);
for ii=1:length(visco_std_rheo_structs)
    myRheoStruct = visco_std_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,5,0);
    myDescSweepTable = getStressSweep(myRheoStruct,5,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myAscSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    visco_std_table_05_20 = [visco_std_table_05_20; myAscSweepTable; myDescSweepTable];
end

% correct stress units
visco_std_table_05_20(:,2) = CSS*visco_std_table_05_20(:,2);