my_vol_frac_markers = ['>','s','o','d','h'];

NAME = '';

phi0 = 0.6231;
%phi0=.5923;
sigmastar = 17.3322;

F = @(sigma) exp(-(sigmastar ./ sigma));


%C = ones(1,4);
%C = [1,1.5];
%C = [1,1,1,0.5];
%G = ones(8,1);
%G = [1,1,0.9,0.85,0.8,0.75,0.7,0.65];

C1 = [1.0000    1.3000    1.1000    0.7000];
C2 = 1.05*[1.0000    1.2000    1.1000    0.7000];
C3 = [1.0000    1.2600    1.2000    0.7000];
C4 = 1.1*[0.9800    1.0790    0.9500    0.6000];
C5 = 1.1*[0.9000    1.0000    0.9450    0.6000];
C6 = 1.2*[0.8500    0.8500    0.8000    0.5540];
C7 = 1.2*[0.8200    0.8120    0.7600    0.5500];
C8 = 1.25*[0.8000    0.7500    0.7200    0.4800];
C = [C1;C2;C3;C4;C5;C6;C7;C8];
%C = ones(8,4);

vol_frac_plotting_range = 1:4;
volt_plotting_range = 1:8;
colorBy = 1; % 1 for V, 2 for phi
showLines = false;

xc = 15;

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = viridis(256); 
fig1 = figure;
ax1 = axes('Parent', fig1,'XScale','log','YScale','log');
ax1.XLabel.String = "x";
ax1.YLabel.String = "F";
ax1.XLim = [10^(-3),10^1.5]; %TODO delete
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
        sigma = CSS*myData(:,3);
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

        
        %myColor = voltage*ones(size(sigma));
        %myColor = phi*ones(size(sigma));
        %myColor = log(sigma);
        if colorBy == 1
            myColor = cmap(round(1+255*voltage/100),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi-0.44)/(0.55-0.44)),:);
        end
        
        
        %xWC = G(jj)*C(ii)*F(sigma) ./ (-1*phi+phi0);
        xWC = C(jj,ii)*F(sigma) ./ (-1*phi+phi0);
        FWC = eta*(phi0-phi)^2;
        %H = eta.*(G(jj)*C(ii)*F(sigma)).^2;
        H = eta.*(C(jj,ii)*F(sigma)).^2;

        myMarker = my_vol_frac_markers(ii);
        hold(ax1,'on');
        if showLines
            plot(ax1,xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
        else
            scatter(ax1,xWC,FWC,[],myColor,'filled',myMarker);
        end
        
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
elseif colorBy == 2
    caxis(ax1,[.44 .55]);
    c1.Ticks = phi_list/100;
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