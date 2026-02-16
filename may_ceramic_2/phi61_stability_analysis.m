load("phi61_time_test_01_14.mat")


phi61sweeps = {phi61_time_test_01_14.sweep1, phi61_time_test_01_14.sweep2, phi61_time_test_01_14.sweep3, ...
    phi61_time_test_01_14.sweep4, phi61_time_test_01_14.sweep5, phi61_time_test_01_14.sweep6, ...
    phi61_time_test_01_14.sweep7, phi61_time_test_01_14.sweep8, phi61_time_test_01_14.sweep9, ...
    phi61_time_test_01_14.sweep11, phi61_time_test_01_14.sweep12, phi61_time_test_01_14.sweep13, ...
    phi61_time_test_01_14.sweep14, phi61_time_test_01_14.sweep15};


allPhi = {phi61sweeps};

dataTable = may_ceramic_09_17;
phi_list = 0.61;

% set up stress cmap
big_sigma_list = [0.1 200];
cmap = winter(256);
myColor = @(sig) cmap(round(1+255*(log(sig)-log(min(big_sigma_list)))/(log(max(big_sigma_list))-log(min(big_sigma_list)))),:);


for myPhiNum = 1

% pick the stress sweeps for this phi
myPhi = phi_list(myPhiNum);
mySweeps = allPhi{myPhiNum};
[sigma_list,~] = getStressSweep(mySweeps{1});



% set up figure
figure; hold on; prettyPlot
CSS = (50/19)^3;
ylabel(strcat('\eta({\itt})/\eta({\itt}=0)'))
xlabel('time {\itt} (hr)')
title(strcat('\phi=',num2str(myPhi)))
L = {};

%for ii=10:12
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


    plot(t/60,eta_over_t/eta_over_t(1),'-o','LineWidth',1,'Color',myColor(sigma))

    
end
yline(1,'k','LineWidth',2)

a=0.15;
yline(1-a,'k--','LineWidth',2)
yline(1+a,'k--','LineWidth',2)
%ylim([0.5 1.5])

%xticks([0 2 4 6 8 10])

%legend(L);
f1=gcf;
f1.Position = [1535,360,266,350];

%fname = strcat("C:\Users\Anna Barth\Desktop\acous_scalnig_figs\05_21_stability_",num2str(round(myPhi*100)),".png");
%exportgraphics(gcf, fname,'Resolution',900)

end
return
%%
mySweep = phi61_time_test_01_14.sweep3;
figure; hold on;
yyaxis left; plot(getTime(mySweep),log(getViscosity(mySweep))); ylabel('log(\eta)')
yyaxis right; plot(getTime(mySweep),getNormalForce(mySweep)); ylabel('F_N (N)')
xlabel('t (s)')
prettyplot