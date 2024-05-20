cmap = viridis(256); 
myColor = @(t,tmax) cmap(round(1+255*t/tmax),:);
stressTable = march_data_table_05_09;

tmax_global = 270;


phi44_sweeps = {{phi44_03_19.low_sweep_init,0},{phi44_03_19.low_sweep_30min,30},...
    {phi44_03_19.low_sweep_1hr,60},{phi44_03_19.low_sweep_2hr,120},...
    {phi44_03_19.low_sweep_3hr,180},{phi44_03_19.stress_sweep_init,0},...
    {phi44_03_19.stress_sweep_30min,30},{phi44_03_19.stress_sweep_1hr,60},...
    {phi44_03_19.stress_sweep_90min,90},{phi44_03_19.stress_sweep_2hr,120},...
    {phi44_03_19.stress_sweep_150min,150},{phi44_03_19.stress_sweep_3hr,180}};
phi48_sweeps = {{phi48_03_25.stress_sweep_init,0},{phi48_03_25.stress_sweep_30min,30},...
    {phi48_03_25.stress_sweep_1hr,60},{phi48_03_25.stress_sweep_90min,90},...
    {phi48_03_25.stress_sweep_2hr,120},{phi48_03_25.stress_sweep_150min,150},...
    {phi48_03_25.stress_sweep_3hr,180},{phi48_03_25.low_sweep_init,0},...
    {phi48_03_25.low_sweep_30min,30},{phi48_03_25.low_sweep_1hr,60}};
phi52_sweeps = {{phi52_03_18.low_sweep_init,0},{phi52_03_18.low_sweep_30min,30},...
    {phi52_03_18.low_sweep_2hr,120},{phi52_03_18.low_sweep_150min,150},...
    {phi52_03_18.low_sweep_3hr,180},{phi52_03_18.stress_sweep_init,0},...
    {phi52_03_18.stress_sweep_30min,30},{phi52_03_18.stress_sweep_1hr,60},...
    {phi52_03_18.stress_sweep_90min,90},{phi52_03_18.stress_sweep_2hr,120},...
    {phi52_03_18.stress_sweep_150min,150},{phi52_03_18.stress_sweep_3hr,180}};
phi54_sweeps = {{phi54_04_17.low_sweep_init,0},{phi54_04_17.low_sweep_30min,30},...
    {phi54_04_17.low_sweep_1hr,60},{phi54_04_17.low_sweep_2hr,120},...
    {phi54_04_17.stress_sweep_init,0},{phi54_04_17.stress_sweep_30min,30},...
    {phi54_04_17.stress_sweep_1hr,60},{phi54_04_17.stress_sweep_90min,90},...
    {phi54_04_17.stress_sweep_2hr,120},{phi54_04_17.stress_sweep_150min,150},...
    {phi54_04_17.stress_sweep_3hr,180}};
phi56_sweeps = {{phi56_03_28.stress_sweep_init_2,0},{phi56_03_28.stress_sweep_30min,30},...
    {phi56_03_28.stress_sweep_1hr,60},{phi56_03_28.stress_sweep_90min,90},...
    {phi56_03_28.stress_sweep_2hr,120},{phi56_03_28.stress_sweep_150min,150},...
    {phi56_03_28.stress_sweep_3hr,180},{phi56_03_28.stress_sweep_210min,210},...
    {phi56_03_28.stress_sweep_4hr,240},{phi56_03_28.stress_sweep_270min,270},...
    {phi56_03_28.low_sweep_init_2,0},{phi56_03_28.low_sweep_30min,30},...
    {phi56_03_28.low_sweep_1hr,60},{phi56_03_28.low_sweep_2hr,120},...
    {phi56_03_28.low_sweep_3hr,180},{phi56_03_28.low_sweep_4hr,240},...
    {phi56_03_28.low_sweep_270min,270}};
phi58_sweeps = {{phi58_04_18.stress_sweep_init,0},{phi58_04_18.stress_sweep_30min,30},...
    {phi58_04_18.stress_sweep_1hr,60},{phi58_04_18.stress_sweep_90min,90},...
    {phi58_04_18.stress_sweep_2hr,120},{phi58_04_18.stress_sweep_150min,150},...
    {phi58_04_18.stress_sweep_3hr,180},{phi58_04_18.stress_sweep_210min,210},...
    {phi58_04_18.stress_sweep_4hr,240},{phi58_04_18.stress_sweep_270min,270},...
    {phi58_04_18.low_sweep_init,0},{phi58_04_18.low_sweep_30min,30},...
    {phi58_04_18.low_sweep_1hr,60},{phi58_04_18.low_sweep_2hr,120},...
    {phi58_04_18.low_sweep_3hr,180},{phi58_04_18.low_sweep_210min,210},...
    {phi58_04_18.low_sweep_4hr,240},{phi58_04_18.low_sweep_270min,270}};
