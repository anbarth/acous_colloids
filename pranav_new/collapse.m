my_vol_frac_markers = ['>','s','o','d','h','p','<','^'];

vol_frac_plotting_range = 1:8;
volt_plotting_range = 1;
colorBy = 2; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = true;
showMeera = false;
xc=0;
%xc = 8;

collapse_params;
stressTable = pranav_data_table;
phi_list = [44,46,48,50,52,53,54,55];
minPhi = 0.44;
maxPhi = 0.55;
volt_list = [0,5,10,20,40,60,80,100];

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = viridis(256); 
%cmap = plasma(256);
fig_collapse = figure;
ax_collapse = axes('Parent', fig_collapse,'XScale','log','YScale','log');
ax_collapse.XLabel.String = "x";
ax_collapse.YLabel.String = "F";

if showMeera
    hold(ax_collapse,'on');
    scatter(meeraX*meeraMultiplier_X,meeraY*meeraMultiplier_Y,[],[0.5 0.5 0.5]);
end
%ax1.XLim = [10^(-5),10^1.5]; %TODO delete
ax_collapse.XLim = [10^-5, 100];
%ax1.YLim = [10^(-1.5),100]; %TODO delete
colormap(ax_collapse,cmap);
if xc ~= 0
    xline(ax_collapse,xc);
end


if xc ~= 0
    fig_xc_x = figure;
    fig_cardy = figure;
    ax_xc_x = axes('Parent', fig_xc_x,'XScale','log','YScale','log');
    ax_xc_x.XLabel.String = "x_c-x";
    ax_xc_x.YLabel.String = "F";
    colormap(ax_xc_x,cmap);
    ax_cardy = axes('Parent', fig_cardy,'XScale','log','YScale','log');
    ax_cardy.XLabel.String = "1/x-1/x_c";
    ax_cardy.YLabel.String = "H";
    ax_cardy.Title.String = strcat("x_c = ",num2str(xc));
    ax_xc_x.Title.String = strcat("x_c = ",num2str(xc));
    colormap(ax_cardy,cmap);
    if showMeera
        hold(ax_cardy,'on')
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
        P = zeros(size(sigma));
        for kk = 1:length(P)
            P(kk) = calculateP(phi,sigma(kk),voltage,stressTable);
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
        hold(ax_collapse,'on');
        if showLines && colorBy < 3
            % sort in order of ascending x
            [xWC,sortIdx] = sort(xWC,'ascend');
            FWC = FWC(sortIdx);
            plot(ax_collapse,xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
        else
            scatter(ax_collapse,xWC,FWC,[],myColor,'filled',myMarker);
            %scatter(ax1,xWC,FWC,[],myColor,'filled',myMarker,'MarkerFaceAlpha',0.5);
        end

        %hold(meeraAx,'on');
        %scatter(meeraAx,xWC,FWC,[],myColor,'filled',myMarker);
        
        if xc ~= 0
            hold(ax_xc_x,'on');
            scatter(ax_xc_x,xc-xWC,FWC,[],myColor,'filled',myMarker);
            hold(ax_cardy,'on');
            scatter(ax_cardy, abs(1/xc-1./xWC),H,[],myColor,'filled',myMarker);
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

c1 = colorbar(ax_collapse);
if colorBy == 1
    caxis(ax_collapse,[0 100]);
    c1.Ticks = [0,5,10,20,40,60,80,100];
    %caxis(ax1,[0 log10(110)-1])
    %c1.Ticks = log10([0,5,10,20,40,60,80,100]+10)-1;
    %c1.TickLabels = {0,5,10,20,40,60,80,100};
elseif colorBy == 2

    caxis(ax_collapse,[minPhi maxPhi]);
    c1.Ticks = phi_list/100;

elseif colorBy == 4
    caxis(ax_collapse,[1.6988,6])
end

if xc ~= 0
    colorbar(ax_xc_x);
    colorbar(ax_cardy);
end

