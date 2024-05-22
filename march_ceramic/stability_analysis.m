load('data/stability_05_16.mat')
load('data/stability_05_17.mat')
load('data/glycerol_stability_05_20.mat')

cmap = viridis(256); 
myColor = @(t,tmax) cmap(round(1+255*t/tmax),:);

batch1_sample1 = {phi44_stability_05_16.batch1_sample1_sweep_1,phi44_stability_05_16.batch1_sample1_sweep_2,...
    phi44_stability_05_16.batch1_sample1_sweep_3,phi44_stability_05_16.batch1_sample1_sweep_4,...
    phi44_stability_05_16.batch1_sample1_sweep_5};

batch1_sample2 = {phi44_stability_05_16.batch1_sample2_sweep_1,phi44_stability_05_16.batch1_sample2_sweep_2,...
    phi44_stability_05_16.batch1_sample2_sweep_3,phi44_stability_05_16.batch1_sample2_sweep_4,...
    phi44_stability_05_16.batch1_sample2_sweep_5};

batch1_sample3 = {phi44_stability_05_16.batch1_sample3_sweep_1,phi44_stability_05_16.batch1_sample3_sweep_2,...
    phi44_stability_05_16.batch1_sample3_sweep_3,phi44_stability_05_16.batch1_sample3_sweep_4,...
    phi44_stability_05_16.batch1_sample3_sweep_5};

batch1_sample4_sponges = {phi44_stability_05_16.batch1_sample4_sponges_sweep_1,phi44_stability_05_16.batch1_sample4_sponges_sweep_2,...
    phi44_stability_05_16.batch1_sample4_sponges_sweep_3,phi44_stability_05_16.batch1_sample4_sponges_sweep_3,...
    phi44_stability_05_16.batch1_sample4_sponges_2_sweep_1,phi44_stability_05_16.batch1_sample4_sponges_2_sweep_2,...
    phi44_stability_05_16.batch1_sample4_sponges_2_sweep_3,phi44_stability_05_16.batch1_sample4_sponges_2_sweep_4,...
    phi44_stability_05_16.batch1_sample4_sponges_2_sweep_5,phi44_stability_05_16.batch1_sample4_sponges_2_sweep_6};

batch1_sample5_nextday = {phi44_stability_05_16.batch1_sample5_sweep_1,phi44_stability_05_16.batch1_sample5_sweep_2,...
    phi44_stability_05_16.batch1_sample5_sweep_3,phi44_stability_05_16.batch1_sample5_sweep_4,...
    phi44_stability_05_16.batch1_sample5_sweep_5};

batch2_sample1_drierite = {phi44_stability_05_17.batch2_sample1_drierite_sweep_1,phi44_stability_05_17.batch2_sample1_drierite_sweep_2,...
    phi44_stability_05_17.batch2_sample1_drierite_sweep_3,phi44_stability_05_17.batch2_sample1_drierite_sweep_4,...
    phi44_stability_05_17.batch2_sample1_drierite_sweep_5,phi44_stability_05_17.batch2_sample1_drierite_sweep_6};

batch2_sample2 = {phi44_stability_05_17.batch2_sample2_sweep_1,phi44_stability_05_17.batch2_sample2_sweep_2,...
    phi44_stability_05_17.batch2_sample2_sweep_3,phi44_stability_05_17.batch2_sample2_sweep_4,...
    phi44_stability_05_17.batch2_sample2_sweep_5,phi44_stability_05_17.batch2_sample2_sweep_6,...
    phi44_stability_05_17.batch2_sample2_sweep_7,phi44_stability_05_17.batch2_sample2_sweep_8,...
    phi44_stability_05_17.batch2_sample2_sweep_9,phi44_stability_05_17.batch2_sample2_sweep_10,...
    phi44_stability_05_17.batch2_sample2_sweep_11,phi44_stability_05_17.batch2_sample2_sweep_12,...
    phi44_stability_05_17.batch2_sample2_sweep_13};

batch2_sample3_drierite = {phi44_stability_05_17.batch2_sample3_drierite_sweep_1,phi44_stability_05_17.batch2_sample3_drierite_sweep_2,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_3,phi44_stability_05_17.batch2_sample3_drierite_sweep_4,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_5,phi44_stability_05_17.batch2_sample3_drierite_sweep_6,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_7,phi44_stability_05_17.batch2_sample3_drierite_sweep_8,...
    phi44_stability_05_17.batch2_sample3_drierite_sweep_9,phi44_stability_05_17.batch2_sample3_drierite_sweep_10};