phi59_sweeps = {{phi59_03_20.stress_sweep_init_2,0},{phi59_03_20.stress_sweep_30min,30},...
    {phi59_03_20.stress_sweep_1hr,60},{phi59_03_20.stress_sweep_90min,90},...
    {phi59_03_20.stress_sweep_2hr,120},{phi59_03_20.stress_sweep_150min,150},...
    {phi59_03_20.stress_sweep_3hr,180},{phi59_03_20.stress_sweep_210min,210},...
    {phi59_03_20.stress_sweep_4hr,240},{phi59_03_20.low_sweep_init,0},...
    {phi59_03_20.low_sweep_30min,30},{phi59_03_20.low_sweep_2hr,120},...
    {phi59_03_20.low_sweep_3hr,180},{phi59_03_20.low_sweep_210min,210},...
    {phi59_03_20.low_sweep_4hr,240}};
phi59p5_sweeps = {{phi59p5_04_16.low_sweep_init,0},{phi59p5_04_16.low_sweep_30min,30},...
    {phi59p5_04_16.low_sweep_1hr,60},{phi59p5_04_16.low_sweep_2hr,120},...
    {phi59p5_04_16.low_sweep_3hr,180},{phi59p5_04_16.low_sweep_4hr,240},...
    {phi59p5_04_16.low_sweep_270min,270},{phi59p5_04_16.stress_sweep_init,0},...
    {phi59p5_04_16.stress_sweep_30min,30},{phi59p5_04_16.stress_sweep_1hr,60},...
    {phi59p5_04_16.stress_sweep_90min,90},{phi59p5_04_16.stress_sweep_2hr,120},...
    {phi59p5_04_16.stress_sweep_150min,150},{phi59p5_04_16.stress_sweep_3hr,180},...
    {phi59p5_04_16.stress_sweep_210min,210},{phi59p5_04_16.stress_sweep_4hr,240},...
    {phi59p5_04_16.stress_sweep_270min,270}};

allSweeps = {phi44_sweeps,phi48_sweeps,phi52_sweeps,phi54_sweeps,...
    phi56_sweeps,phi58_sweeps,phi59_sweeps,phi59p5_sweeps};

initSweeps = {{phi44_03_19.stress_sweep_init,phi44_03_19.low_sweep_init},...
    {phi48_03_25.stress_sweep_init,phi48_03_25.low_sweep_init},...
    {phi52_03_18.stress_sweep_init,phi52_03_18.low_sweep_init},...
    {phi54_04_17.stress_sweep_init,phi54_04_17.low_sweep_init},...
    {phi56_03_28.stress_sweep_init_2,phi56_03_28.low_sweep_init_2},...
    {phi58_04_18.stress_sweep_init,phi58_04_18.low_sweep_init},...
    {phi59_03_20.stress_sweep_init_2,phi59_03_20.low_sweep_init},...
    {phi59p5_04_16.stress_sweep_init,phi59p5_04_16.low_sweep_init}};

phi_list = [44,48,52,54,56,58,59,59.5];
phi_list_stressTable = [0.4398,0.4800,0.5205,0.5404,0.5597,0.5809,0.5907,0.5956];

% go thru the vol fracs
%for ii = 1:length(phi_list)
for ii=1
    phi = phi_list(ii);
    phi_stressTable = phi_list_stressTable(ii);
    % make fig
    figure; hold on;
    title(num2str(phi));
    ax1 = gca;
    ax1.XScale = 'log';
    colormap(ax1,cmap)
    
    % get the initial stress sweep for this phi
    init_sweep = initSweeps{ii}{1};
    init_low_sweep = initSweeps{ii}{2};
    [sigma_i,eta_i] = getStressSweep(init_sweep);
    [sigma_low_i,eta_low_i] = getStressSweep(init_low_sweep);
    sigma_i = [sigma_i;sigma_low_i];
    eta_i = [eta_i;eta_low_i];
    
    % plot all the stress sweeps over time
    sweepList = allSweeps{ii};
    for jj=1:length(sweepList)
        mySweep = sweepList{jj}{1};
        myT = sweepList{jj}{2};
        [sigma,eta] = getStressSweep(mySweep);
    
        mySigma = intersect(sigma, sigma_i);
        myDeltaEta = zeros(size(mySigma));
        for kk=1:length(mySigma)
            my_eta_f = eta(sigma==mySigma(kk));
            my_eta_i = eta_i(sigma_i==mySigma(kk));
            if length(my_eta_i)>1
                my_eta_i = my_eta_i(1);
            end
            myDeltaEta(kk)=(my_eta_f-my_eta_i)/my_eta_i;
        end
    
        plot(mySigma,abs(myDeltaEta),'-o','Color',myColor(myT,tmax_global),'LineWidth',1)
    end

%     data_0V = stressTable(stressTable(:,3)==0 & stressTable(:,1)==phi_stressTable,:);
%     sigma_0V = data_0V(:,2);
%     eta_0V = data_0V(:,4);
%     data_100V = stressTable(stressTable(:,3)==100 & stressTable(:,1)==phi_stressTable,:);
%     sigma_100V = data_100V(:,2);
%     eta_100V = data_100V(:,4);
%     mySigma = intersect(sigma_0V, sigma_100V);
%     myDeltaEta = zeros(size(mySigma));
%     for kk=1:length(mySigma)
%         my_eta_100V = eta_100V(sigma_100V==mySigma(kk));
%         my_eta_0V = eta_0V(sigma_0V==mySigma(kk));
%         myDeltaEta(kk)=my_eta_0V-my_eta_100V;
%     end
%     plot(mySigma,myDeltaEta,'-ok','LineWidth',3)
end





