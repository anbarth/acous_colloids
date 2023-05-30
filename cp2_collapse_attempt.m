my_vol_frac_markers = ['>','s','o','d','h'];

NAME = '';

vol_frac_plotting_range = 1:4;
volt_plotting_range = 1:8;
colorBy = 3; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;
fudge = false;
xc = 0;

cp2_collapse_parameters;

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = viridis(256); 
%cmap = plasma(256);
fig1 = figure;
ax1 = axes('Parent', fig1,'XScale','log','YScale','log');
ax1.XLabel.String = "x";
ax1.YLabel.String = "F";
hold(ax1,'on');
%scatter(meeraX,meeraY/0.2*0.04,[],[0.7 0.7 0.7]);
%ax1.XLim = [10^(-5),10^1.5]; %TODO delete
ax1.YLim = [10^(-1.5),3]; %TODO delete
colormap(ax1,cmap);
if xc ~= 0
    xline(ax1,xc);
end

%meeraFig = figure(1);
%meeraAx = axes('Parent', meeraFig);

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
end

fig4 = figure('visible','off');
ax4 = axes('Parent', fig4,'XScale','log','YScale','log');
ax4.XLabel.String = "\phi_0-\phi";
ax4.YLabel.String = "\eta";
colormap(ax4,cmap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stressTable = cp_data_01_18;
phi_list = [44,48,50,54];
volt_list = [0,5,10,20,40,60,80,100];
x_all = zeros(0,1);
F_all = zeros(0,1);


for ii = vol_frac_plotting_range
    for jj = volt_plotting_range
    %for jj = 1:length(volt_list)
        voltage = volt_list(jj);
        phi = phi_list(ii)/100;
        myData = stressTable( stressTable(:,1)==phi & stressTable(:,2)==voltage,:);
        sigma_rheo = myData(:,3);
        sigma = sigma_rheo*CSS;
        eta = CSV/1000*myData(:,4);

        

        % account for missing data (TODO delete)
        for n=1:length(eta)
            if eta(n)==0
                eta(n) = CSV/1000*myData(n,4);
            end
        end
        
        delta_eta_heating = CSV/1000*(myData(:,7)-myData(:,8));
        % account for missing data (TODO delete)
        for n=1:length(delta_eta_heating)
            if myData(n,8)==0
                delta_eta_heating(n)=0;
            end
        end
        %eta = eta + delta_eta_heating;
        
        % calculate nondimensionalized power
        % TODO this is inefficient and bad coding
        % really i feel like P should just be like, another column in
        % stress table
        % i could just calculate it at the beginning
        P = zeros(size(sigma));
        for kk = 1:length(sigma)
            eta_0V = CSV/1000*stressTable(stressTable(:,1)==phi & stressTable(:,3)==sigma_rheo(kk) & stressTable(:,2)==0,4);
            gamma_dot_0V = sigma(kk)/eta_0V;
            P(kk) = voltage^2/sigma(kk)/gamma_dot_0V;
        end

        % fudge phi
        if fudge
            phi = phi_fudge_factors(phi_fudge_factors(:,1)==phi,2);
        end

        %myColor = voltage*ones(size(sigma));
        %myColor = phi*ones(size(sigma));
        %myColor = log(sigma);
        if colorBy == 1
            myColor = cmap(round(1+255*voltage/100),:);
            %myColor = cmap(round(1+255*(log10(voltage+10)-1)/(log10(110)-1)),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi-0.44)/(0.55-0.44)),:);
        elseif colorBy == 3
            myColor = log(P);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        my_f_mod = f_mod(ii,1:length(sigma))';
        xWC = C(ii)*A(P).*f(sigma).*my_f_mod ./ (-1*phi+phi0);
        FWC = eta*(phi0-phi)^2;
        %H = eta.*(G(jj)*C(ii)*f(sigma)).^2;
        H = eta.*(C(ii)*f(sigma)).^2;

        myMarker = my_vol_frac_markers(ii);
        hold(ax1,'on');
        if showLines && colorBy < 3
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
    caxis(ax1,[.44 .55]);
    c1.Ticks = phi_list/100;
elseif colorBy == 4
    caxis(ax1,[1.6988,6])
end

if xc ~= 0
    colorbar(ax2);
    colorbar(ax3);
end

if ~strcmp(NAME,'')
    saveas(fig1,strcat('../10_24_meeting/',NAME,'.png'));
    if xc ~= 0
        saveas(fig2,strcat('../10_24_meeting/',NAME,'_xc-x.png'));
        saveas(fig3,strcat('../10_24_meeting/',NAME,'_H.png'));
    end
end