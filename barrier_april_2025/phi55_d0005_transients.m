transientTimeSeries = {phi55_04_21.d005_0005pa,phi55_04_21.d005_005pa,phi55_04_21.d005_05pa,phi55_04_21.d005_5pa};

%for ii=1
for ii=1:length(transientTimeSeries)
    figure; hold on;
    ax1=gca; %ax1.YScale='log';
    xlabel('t (s)'); %ylabel('\eta (Pa s)')
    ylabel('rate (1/s)')
    timeSeries = transientTimeSeries{ii};
    time = timeSeries.data(:,2);
    stress = timeSeries.data(:,3)*(50/19)^3;
    rate = timeSeries.data(:,4);
    eta = stress./rate;

    title(strcat('\sigma = ',num2str(stress(end)),' Pa'))
    plot(time,rate,'-')
    prettyplot;
end