% [sigma44_i,eta44_i] = getStressSweep(phi44_03_19.stress_sweep_init,1,myColor(0,tmax_global));
% [sigma44_f,eta44_f] = getStressSweep(phi44_03_19.stress_sweep_3hr,1,myColor(180,tmax_global));


return

% 48%
figure; hold on;
title('48%');
ax48 = gca;
ax48.XScale = 'log';
ax48.YScale = 'log';
colormap(ax48,cmap)


tmax=180;

sweepList = phi48_sweeps;
for ii=1:length(sweepList)
    mySweep = sweepList{ii}{1};
    myT = sweepList{ii}{2};
    getStressSweep(mySweep,1,myColor(myT,tmax_global));
end
ylim([0.05 100])
%mySigma = 10;
%delta48 = eta48_f(sigma48_f(:,1)==mySigma)-eta48_i(sigma48_i(:,1)==mySigma);


% 52%
figure; hold on;
title('52%');
ax52 = gca;
ax52.XScale = 'log';
ax52.YScale = 'log';
colormap(ax52,cmap)


tmax = 180;

sweepList = phi52_sweeps;
for ii=1:length(sweepList)
    mySweep = sweepList{ii}{1};
    myT = sweepList{ii}{2};
    getStressSweep(mySweep,1,myColor(myT,tmax_global));
end
ylim([0.05 100])
%mySigma = 10;
%delta52 = eta52_f(sigma52_f(:,1)==mySigma)-eta52_i(sigma52_i(:,1)==mySigma);

% 54%
figure; hold on;
title('54%');
ax54 = gca;
ax54.XScale = 'log';
ax54.YScale = 'log';
colormap(ax54,cmap)


tmax = 180;

sweepList = phi54_sweeps;
for ii=1:length(sweepList)
    mySweep = sweepList{ii}{1};
    myT = sweepList{ii}{2};
    getStressSweep(mySweep,1,myColor(myT,tmax_global));
end
ylim([0.05 100])
%mySigma = 10;
%delta54 = eta54_f(sigma54_f(:,1)==mySigma)-eta54_i(sigma54_i(:,1)==mySigma);

% 56%
figure; hold on;
title('56%');
ax56 = gca;
ax56.XScale = 'log';
ax56.YScale = 'log';
colormap(ax56,cmap)


tmax = 270;

sweepList = phi56_sweeps;
for ii=1:length(sweepList)
    mySweep = sweepList{ii}{1};
    myT = sweepList{ii}{2};
    getStressSweep(mySweep,1,myColor(myT,tmax_global));
end
ylim([0.05 100])
%mySigma = 10;
%delta56 = eta56_f(sigma56_f(:,1)==mySigma)-eta56_i(sigma56_i(:,1)==mySigma);

% 58%
figure; hold on;
title('58%');
ax58 = gca;
ax58.XScale = 'log';
ax58.YScale = 'log';
colormap(ax58,cmap)


tmax = 270;

sweepList = phi58_sweeps;
for ii=1:length(sweepList)
    mySweep = sweepList{ii}{1};
    myT = sweepList{ii}{2};
    getStressSweep(mySweep,1,myColor(myT,tmax_global));
end
ylim([0.05 100])
%mySigma = 10;
%delta58 = eta58_f(sigma58_f(:,1)==mySigma)-eta58_i(sigma58_i(:,1)==mySigma);

% 59%
figure; hold on;
title('59%');
ax59 = gca;
ax59.XScale = 'log';
ax59.YScale = 'log';
colormap(ax59,cmap)


tmax=240;

sweepList = phi59_sweeps;
for ii=1:length(sweepList)
    mySweep = sweepList{ii}{1};
    myT = sweepList{ii}{2};
    getStressSweep(mySweep,1,myColor(myT,tmax_global));
end
ylim([0.05 100])
% mySigma = 10;
% delta59 = eta59_f(sigma59_f(:,1)==mySigma)-eta59_i(sigma59_i(:,1)==mySigma);

% 59.5%
figure; hold on;
title('59.5%');
ax595 = gca;
ax595.XScale = 'log';
ax595.YScale = 'log';
colormap(ax595,cmap)


tmax=270;

sweepList = phi59p5_sweeps;
for ii=1:length(sweepList)
    mySweep = sweepList{ii}{1};
    myT = sweepList{ii}{2};
    getStressSweep(mySweep,1,myColor(myT,tmax_global));
end
ylim([0.05 100])
% mySigma = 10;
% delta59p5 = eta59p5_f(sigma59p5_f(:,1)==mySigma)-eta59p5_i(sigma59p5_i(:,1)==mySigma);