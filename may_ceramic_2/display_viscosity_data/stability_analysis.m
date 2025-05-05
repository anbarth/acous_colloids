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
phi_list = [0.4396
    0.4604
    0.4811
    0.5193
    0.5398
    0.5607
    0.5898
    0.6101];
cmap = viridis(256);
myColor = @(phi) cmap(round(1+255*(phi-min(phi_list))/(max(phi_list)-min(phi_list))),:);


sigma=0.5;
figure; hold on;
ax1 = gca;
%ylim([-0.2 0.2])
%xlim([0 60*9])
CSS = (50/19)^3;
ylabel(strcat('\Delta\eta/\eta(t=0) at \sigma=',num2str(round(sigma*CSS*10)/10),' Pa'))
xlabel('t (hr)')

%for ii=4
for ii=1:length(allPhi)
    mySweeps = allPhi{ii};
    phi = phi_list(ii);
    eta_over_t = zeros(length(mySweeps),1);
    t = zeros(length(mySweeps),1);

    initSweep = mySweeps{1};
    t_init = initSweep.datetime(1);
    [sigma_init,eta_init_sweep] = getStressSweep(initSweep);
    eta_init = eta_init_sweep(sigma_init==sigma);
    eta_over_t(1) = eta_init;
    t(1) = 0;

    for jj=1:length(mySweeps)
        mySweep = mySweeps{jj};
        myT = mySweep.datetime(1);
        [sigma_sweep,eta] = getStressSweep(mySweep);

        t(jj) = minutes(myT-t_init);
        if t(jj) < 0
            t(jj) = t(jj)+24*60;
        end
        %eta_over_t(jj) = eta(sigma_sweep==sigma);
        eta_over_t(jj) = (eta(sigma_sweep==sigma)-eta_init)/eta_init;
    end

    plot(t/60,eta_over_t,'-o','LineWidth',1,'Color',myColor(phi))
end
prettyplot
