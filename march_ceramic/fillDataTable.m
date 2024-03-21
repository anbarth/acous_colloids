% run these individually with showPlots set to true to check that the
% automated part is working correctly
phi52_rows = getAllDataTableRows(phi52_03_18,phi52_03_18.low_sweep_30min,0.52,false);
phi44_rows = getAllDataTableRows(phi44_03_19,phi44_03_19.low_sweep_init,0.44,false);
phi59_rows = getAllDataTableRows(phi59_03_20,phi59_03_20.low_sweep_init,0.59,false);


clear dataTable
dataTable = [phi44_rows;phi52_rows;phi59_rows];