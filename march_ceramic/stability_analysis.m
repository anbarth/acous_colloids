load('data/stability_05_16.mat')
load('data/stability_05_17.mat')
load('data/gly')

cmap = viridis(256); 
myColor = @(t,tmax) cmap(round(1+255*t/tmax),:);

batch1_sample1_sweeps = {phi44_stability_05_16.batch1_sample1_sweep_1,phi44_stability_05_16.batch1_sample1_sweep_2,...
    phi44_stability_05_16.batch1_sample1_sweep_3,phi44_stability_05_16.batch1_sample1_sweep_4,...
    phi44_stability_05_16.batch1_sample1_sweep_5};

batch1_sample2_sweeps = {phi44_stability_05_16.batch1_sample2_sweep_1,phi44_stability_05_16.batch1_sample2_sweep_2,...
    phi44_stability_05_16.batch1_sample2_sweep_3,phi44_stability_05_16.batch1_sample2_sweep_4,...
    phi44_stability_05_16.batch1_sample2_sweep_5};

batch1_sample3_sweeps = {phi44_stability_05_16.batch1_sample3_sweep_1,phi44_stability_05_16.batch1_sample3_sweep_2,...
    phi44_stability_05_16.batch1_sample3_sweep_3,phi44_stability_05_16.batch1_sample3_sweep_4,...
    phi44_stability_05_16.batch1_sample3_sweep_5};

batch1_sample4_sweeps = {phi44_stability_05_16.batch1_sample4_sponges_sweep_1,phi44_stability_05_16.batch1_sample4_sponges_sweep_2,...
    phi44_stability_05_16.batch1_sample4_sponges_sweep_3,phi44_stability_05_16.batch1_sample4_sponges_sweep_3,...
    phi44_stability_05_16.batch1_sample4_sponges_2_sweep_1,phi44_stability_05_16.batch1_sample4_sponges_2_sweep_2,...
    phi44_stability_05_16.batch1_sample4_sponges_2_sweep_3,phi44_stability_05_16.batch1_sample4_sponges_2_sweep_4,...
    phi44_stability_05_16.batch1_sample4_sponges_2_sweep_5,phi44_stability_05_16.batch1_sample4_sponges_2_sweep_6};

batch1_sample5_sweeps = {phi44_stability_05_16.batch1_sample5_sweep_1,phi44_stability_05_16.batch1_sample5_sweep_2,...
    phi44_stability_05_16.batch1_sample5_sweep_3,phi44_stability_05_16.batch1_sample5_sweep_4,...
    phi44_stability_05_16.batch1_sample5_sweep_5};

batch2_sample1_sweeps = {phi44_stability_05_17.batch2_sample1_drierite_sweep_1,phi44_stability_05_17.batch2_sample1_drierite_sweep_2,...
    phi44_stability_05_17.batch2_sample1_drierite_sweep_3,phi44_stability_05_17.batch2_sample1_drierite_sweep_4,...
    phi44_stability_05_17.batch2_sample1_drierite_sweep_5,phi44_stability_05_17.batch2_sample1_drierite_sweep_6};

batch2_sample2_sweeps = {phi44_stability_05_17.batch2_sample2_sweep_1,phi44_stability_05_17.batch2_sample2_sweep_2,...
    phi44_stability_05_17.batch2_sample2_sweep_3,phi44_stability_05_17.batch2_sample2_sweep_4,...
    phi44_stability_05_17.batch2_sample2_sweep_5,phi44_stability_05_17.batch2_sample2_sweep_6,...
    phi44_stability_05_17.batch2_sample2_sweep_7,phi44_stability_05_17.batch2_sample2_sweep_8,...
    phi44_stability_05_17.batch2_sample2_sweep_9,phi44_stability_05_17.batch2_sample2_sweep_10,...
    phi44_stability_05_17.batch2_sample2_sweep_11,phi44_stability_05_17.batch2_sample2_sweep_12,...
    phi44_stability_05_17.batch2_sample2_sweep_13};