glycerol_sample1 = {glycerol_phi44_sample1_05_20.sweep1,glycerol_phi44_sample1_05_20.sweep2,...
    glycerol_phi44_sample1_05_20.sweep3,glycerol_phi44_sample1_05_20.sweep4,...
    glycerol_phi44_sample1_05_20.sweep5,glycerol_phi44_sample1_05_20.sweep6,...
    glycerol_phi44_sample1_05_20.sweep7,glycerol_phi44_sample1_05_20.sweep8,...
    glycerol_phi44_sample1_05_20.sweep9,glycerol_phi44_sample1_05_20.sweep10,...
    glycerol_phi44_sample1_05_20.sweep11,glycerol_phi44_sample1_05_20.sweep12,...
    glycerol_phi44_sample1_05_20.sweep13,glycerol_phi44_sample1_05_20.sweep14,...
    glycerol_phi44_sample1_05_20.sweep15,glycerol_phi44_sample1_05_20.sweep16,...
    glycerol_phi44_sample1_05_20.sweep17};

glycerol_sample2 = {glycerol_phi44_sample2_05_21.sweep1,glycerol_phi44_sample2_05_21.sweep2,...
    glycerol_phi44_sample2_05_21.sweep3,glycerol_phi44_sample2_05_21.sweep4,...
    glycerol_phi44_sample2_05_21.sweep5,glycerol_phi44_sample2_05_21.sweep6,...
    glycerol_phi44_sample2_05_21.sweep7};

% batch 1, no sponge
repeated_loads_1 = {batch1_sample1,batch1_sample2,batch1_sample3,batch1_sample5_nextday};

% batch 2, drierite
repeated_loads_2 = {batch2_sample1_drierite,batch2_sample3_drierite};

% batch 1, no sponge + batch 2 sample 2 (same conditions)
repeated_loads_3 = {batch1_sample1,batch1_sample2,batch1_sample3,batch1_sample5_nextday,batch2_sample2};

% 44% in pure glycerol
glycerol_loads = {glycerol_sample1,glycerol_sample2};


symbols = ["o","square","^","pentagram","d"];

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
colormap(ax1,cmap)

%%%%% show stress sweeps over time for several loads in a set
mySet = {glycerol_sample2};
n = 1;
tmax = minutes(mySet{n}{end}.datetime(1)-mySet{n}{1}.datetime(1));
tmax = 60*4;
%for ii=1
for ii=1:length(mySet)
    mySweeps = mySet{ii};
    initSweep = mySweeps{1};
    t_init = initSweep.datetime(1);
    [sigma_init,eta_init] = getStressSweep(initSweep);
    if sigma_init(end) == 20 % total kluge for glycerol stuff
        sigma_init = sigma_init(1:end-1);
        eta_init = eta_init(1:end-1);
    end
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
        if sigma(end) == 20 % total kluge for glycerol stuff
            sigma = sigma(1:end-1);
            eta = eta(1:end-1);
        end
        %plot(ax1,sigma,eta,strcat(symbols(ii),'-'),'LineWidth',1,'Color',myColor(delta_t,tmax));
        plot(ax1,sigma,(eta-eta_init)./eta_init,strcat(symbols(ii),'-'),'LineWidth',1,'Color',myColor(delta_t,tmax));
    end
end
%close;

%%%% show eta(sigma=1pa) over time for several samples
%return
all_loads = {batch1_sample1,batch1_sample2,batch1_sample3,batch1_sample5_nextday,batch1_sample4_sponges,batch2_sample1_drierite,batch2_sample2,batch2_sample3_drierite,glycerol_sample1,glycerol_sample2};
colors = ["#0072BD","#0072BD","#0072BD","#4DBEEE",	"#D95319","#EDB120","#7E2F8E","#EDB120","#77AC30","#77AC30"];

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
        %eta_over_t(jj) = eta(sigma_sweep==sigma);
        eta_over_t(jj) = (eta(sigma_sweep==sigma)-eta_init)/eta_init;
    end

    plot(t,eta_over_t,'-o','LineWidth',1,'Color',colors(ii))
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
    %eta_over_t(jj) = eta(sigma_sweep==sigma);
    eta_over_t(jj) = (eta(sigma_sweep==sigma)-eta_i)/eta_i;
end

plot(t,eta_over_t,'-ok','LineWidth',2)





