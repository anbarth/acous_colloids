% these are all with the pie slice plate or the pp
load('metamaterial_data_07_16.mat')

CSS = (50/19)^3;
CSR = 1/(50/19);
%CSS=1;

pp_rheo_structs = {pp_mm_07_16.d2_sweep,pp_mm_07_16.d09_sweep,pp_mm_07_16.d04_sweep,pp_mm_07_16.d022_sweep};

% make a table with columns: gap, stress, rate, delta rate, ascending (1) or desc (2)
phi61table_pp_07_16 = zeros(0,5);
for ii=1:length(pp_rheo_structs)
    myRheoStruct = pp_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,10,0);
    myDescSweepTable = getStressSweep(myRheoStruct,10,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myDescSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    phi61table_pp_07_16 = [phi61table_pp_07_16; myAscSweepTable; myDescSweepTable];
end

% correct stress units
phi61table_pp_07_16(:,2) = CSS*phi61table_pp_07_16(:,2);
phi61table_pp_07_16(:,3) = CSR*phi61table_pp_07_16(:,3);





barrier_rheo_structs = {barrier_mm_07_16.h2_sweep,barrier_mm_07_16.h09_sweep,barrier_mm_07_16.h04_sweep,barrier_mm_07_16.h022_sweep};

% make a table with columns: gap, stress, rate, delta rate, ascending (1) or desc (2)
phi61table_barrier_07_16 = zeros(0,5);
for ii=1:length(barrier_rheo_structs)
    myRheoStruct = barrier_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,10,0);
    myDescSweepTable = getStressSweep(myRheoStruct,10,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myDescSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    phi61table_barrier_07_16 = [phi61table_barrier_07_16; myAscSweepTable; myDescSweepTable];
end

% correct stress units
phi61table_barrier_07_16(:,2) = CSS*phi61table_barrier_07_16(:,2);
phi61table_barrier_07_16(:,3) = CSR*phi61table_barrier_07_16(:,3);