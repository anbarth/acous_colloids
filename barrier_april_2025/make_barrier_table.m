CSS = (50/19)^3;

phi55_rheo_structs = {phi55_04_21.d15_sweep, phi55_04_21.d05_sweep, phi55_04_21.d018_sweep, ...
    phi55_04_21.d012_sweep, phi55_04_21.d007_sweep, phi55_04_21.d005_sweep, phi55_04_21.d002_sweep};

% make a table with columns: gap, stress, rate, ascending (1) or desc (2)
% TODO add another column thats like, the rounded stress, to make it easier
% to connect points at the sameish stress
phi55table = zeros(0,4);
for ii=1:length(phi55_rheo_structs)
    myRheoStruct = phi55_rheo_structs{ii};

    % separate asc and desc sweeps
    myData = myRheoStruct.data;
    prevStress = 0;
    for jj=1:size(myData,1)
        gap = round(myData(jj,6),3);
        stress = myData(jj,3)*CSS;
        rate = myData(jj,4);
        if stress > prevStress
            % ascending sweep
            phi55table(end+1,:) = [gap stress rate 1];
        else
            % descending sweep
            phi55table(end+1,:) = [gap stress rate 2];
        end
        prevStress = stress;
    end
end

viscostd_rheo_structs = {visco_std_04_21.d15_sweep, visco_std_04_21.d1_sweep, visco_std_04_21.d05_sweep, visco_std_04_21.d018_sweep,...
    visco_std_04_21.d012_sweep, visco_std_04_21.d007_sweep, visco_std_04_21.d005_sweep, visco_std_04_21.d002_sweep};
viscostdtable = zeros(0,4);
for ii=1:length(viscostd_rheo_structs)
    myRheoStruct = viscostd_rheo_structs{ii};

    % separate asc and desc sweeps
    myData = myRheoStruct.data;
    prevStress = 0;
    for jj=1:size(myData,1)
        gap = round(myData(jj,6),3);
        stress = myData(jj,3)*CSS;
        rate = myData(jj,4);
        if stress > prevStress
            % ascending sweep
            viscostdtable(end+1,:) = [gap stress rate 1];
        else
            % descending sweep
            viscostdtable(end+1,:) = [gap stress rate 2];
        end
        prevStress = stress;
    end
end

% add extra rows for the higher-stress points i did for d=0.05, 0.02mm
showFigs = false;
viscostd_rheo_structs_extra = {visco_std_04_21.d002_50pa, visco_std_04_21.d005_5pa};
for ii=1:length(viscostd_rheo_structs_extra)
    myRheoStruct = viscostd_rheo_structs_extra{ii};

    % separate asc and desc sweeps
    myData = myRheoStruct.data;
    gap = round(myData(:,6),3);
    stress = myData(:,3)*CSS;
    rate = myData(:,4);
    time = myData(:,2);

    if showFigs
        figure; hold on; ax1=gca; ax1.YScale='log';
        xlabel('t (s)'); ylabel('rate (1/s)')
        plot(time,rate)
        yline(mean(rate(time>20)))
    end


    gap = gap(end);
    stress = mean(stress);
    rate = mean(rate(time>20));

    viscostdtable(end+1,:) = [gap stress rate 1];
    viscostdtable(end+1,:) = [gap stress rate 2];

end

