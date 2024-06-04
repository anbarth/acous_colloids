load('data/glycerol_stability_05_20.mat')
load('data/glycerol_05_21.mat')

% idk if there's anything super useful in this script anymore
% maybe delete it

cmap = viridis(256); 
myColor = @(t,tmax) cmap(round(1+255*t/tmax),:);

batch2_sample1 = {glycerol_phi44_sample1_05_20.sweep1,glycerol_phi44_sample1_05_20.sweep2,...
    glycerol_phi44_sample1_05_20.sweep3,glycerol_phi44_sample1_05_20.sweep4,...
    glycerol_phi44_sample1_05_20.sweep5,glycerol_phi44_sample1_05_20.sweep6,...
    glycerol_phi44_sample1_05_20.sweep7,glycerol_phi44_sample1_05_20.sweep8,...
    glycerol_phi44_sample1_05_20.sweep9,glycerol_phi44_sample1_05_20.sweep10,...
    glycerol_phi44_sample1_05_20.sweep11,glycerol_phi44_sample1_05_20.sweep12,...
    glycerol_phi44_sample1_05_20.sweep13,glycerol_phi44_sample1_05_20.sweep14,...
    glycerol_phi44_sample1_05_20.sweep15,glycerol_phi44_sample1_05_20.sweep16,...
    glycerol_phi44_sample1_05_20.sweep17};

batch2_sample2 = {glycerol_phi44_sample2_05_21.sweep1,glycerol_phi44_sample2_05_21.sweep2,...
    glycerol_phi44_sample2_05_21.sweep3,glycerol_phi44_sample2_05_21.sweep4,...
    glycerol_phi44_sample2_05_21.sweep5,glycerol_phi44_sample2_05_21.sweep6,...
    glycerol_phi44_sample2_05_21.sweep7};

batch2_sample3 = {glycerol_batch2_sample3_05_21.sweep1};

batch3_sample1 = {glycerol_batch3_sample1_05_22.sweep1,glycerol_batch3_sample1_05_22.sweep2,...
    glycerol_batch3_sample1_05_22.sweep3,glycerol_batch3_sample1_05_22.sweep4,...
    glycerol_batch3_sample1_05_22.sweep5,glycerol_batch3_sample1_05_22.sweep6,...
    glycerol_batch3_sample1_05_22.sweep7};

% kinda everything
figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
colormap(ax1,cmap)

mySet = {batch2_sample1,batch2_sample2,batch2_sample3};
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

        plot(ax1,sigma,eta,strcat(symbols(ii),'-'),'LineWidth',1,'Color',myColor(delta_t,tmax));
    end
end
%close; 

% just initial sweep from each
figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
colormap(ax1,cmap)

mySet = {batch2_sample1,batch2_sample1(end),batch2_sample2,...
    batch2_sample2(end),batch2_sample3,{glycerol_variation_05_23.batch2_sample4_sweep1},batch3_sample1,...
    batch3_sample1(end),{glycerol_variation_05_23.batch3_sample2_sweep1}};
colors = ["#0072BD","#0072BD","#0072BD","#0072BD","#0072BD","#0072BD",...
    "#77AC30","#77AC30","#77AC30"];

for ii=1:length(mySet)
    mySweeps = mySet{ii};
    initSweep = mySweeps{1};
    [sigma_init,eta_init] = getStressSweep(initSweep);
    plot(ax1,sigma_init,eta_init,'-o','LineWidth',1,'Color',colors(ii)); 
end
legend('batch 2 sample 1 (start)','batch 2 sample 1 (9hrs)',... 
    'batch 2 sample 2 (start)','batch 2 sample 2 (4hr)',...
    'batch 2 sample 3',...
    'batch 3 sample 1 (start)','batch 3 sample 1 (5hr)')

%%%% show eta(sigma=1pa) over time for several samples
%return
all_loads = {batch2_sample1,batch2_sample2,batch2_sample3,batch3_sample1};
%colors = ["#0072BD","#0072BD","#0072BD","#4DBEEE",	"#D95319","#EDB120","#7E2F8E","#EDB120","#77AC30","#77AC30"];

mySigma=0.1;
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
    eta_init = eta_init_sweep(sigma_init==mySigma);
    eta_over_t(1) = eta_init;
    t(1) = 0;

    for jj=1:length(mySweeps)
        mySweep = mySweeps{jj};
        myT = mySweep.datetime(1);
        [sigma_sweep,eta] = getStressSweep(mySweep);

        t(jj) = minutes(myT-t_init);
        eta_over_t(jj) = eta(sigma_sweep==mySigma);
        %eta_over_t(jj) = (eta(sigma_sweep==sigma)-eta_init)/eta_init;
    end

    %plot(t,eta_over_t,'-o','LineWidth',1,'Color',colors(ii))
    plot(t,eta_over_t,'-o','LineWidth',1)
end
%close


