% run these individually with showPlots set to true to check that the
% automated part is working correctly

% for 52%, we have to exclude the lower stresses bc i didnt do motor adjustment
%phi52_rows = getAllDataTableRows(phi52_03_18,phi52_03_18.low_sweep_30min,0.52,false);
phi52_rows = getAcousDataTableRows(phi52_03_18, false);
phi44_rows = getAllDataTableRows(phi44_03_19,phi44_03_19.low_sweep_init,0.44,false);
phi59_rows = getAllDataTableRows(phi59_03_20,phi59_03_20.low_sweep_init,0.59,false);
phi56_rows = getAllDataTableRows(phi56_03_28,phi56_03_28.low_sweep_init_2,0.56,false);
phi48_rows = getAllDataTableRows(phi48_03_25,phi48_03_25.low_sweep_init,0.48,false);

% exclude higher stresses where stress sweep begins to bend down
phi44_rows = phi44_rows(phi44_rows(:,2)~=10 & phi44_rows(:,2)~=20,:);
phi48_rows = phi48_rows(phi48_rows(:,2)~=20,:);
phi52_rows = phi52_rows(phi52_rows(:,2)~=50,:);
phi56_rows = phi56_rows(phi56_rows(:,2)~=100,:);
phi59_rows = phi59_rows(phi59_rows(:,2)~=200,:);


clear dataTable
dataTable = [phi44_rows; phi48_rows; phi52_rows; phi56_rows; phi59_rows];