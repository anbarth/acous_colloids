phi44sweeps = {phi44_05_29.sweep1, phi44_05_29.sweep2, phi44_05_29.sweep3,...
    phi44_05_29.sweep4, phi44_05_29.sweep5, phi44_05_29.sweep6,...
    phi44_05_29.sweep7, phi44_05_29.sweep8};
phi46sweeps = {phi46_06_19.sweep1, phi46_06_19.sweep2, phi46_06_19.sweep3, ...
    phi46_06_19.sweep4, phi46_06_19.sweep5, phi46_06_19.sweep6, ...
    phi46_06_19.sweep7, phi46_06_19.sweep8, phi46_06_19.sweep9, ...
    phi46_06_19.sweep10, phi46_06_19.sweep11};
phi48sweeps = {phi48_05_31.sweep1, phi48_05_31.sweep2, phi48_05_31.sweep3, ...
    phi48_05_31.sweep4, phi48_05_31.sweep5, phi48_05_31.sweep6, ...
    phi48_05_31.sweep7, phi48_05_31.sweep8, phi48_05_31.sweep9};
phi52sweeps = {phi52_05_29.sweep1, phi52_05_29.sweep2, phi52_05_29.sweep3, ...
    phi52_05_29.sweep4, phi52_05_29.sweep5, phi52_05_29.sweep6, ...
    phi52_05_29.sweep7, phi52_05_29.sweep8};
phi54sweeps = {phi54_06_01.sweep1, phi54_06_01.sweep2, phi54_06_01.sweep3, ...
    phi54_06_01.sweep4, phi54_06_01.sweep5, phi54_06_01.sweep6, ...
    phi54_06_01.sweep7, phi54_06_01.sweep8, phi54_06_01.sweep9, ...
    phi54_06_01.sweep10};
phi56sweeps = {phi56_05_31.sweep1, phi56_05_31.sweep2, phi56_05_31.sweep3, ...
    phi56_05_31.sweep4, phi56_05_31.sweep5};
phi59sweeps = {phi59_05_30.sweep1, phi59_05_30.sweep2, phi59_05_30.sweep3, ...
    phi59_05_30.sweep4, phi59_05_30.sweep5, phi59_05_30.sweep6, ...
    phi59_05_30.sweep7, phi59_05_30.sweep8, phi59_05_30.sweep9, ...
    phi59_05_30.sweep10, phi59_05_30.sweep11, phi59_05_30.sweep12};
% phi61sweeps = {phi61_06_20.sweep1, phi61_06_20.sweep2, phi61_06_20.sweep3, ...
%     phi61_06_20.sweep4, phi61_06_20.sweep5, phi61_06_20.sweep6, ...
%     phi61_06_20.sweep7, phi61_06_20.sweep8, phi61_06_20.sweep9, ...
%     phi61_06_20.sweep11, phi61_06_20.sweep12};
phi61sweeps = {phi61_06_20.sweep2, phi61_06_20.sweep3, ...
    phi61_06_20.sweep4, phi61_06_20.sweep5, phi61_06_20.sweep6, ...
    phi61_06_20.sweep7, phi61_06_20.sweep8, phi61_06_20.sweep9, ...
    phi61_06_20.sweep11, phi61_06_20.sweep12};


allPhi = {phi44sweeps,phi46sweeps,phi48sweeps,phi52sweeps,phi54sweeps,phi56sweeps,phi59sweeps,phi61sweeps};

dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));

%for myPhiNum=13
for myPhiNum = 6:13

% pick the stress sweeps for this phi
myPhi = phi_list(myPhiNum);
mySweeps = allPhi{myPhiNum-5};
[sigma_list,~] = getStressSweep(mySweeps{1});

% set up stress cmap
cmap = winter(256);
myColor = @(sig) cmap(round(1+255*(log(sig)-log(min(sigma_list)))/(log(max(sigma_list))-log(min(sigma_list)))),:);

% set up figure
figure; hold on; prettyplot
CSS = (50/19)^3;
ylabel(strcat('\eta/\eta_{dataset}'))
xlabel('t (hr)')
title(strcat('\phi=',num2str(myPhi)))
L = {};

for ii=1:length(sigma_list)
    sigma = sigma_list(ii);

    % set up eta vs t arrays
    eta_over_t = zeros(0,1);
    t = zeros(0,1);
    
    % get data from first stress sweep
    initSweep = mySweeps{1};
    t_init = initSweep.datetime(1);
    [sigma_init,eta_init_sweep] = getStressSweep(initSweep);
    eta_init = eta_init_sweep(sigma_init==sigma);

    eta_over_t(end+1) = eta_init;
    t(end+1) = 0;

    % go through subsequent stress sweeps
    for jj=2:length(mySweeps)
        mySweep = mySweeps{jj};
        myT = mySweep.datetime(1);
        [sigma_sweep,eta] = getStressSweep(mySweep);

        elapsedTime = minutes(myT-t_init);
        if elapsedTime < 0
            elapsedTime = elapsedTime+24*60;
        end
        if any(sigma_sweep==sigma)
            %eta_over_t(end+1) = (eta(sigma_sweep==sigma)-eta_init)/eta_init;
            eta_over_t(end+1) = eta(sigma_sweep==sigma);
            t(end+1) = elapsedTime;
        end
    end

    plot(t/60,eta_over_t*CSS,'-o','LineWidth',1,'Color',myColor(sigma))
    %plot(t/60,eta_over_t/eta_init,'-o','LineWidth',1,'Color',myColor(sigma))
    L{end+1} = num2str(sigma);

    % superimpose the time & viscosity used in final dataset
    myDatasetIndex = dataTable(:,1)==myPhi & dataTable(:,2)==sigma & dataTable(:,3)==0;
    myDatasetDatetime = datetimes_may_ceramic_09_17(myDatasetIndex);
    myDatasetElapsedTime = minutes(myDatasetDatetime-t_init);
    if myDatasetElapsedTime < 0
        myDatasetElapsedTime = myDatasetElapsedTime+24*60;
    end

    myDatasetViscosity = dataTable(myDatasetIndex,4);
    plot(myDatasetElapsedTime/60,myDatasetViscosity*CSS,'p','Color',myColor(sigma),'MarkerFaceColor',myColor(sigma),'MarkerSize',10)
    %plot(myDatasetElapsedTime/60,myDatasetViscosity/eta_init,'p','Color',myColor(sigma),'MarkerFaceColor',myColor(sigma),'MarkerSize',10)
    %L{end+1} = num2str(sigma);

    
end

%legend(L);

end
