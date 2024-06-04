load('data/glycerol_stability_05_20.mat')
load('data/glycerol_05_21.mat')
load('data/glycerol_variation_05_23.mat')

% i think this is just showing stuff from before i was using the sgregated
% batch

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

batches = {batch2, batch3, batch4};
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
        plot(ax1,sigma,eta,'-o','LineWidth',1,'Color',colors(ii)); 
    end
end
%close

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
myBatch = batch3;
for jj=1:length(myBatch)
    mySweep = myBatch{jj};
    [sigma,eta] = getStressSweep(mySweep);
    plot(ax1,sigma,eta,'-o','LineWidth',1); 
end
%close