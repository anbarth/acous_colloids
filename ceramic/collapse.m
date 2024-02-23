my_vol_frac_markers = ['>','s','o','d','h'];

vol_frac_plotting_range = 5;
volt_plotting_range = 1:8;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = true;
showMeera = false;
xc = 0;

collapse_params;

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = viridis(256); 
%cmap = plasma(256);
fig1 = figure;
ax1 = axes('Parent', fig1,'XScale','log','YScale','log');
ax1.XLabel.String = "x";
ax1.YLabel.String = "F";

if showMeera
    hold(ax1,'on');
    scatter(meeraX,meeraY*meeraMultiplier,[],[0.7 0.7 0.7]);
end
%ax1.XLim = [10^(-5),10^1.5]; %TODO delete
ax1.XLim = [10^-5, 100];
%ax1.YLim = [10^(-1.5),5]; %TODO delete
colormap(ax1,cmap);
if xc ~= 0
    xline(ax1,xc);
end


if xc ~= 0
    fig2 = figure;
    fig3 = figure;
    ax2 = axes('Parent', fig2,'XScale','log','YScale','log');
    ax2.XLabel.String = "x_c-x";
    ax2.YLabel.String = "F";
    colormap(ax2,cmap);
    ax3 = axes('Parent', fig3,'XScale','log','YScale','log');
    ax3.XLabel.String = "1/x-1/x_c";
    ax3.YLabel.String = "H";
    ax3.Title.String = strcat("x_c = ",num2str(xc));
    colormap(ax3,cmap);
    if showMeera
        hold(ax3,'on')
        scatter(meeraHX,meeraHY*0.2,[],[0.7 0.7 0.7]);
    end
    xlim([10^(-3.5) 10^12])
end

fig4 = figure('visible','off');
ax4 = axes('Parent', fig4,'XScale','log','YScale','log');
ax4.XLabel.String = "\phi_0-\phi";
ax4.YLabel.String = "\eta";
colormap(ax4,cmap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stressTable = ceramic_data_table_02_22;
phi_list = [40,44,48,56,59];
minPhi = 0.4;
maxPhi = 0.6;
volt_list = [0,5,10,20,40,60,80,100];
x_all = zeros(0,1);
F_all = zeros(0,1);


for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii)/100;
        myData = stressTable( stressTable(:,1)==phi & stressTable(:,3)==voltage,:);
        sigma = myData(:,2);
        eta = myData(:,4);

        
        % calculate nondimensionalized power
        % TODO this is inefficient and bad coding
        % really i feel like P should just be like, another column in
        % stress table
        % i could just calculate it at the beginning
        P = zeros(size(sigma));
        for kk = 1:length(sigma)
            eta_0V = stressTable(stressTable(:,1)==phi & stressTable(:,2)==sigma(kk) & stressTable(:,3)==0,4);
            gamma_dot_0V = sigma(kk)/eta_0V;
            P(kk) = voltage^2/sigma(kk)/gamma_dot_0V;
        end

        %myColor = voltage*ones(size(sigma));
        %myColor = phi*ones(size(sigma));
        %myColor = log(sigma);
        if colorBy == 1
            myColor = cmap(round(1+255*voltage/100),:);
            %myColor = cmap(round(1+255*(log10(voltage+10)-1)/(log10(110)-1)),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

        elseif colorBy == 3
            myColor = log(P);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        xWC = C(ii)*A(P).*f(sigma) ./ (-1*phi+phi0);
        FWC = eta*(phi0-phi)^2;
        H = eta.*(C(ii)*A(P).*f(sigma)).^2;

        myMarker = my_vol_frac_markers(ii);
        hold(ax1,'on');
        if showLines && colorBy < 3
            % sort in order of ascending x
            [xWC,sortIdx] = sort(xWC,'ascend');
            FWC = FWC(sortIdx);
            plot(ax1,xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
        else
            scatter(ax1,xWC,FWC,[],myColor,'filled',myMarker);
            %scatter(ax1,xWC,FWC,[],myColor,'filled',myMarker,'MarkerFaceAlpha',0.5);
        end

        %hold(meeraAx,'on');
        %scatter(meeraAx,xWC,FWC,[],myColor,'filled',myMarker);
        
        if xc ~= 0
            hold(ax2,'on');
            scatter(ax2,xc-xWC,FWC,[],myColor,'filled',myMarker);
            hold(ax3,'on');
            scatter(ax3, abs(1/xc-1./xWC),H,[],myColor,'filled',myMarker);
        end
        hold(ax4,'on');
        scatter(ax4,(phi0-phi)*ones(size(eta)),eta,[],myColor,'filled',myMarker);
        
        x_all(end+1:end+length(xWC)) = xWC;
        F_all(end+1:end+length(FWC)) = FWC;
    end
end

% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);

c1 = colorbar(ax1);
if colorBy == 1
    caxis(ax1,[0 100]);
    c1.Ticks = [0,5,10,20,40,60,80,100];
    %caxis(ax1,[0 log10(110)-1])
    %c1.Ticks = log10([0,5,10,20,40,60,80,100]+10)-1;
    %c1.TickLabels = {0,5,10,20,40,60,80,100};
elseif colorBy == 2

    caxis(ax1,[minPhi maxPhi]);
    c1.Ticks = phi_list/100;

elseif colorBy == 4
    caxis(ax1,[1.6988,6])
end

if xc ~= 0
    colorbar(ax2);
    colorbar(ax3);
end

