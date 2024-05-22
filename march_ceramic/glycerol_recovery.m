load('data/glycerol_stability_05_20.mat')

sig01_100V = {glycerol_phi44_sample1_05_20.sig01_100V};
sig005_100V = {glycerol_phi44_sample2_05_21.sig005_100V_1};
sig5_100V_1 = {glycerol_phi44_sample2_05_21.sig5_100V_1,glycerol_phi44_sample2_05_21.sig5_100V_1_contd,glycerol_phi44_sample2_05_21.sig5_100V_1_contd_more};
sig5_100V_2 = {glycerol_phi44_sample2_05_21.sig5_100V_2,glycerol_phi44_sample2_05_21.sig5_100V_2_contd};
sig10_100V = {glycerol_phi44_sample1_05_20.sig10_100V};

acousApplications = {sig5_100V_1,sig5_100V_2};
%acousApplications = {sig5_100V_1,sig5_100V_2,sig10_100V};
colors = ["#0072BD","#4DBEEE","#D95319"];

figure; hold on;
yline(0)
yline(0.05,'--')
yline(-0.05,'--')

for ii=1:length(acousApplications)
    myAcousApplication = acousApplications{ii};
    myInitRheoData = myAcousApplication{1};
    % get initial time to measure future datetimes against
    t_init = myInitRheoData.datetime(1);
    
    % get initial viscosity
    eta_init = getBaselineViscosity(myInitRheoData,40,55,false);
    %if ii==1
        %yline(eta_init,'Color',colors(ii));
    %end
    %eta_init = 0.7256;
    

    for jj=1:length(myAcousApplication)
        myRheoData = myAcousApplication{jj};
        eta = getViscosity(myRheoData);
        myDatetime = myRheoData.datetime;
        t = minutes(myDatetime-t_init);

        % cut out points w zero viscosity
        t = t(eta>0);
        eta = eta(eta>0);

        %plot(t,eta,'-o','LineWidth',1,'Color',colors(ii));
        plot(t,(eta-eta_init)/eta_init,'-o','LineWidth',1,'Color',colors(ii));
    end

end