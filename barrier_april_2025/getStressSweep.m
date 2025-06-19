function dataTable = getStressSweep(mySweep,averagingTime,ascendingDescending,showPlot)

% 0 = asc only, 1 = desc only, 2 = both
if nargin < 3
    ascendingDescending = 2;
end

if nargin < 4
    showPlot = false;
end



dataTableAsc = zeros(0,3);
dataTableDesc = zeros(0,3);

sigma = getStress(mySweep); % in Pa
eta = getViscosity(mySweep); % in Pa s
rate = getRate(mySweep); % in 1/s
t = getTime(mySweep); % in s

prevSigma = sigma(1);
intervalStartIndex = 1;
ascending = true;
ascendingInterval = 0;
descendingInterval = 0;
for ii = 1:(size(mySweep.data,1)+1)
    if ii ~= size(mySweep.data,1)+1 
        mySigma = sigma(ii);
    end
    
    % start of a new stress interval
    if mySigma ~= prevSigma || ii==size(mySweep.data,1)+1 
        % process previous interval, which is over now
        intervalEndIndex = ii-1;
        myEta = eta(intervalStartIndex:intervalEndIndex);
        myRate = rate(intervalStartIndex:intervalEndIndex);
        myT = t(intervalStartIndex:intervalEndIndex);
        
        % skip empty intervals
        if isempty(myT)
            continue
        end
        
        % average last N seconds of the interval
        myAveragingWindow = myT > myT(end)-averagingTime;

        myRateAvg = mean(myRate(myAveragingWindow));
        %myRateAvg = prevSigma/mean(myEta(myAveragingWindow));
        myDeltaRate = std(myRate(myAveragingWindow));
        if ascending
            %dataTableAsc(end+1,1:3) = [mySigma,myEtaAvg,myDeltaEta];
            dataTableAsc(end+1,1:3) = [prevSigma,myRateAvg,myDeltaRate];

            % if we _just started_ the descent, put the previous stress in both
            % tables, unless it'll be redundant in a pooled table
            if mySigma < prevSigma && ascendingDescending~=2
                dataTableDesc(end+1,1:3) = [prevSigma,myRateAvg,myDeltaRate];
                ascendingInterval = 1:intervalEndIndex;
                descendingInterval = intervalStartIndex:length(t);
                ascending = false;
            end
        else
            dataTableDesc(end+1,1:3) = [prevSigma,myRateAvg,myDeltaRate];
        end
       

        % reset for next interval
        intervalStartIndex = ii;

    end

    prevSigma = mySigma;
end

myInterval = 0;
if ascendingDescending==0
    dataTable = dataTableAsc;
    myInterval = ascendingInterval;
elseif ascendingDescending==1
    dataTable = dataTableDesc;
    myInterval = descendingInterval;
elseif ascendingDescending==2
    dataTable = [dataTableAsc;dataTableDesc];
    myInterval = 1:length(t);
end

if showPlot
    figure; hold on; xlabel('t (s)'); ylabel('\eta (rheo Pa s)')
    ax1=gca; ax1.YScale = 'log'; %ax1.XScale = 'log';
    plot(t(myInterval),eta(myInterval));
    %plot(t(myInterval),rate(myInterval));
    %rate_averages = unique(dataTable(:,2));
    %for ii = 1:length(rate_averages)
    %    yline(rate_averages(ii))
    %end
    eta_averages = dataTable(:,1)./dataTable(:,2);
    rate_averages = dataTable(:,2);
    for ii = 1:length(eta_averages)
       yline(eta_averages(ii))
    end
    figure; hold on; xlabel('rate (1/s)'); ylabel('\eta (rheo Pa s)')
    ax1=gca; ax1.YScale = 'log'; ax1.XScale = 'log';
    plot(rate_averages,eta_averages,'o-')
end


end