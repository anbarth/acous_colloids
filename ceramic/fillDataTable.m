% run these individually with showPlots set to true to check that the
% automated part is working correctly
phi30_rows = getStressSweepDataTableRows(phi30_02_19.stress_sweep,0.3,[]);
phi40_rows = getAllDataTableRows(phi40_02_20,phi40_02_20.stress_sweep_low_init,0.4,false);
phi44_rows = getAllDataTableRows(phi44_02_21,phi44_02_21.stress_sweep_low_init,0.44,false);
phi48_rows = getAllDataTableRows(phi48_02_20,phi48_02_20.stress_sweep_low_init,0.48,false);
phi52_rows = getAllDataTableRows(phi52_02_23,phi52_02_23.stress_sweep_low_1hr,0.52,false);
phi56_rows = getAllDataTableRows(phi56_02_21,phi56_02_21.stress_sweep_low_init,0.56,false);
phi59_rows = getAllDataTableRows(phi59_02_22,phi59_02_22.stress_sweep_low_init,0.59,false);

clear dataTable
dataTable = [phi30_rows;phi40_rows;phi44_rows;phi48_rows;phi52_rows;phi56_rows;phi59_rows];