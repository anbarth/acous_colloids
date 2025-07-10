load("phi55_flat_07_08.mat");


CSS = (50/19)^3;
CSR = 1/(50/19);
%CSS=1;

phi55_rheo_structs = {phi55_flat_07_08.d2_sweep,phi55_flat_07_08.d15_sweep,...
    phi55_flat_07_08.d125_sweep,phi55_flat_07_08.d1_sweep,...
    phi55_flat_07_08.d075_sweep,phi55_flat_07_08.d05_sweep,...
    phi55_flat_07_08.d025_sweep,phi55_flat_07_08.d01_sweep};

% make a table with columns: gap, stress, rate, ascending (1) or desc (2)
phi55_flat_table_07_08 = zeros(0,5);
for ii=1:length(phi55_rheo_structs)
    myRheoStruct = phi55_rheo_structs{ii};
    myAscSweepTable = getStressSweep(myRheoStruct,10,0);
    myDescSweepTable = getStressSweep(myRheoStruct,10,1);
    
    % data table: [gap, stress, rate, delta rate, asc (1) or desc (2)]
    myData = myRheoStruct.data;
    gap = round(mean(myData(:,6)),3);
    myAscSweepTable = [gap*ones(size(myAscSweepTable,1),1), myAscSweepTable, ones(size(myAscSweepTable,1),1)];
    myDescSweepTable = [gap*ones(size(myDescSweepTable,1),1), myDescSweepTable, 2*ones(size(myDescSweepTable,1),1)];

    phi55_flat_table_07_08 = [phi55_flat_table_07_08; myAscSweepTable; myDescSweepTable];
end

% correct stress units
phi55_flat_table_07_08(:,2) = CSS*phi55_flat_table_07_08(:,2);
phi55_flat_table_07_08(:,3) = CSR*phi55_flat_table_07_08(:,3);

datatable = phi55_flat_table_07_08;

% plot stress sweeps for each d
dList = unique(datatable(:,1)); minD = min(dList); maxD = max(dList);
cmap=viridis(256);
dColor = @(d) cmap(round(1+255*(d-minD)/(maxD-minD)),:);

figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pas)')
colormap(cmap)
c1=colorbar;
clim([minD maxD])
c1.Ticks = dList;

%for ii=1
for ii=1:length(dList)
    d = dList(ii);
    myData = datatable(:,1)==d; % & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    c = dColor(d);
    %c=hColor(h);
    %plot(stress,rate,'-o','Color',c);
    plot(rate,stress./rate,'-o','Color',c);

    %myNewtonianEta = newtonianEtaVsH_05_20(hList==h);
    %plot(stress,stress./rate*5.034/myNewtonianEta,'-o','Color',c);
end
prettyplot

% stress_in_dataset = datatable(:,2);
% myStress = logspace(log10(min(stress_in_dataset)),1.2*log10(max(stress_in_dataset)));
% myRatesRef = phi61_ref_rate(myStress);
% plot(myRatesRef,myStress./myRatesRef,'r-')
