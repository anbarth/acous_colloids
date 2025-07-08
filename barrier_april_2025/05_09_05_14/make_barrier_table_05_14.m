load("phi61_05_14.mat");

CSS = (50/19)^3;
%CSS=1;
CSR = 1/(50/19);

phi61_rheo_structs = {phi61_05_14.h2_sweep, phi61_05_14.h14_sweep, phi61_05_14.h09_sweep, ...
    phi61_05_14.h06_sweep, phi61_05_14.h04_sweep, phi61_05_14.h03_sweep, phi61_05_14.h022_sweep_45s, ...
    phi61_05_14.h016_sweep, phi61_05_14.h01_sweep_60s};

% make a table with columns: gap, stress, rate, ascending (1) or desc (2)
phi61table_05_14 = zeros(0,5);
for ii=1:length(phi61_rheo_structs)
    myRheoStruct = phi61_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,10,0);
    myDescSweepTable = getStressSweep(myRheoStruct,10,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myAscSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    phi61table_05_14 = [phi61table_05_14; myAscSweepTable; myDescSweepTable];
end

% correct stress units
phi61table_05_14(:,2) = CSS*phi61table_05_14(:,2);
phi61table_05_14(:,3) = CSR*phi61table_05_14(:,3);