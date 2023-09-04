my_vol_frac_markers = ['>','s','o','d','h'];

NAME = '';

% 11/18 phi0 = 0.6328;
% 11/18 sigmastar = 17.1656;
phi0 = 0.5882;
sigmastar = 14.9773;

C = ones(2,1);
%C = [1,1,1.2,1,0.65];
G = ones(8,1);
F = @(sigma) exp(-(sigmastar ./ sigma));
xc = 16;


%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = viridis(256); 
fig1 = figure;
ax1 = axes('Parent', fig1,'XScale','log','YScale','log');
ax1.XLabel.String = "x";
ax1.YLabel.String = "F";
ax1.XLim = [10^(-7),10^2]; %TODO delete
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
end

fig4 = figure('visible','off');
ax4 = axes('Parent', fig4,'XScale','log','YScale','log');
ax4.XLabel.String = "\phi_0-\phi";
ax4.YLabel.String = "\eta";
colormap(ax4,cmap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stressTable = cp_data_trimmed;
phi_list = [46,48,50,52,54];
x_all = zeros(0,1);
F_all = zeros(0,1);
%for ii = 1:length(data_by_vol_frac)
jj = 1;
for ii = 1  
    %for jj = 1
    %for jj = 1:length(volt_list)
        %voltage = volt_list(jj);
        phi = phi_list(ii)/100;
        eta = stressTable(stressTable(:,1)==phi,4);
        sigma = stressTable(stressTable(:,1)==phi,3);
        
        %myColor = voltage*ones(size(sigma));
        %myColor = phi*ones(size(sigma));
        %myColor = log(sigma);
        myColor = cmap(round(1+255*(0.54-phi)/(0.54-0.44)),:);
        
        xWC = G(jj)*C(ii)*F(sigma) ./ (-1*phi+phi0);
        FWC = eta*(phi0-phi)^2;
        H = eta.*(G(jj)*C(ii)*F(sigma)).^2;

        myMarker = my_vol_frac_markers(ii);
        
        %scat = scatter(sigma,eta,[],myColor,'filled',myMarker);
        hold(ax1,'on');
        %scatter(ax1,xWC,FWC,[],myColor,'filled',myMarker);
        plot(ax1,xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor); % doesnt work
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
    %end
end

% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);

colorbar(ax1);
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