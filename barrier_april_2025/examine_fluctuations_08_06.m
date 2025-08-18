load("phi61_fluctuations_08_05.mat")

cmap=flipud(viridis(5));
Aplate = pi*(19/2*10^(-3))^2;


sig001 = {fluctuations_08_05.h2_001pa,fluctuations_08_05.h09_001pa,...
    fluctuations_08_05.h04_001pa,fluctuations_08_05.h022_001pa,...
    fluctuations_08_05.h01_001pa};
figure; hold on; prettyplot;
title('\sigma=0.18 Pa'); xlabel('t (s)'); ylabel('rate (1/s)')
ax1=gca; ax1.YScale='log';
for ii=1:length(sig001)
    myStruct=sig001{ii};
    t = getTime(myStruct);
    rate = getRate(myStruct);
    plot(t,rate,'Color',cmap(ii,:));
end
figure; hold on; prettyplot;
title('\sigma=0.18 Pa'); xlabel('t (s)'); ylabel('N/A_{plate} (Pa)')
%ax1=gca; ax1.YScale='log';
for ii=1:length(sig001)
    myStruct=sig001{ii};
    t = getTime(myStruct);
    N = getNormalForce(myStruct);
    plot(t,N/Aplate,'Color',cmap(ii,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig01 = {fluctuations_08_05.h2_01pa,fluctuations_08_05.h09_01pa,...
    fluctuations_08_05.h04_01pa,fluctuations_08_05.h022_01pa,...
    fluctuations_08_05.h01_01pa};
figure; hold on; prettyplot;
title('\sigma=1.8 Pa'); xlabel('t (s)'); ylabel('rate (1/s)')
ax1=gca; ax1.YScale='log';
for ii=1:length(sig01)
    myStruct=sig01{ii};
    t = getTime(myStruct);
    rate = getRate(myStruct);
    plot(t,rate,'Color',cmap(ii,:));
end
figure; hold on; prettyplot;
title('\sigma=1.8 Pa'); xlabel('t (s)'); ylabel('N/A_{plate} (Pa)')
%ax1=gca; ax1.YScale='log';
for ii=1:length(sig01)
    myStruct=sig01{ii};
    t = getTime(myStruct);
    N = getNormalForce(myStruct);
    plot(t,N/Aplate,'Color',cmap(ii,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sig1 = {fluctuations_08_05.h2_1pa,fluctuations_08_05.h09_1pa,...
    fluctuations_08_05.h04_1pa,fluctuations_08_05.h022_1pa,...
    fluctuations_08_05.h01_1pa};
figure; hold on; prettyplot;
title('\sigma=18 Pa'); xlabel('t (s)'); ylabel('rate (1/s)')
ax1=gca; ax1.YScale='log';
for ii=1:length(sig1)
    myStruct=sig1{ii};
    t = getTime(myStruct);
    rate = getRate(myStruct);
    plot(t,rate,'Color',cmap(ii,:));
end
figure; hold on; prettyplot;
title('\sigma=18 Pa'); xlabel('t (s)'); ylabel('N/A_{plate} (Pa)')
%ax1=gca; ax1.YScale='log';
for ii=1:length(sig1)
    myStruct=sig1{ii};
    t = getTime(myStruct);
    N = getNormalForce(myStruct);
    plot(t,N/Aplate,'Color',cmap(ii,:));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sig10 = {fluctuations_08_05.h2_10pa,fluctuations_08_05.h09_10pa,...
    fluctuations_08_05.h04_10pa,fluctuations_08_05.h022_10pa,...
    fluctuations_08_05.h01_10pa};
figure; hold on; prettyplot;
title('\sigma=180 Pa'); xlabel('t (s)'); ylabel('rate (1/s)')
ax1=gca; ax1.YScale='log';
for ii=1:length(sig10)
    myStruct=sig10{ii};
    t = getTime(myStruct);
    rate = getRate(myStruct);
    plot(t,rate,'Color',cmap(ii,:));
end
figure; hold on; prettyplot;
title('\sigma=180 Pa'); xlabel('t (s)'); ylabel('N/A_{plate} (Pa)')
%ax1=gca; ax1.YScale='log';
for ii=1:length(sig10)
    myStruct=sig10{ii};
    t = getTime(myStruct);
    N = getNormalForce(myStruct);
    plot(t,N/Aplate,'Color',cmap(ii,:));
end