batch2_sample3_sweeps = {phi44_stability_05_17.batch2_sample3_drierite_sweep_1,phi44_stability_05_17.batch2_sample3_drierite_sweep_2,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_3,phi44_stability_05_17.batch2_sample3_drierite_sweep_4,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_5,phi44_stability_05_17.batch2_sample3_drierite_sweep_6,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_7,phi44_stability_05_17.batch2_sample3_drierite_sweep_8,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_9,phi44_stability_05_17.batch2_sample3_drierite_sweep_10};

% batch 1, no sponge
repeated_loads_1 = {batch1_sample1_sweeps,batch1_sample2_sweeps,batch1_sample3_sweeps,batch1_sample5_sweeps};

% batch 2, drierite
repeated_loads_2 = {batch2_sample1_sweeps,batch2_sample3_sweeps};

% batch 1, no sponge + batch 2 sample 2 (same conditions)
repeated_loads_3 = {batch1_sample1_sweeps,batch1_sample2_sweeps,batch1_sample3_sweeps,batch1_sample5_sweeps,batch2_sample2_sweeps};
symbols = ["o","square","^","pentagram","d"];

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
colormap(ax1,cmap)


mySet = repeated_loads_3;
n = 1;
tmax = minutes(mySet{n}{end}.datetime(1)-mySet{n}{1}.datetime(1));

for ii=1:length(mySet)
    mySweeps = mySet{ii};
    initSweep = mySweeps{1};
    t_init = initSweep.datetime(1);
    [sigma_init,eta_init] = getStressSweep(initSweep);
    for jj=1:length(mySweeps)
        mySweep = mySweeps{jj};
        myT = mySweep.datetime(1);
        delta_t = minutes(myT-t_init);
        if delta_t > tmax
            %disp("delta t exceeds tmax")
            %disp([ii jj])
            continue
        end
        [sigma,eta] = getStressSweep(mySweep);
        %plot(ax1,sigma,eta,strcat(symbols(ii),'-'),'LineWidth',1,'Color',myColor(delta_t,tmax));
        plot(ax1,sigma,(eta-eta_init)./eta_init,strcat(symbols(ii),'-'),'LineWidth',1,'Color',myColor(delta_t,tmax));
    end
end
close;

%return
all_loads = {batch1_sample1_sweeps,batch1_sample2_sweeps,batch1_sample3_sweeps,batch1_sample4_sweeps,batch1_sample5_sweeps,batch2_sample1_sweeps,batch2_sample2_sweeps,batch2_sample3_sweeps};
sigma=1;
figure; hold on;
ax1 = gca;
colormap(ax1,cmap)

for ii=1:length(all_loads)
    mySweeps = all_loads{ii};
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
        eta_over_t(jj) = eta(sigma_sweep==sigma);
        %eta_over_t(jj) = (eta(sigma_sweep==sigma)-eta_init)/eta_init;
    end

    plot(t,eta_over_t,'-o','LineWidth',1)
end

% superimpose data from march
phi44_sweeps = {{phi44_03_19.stress_sweep_init,0},...
    {phi44_03_19.stress_sweep_30min,30},{phi44_03_19.stress_sweep_1hr,60},...
    {phi44_03_19.stress_sweep_90min,90},{phi44_03_19.stress_sweep_2hr,120},...
    {phi44_03_19.stress_sweep_150min,150},{phi44_03_19.stress_sweep_3hr,180}};
sweepList = phi44_sweeps;
    
% get the initial stress sweep for this phi
init_sweep = phi44_03_19.stress_sweep_init;
[sigma_i,eta_i_sweep] = getStressSweep(init_sweep);
eta_i = eta_i_sweep(sigma_i==sigma);

eta_over_t = zeros(length(sweepList),1);
t = zeros(length(sweepList),1);

eta_over_t(1) = eta_i;

% plot all the stress sweeps over time
for jj=1:length(sweepList)
    mySweep = sweepList{jj}{1};
    myT = sweepList{jj}{2};
    [sigma_sweep,eta] = getStressSweep(mySweep);

    t(jj) = myT;
    eta_over_t(jj) = eta(sigma_sweep==sigma);
end

plot(t,eta_over_t,'-ok','LineWidth',2)




