% using segregated particles
load('data/glycerol_variation_05_25.mat')
load('data/phi59_variation_05_26.mat')
load('data/phi59_variation_05_27.mat')
load('data/phi59_variation_05_27_part2.mat')


% older stuff
load('data/glycerol_stability_05_20.mat')
load('data/glycerol_05_21.mat')
load('data/glycerol_variation_05_23.mat')


% older stuff w non-segregated particles
% taking only first and last sweeps for like, brevity
batch2 = {glycerol_phi44_sample1_05_20.sweep1,... % sample 1 
    glycerol_phi44_sample1_05_20.sweep17,... % sample 1, 9hr
    glycerol_phi44_sample2_05_21.sweep1,... % sample 2
    glycerol_phi44_sample2_05_21.sweep7,... % sample 2, 4hr
    glycerol_batch2_sample3_05_21.sweep1,... % sample 3
    glycerol_variation_05_23.batch2_sample4_sweep1}; % sample 4

batch3 = {glycerol_batch3_sample1_05_22.sweep1,... % sample 1
    glycerol_batch3_sample1_05_22.sweep7,... % sample 1, 5hr
    glycerol_variation_05_23.batch3_sample2_sweep1}; % sample 2
    
batch4 = {glycerol_variation_05_23.batch4_sample1_sweep1,... % sample 1
    glycerol_variation_05_23.batch4_sample2_sweep1,... % sample 2 
    glycerol_variation_05_23.batch4_sample3_sweep1}; % sample 3

% 44% with segregated particles
phi44_batchA = {glycerol_variation_05_25.phi44_A_2,... % glycerol_variation_05_25.phi44_A_1,...
    glycerol_variation_05_25.phi44_A_3};

phi44_batchB = {glycerol_variation_05_25.phi44_B_1,...
    glycerol_variation_05_25.phi44_B_2};

phi44_batchC = {glycerol_variation_05_25.phi44_C_1,...
    glycerol_variation_05_25.phi44_C_2};

% 59% with segregated particles
phi59_batchA = {glycerol_variation_05_25.phi59_A_1,...
    glycerol_variation_05_25.phi59_A_1_low,...
    phi59_variation_05_26.A_2_low1,...
    phi59_variation_05_26.A_2_sweep1,...
    phi59_variation_05_27.A_3_low1, phi59_variation_05_27.A_3_sweep1};

phi59_batchB = {glycerol_variation_05_25.phi59_B_1,...
    glycerol_variation_05_25.phi59_B_1_low,...
    phi59_variation_05_27.B_2_low3, phi59_variation_05_27.B_2_sweep3,...
    phi59_variation_05_27.B_3_low1,phi59_variation_05_27.B_3_sweep1};


batches = {phi44_batchA, phi44_batchB, phi44_batchC};
%oldbatches = {batch2, batch3, batch4};
oldbatches = {{glycerol_batch3_sample1_05_22.sweep1, glycerol_batch3_sample1_05_22.sweep7}};
colors = ["#0072BD", "#D95319", "#77AC30"];
oldcolors = ["#403f3f","#8a8a8a","#0d0d0d"];
% blue, orange, green

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';


for ii=1:length(oldbatches)
    myBatch = oldbatches{ii};
    for jj=1:length(myBatch)
        mySweep = myBatch{jj};
        [sigma,eta] = getStressSweep(mySweep);
        plot(ax1,sigma,eta,'-o','LineWidth',0.5,'Color',oldcolors(ii)); 
    end
end
for ii=1:length(batches)
    myBatch = batches{ii};
    for jj=1:length(myBatch)
        mySweep = myBatch{jj};
        [sigma,eta] = getStressSweep(mySweep);
        plot(ax1,sigma,eta,'-o','LineWidth',2,'Color',colors(ii)); 
    end
end

batches = {phi59_batchA,phi59_batchB};
colors = ["#0072BD", "#D95319", "#77AC30"];
% blue, orange, green

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';


for ii=1:length(batches)
    myBatch = batches{ii};
    for jj=1:length(myBatch)
        mySweep = myBatch{jj};
        [sigma,eta] = getStressSweep(mySweep);
        plot(ax1,sigma,eta,'-o','LineWidth',2,'Color',colors(ii)); 
    end
end
