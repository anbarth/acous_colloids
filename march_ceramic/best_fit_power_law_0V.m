my_vol_frac_markers = ["o","diamond",">","square","<","hexagram","^","pentagram","v"];

vol_frac_plotting_range = 1:9;
volt_plotting_range = 1:8;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;
showMeera = false;

xc=1;

%collapse_params;
[eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,9);
f = @(sigma,jj) exp(-sigmastar(jj)./sigma);
stressTable = march_data_table_05_02;
phi_list = unique(stressTable(:,1));
minPhi = 0.1997;
maxPhi = 0.6;
volt_list = [0,5,10,20,40,60,80,100];

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cmap = turbo;
%cmap = viridis(256); 
cmap = plasma(256);

fig_collapse = figure;
ax_collapse = axes('Parent', fig_collapse,'XScale','log','YScale','log');
hold(ax_collapse,'on');
ax_collapse.XLabel.String = "x";
ax_collapse.YLabel.String = "F";
if showMeera
    scatter(ax_collapse,meeraX*meeraMultiplier_X,meeraY*meeraMultiplier_Y,[],[0.5 0.5 0.5]);
end
ax_collapse.XLim = [10^-3, 3];
colormap(ax_collapse,cmap);
if xc ~= 0
    xline(ax_collapse,xc);
end


if xc ~= 0
    fig_xc_x = figure;
    ax_xc_x = axes('Parent', fig_xc_x,'XScale','log','YScale','log');
    hold(ax_xc_x,'on');
    ax_xc_x.XLabel.String = "x_c-x";
    ax_xc_x.YLabel.String = "F";
    colormap(ax_xc_x,cmap);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_all = zeros(0,1);
F_all = zeros(0,1);


for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii);
        myData = stressTable( stressTable(:,1)==phi & stressTable(:,3)==voltage,:);
        sigma = myData(:,2);
        eta = myData(:,4);
        delta_eta = myData(:,5);

        
        % calculate nondimensionalized power
        P = zeros(size(sigma));
        for kk = 1:length(P)
            P(kk) = calculateP(phi,sigma(kk),voltage,stressTable);
        end


        if colorBy == 1
            myColor = cmap(round(1+255*voltage/100),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

        elseif colorBy == 3
            myColor = log(P);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        xWC = C(ii,jj)*f(sigma,jj) ./ (-1*phi+phi0);
        FWC = eta*(phi0-phi)^2;


        myMarker = my_vol_frac_markers(ii);
        if showLines && colorBy < 3
            % sort in order of ascending x
            [xWC,sortIdx] = sort(xWC,'ascend');
            FWC = FWC(sortIdx);
   
            plot(ax_collapse,xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);

            if xc ~= 0
                plot(ax_xc_x,xc-xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
            end

        else
            scatter(ax_collapse,xWC,FWC,[],myColor,'filled',myMarker);
         
            if xc ~= 0
                scatter(ax_xc_x,xc-xWC,FWC,[],myColor,'filled',myMarker);
            end

        end

        x_all(end+1:end+length(xWC)) = xWC;
        F_all(end+1:end+length(FWC)) = FWC;
    end
end

% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);

%disp(size(x_all))

% try fitting F vs x to F = a (xc-x)^b
fitfxn = @(s) s(1)*(xc-x_all).^s(2);
costfxn = @(s) sum(( (fitfxn(s)-F_all)./F_all ).^2);

opts = optimoptions('fmincon','Display','final');
best_params = fmincon(costfxn, [0.001,-1],[],[],...
    [],[],[],[],[],opts);
my_const = best_params(1);
my_exp = best_params(2);
disp(best_params)

x_fake = linspace(min(x_all),max(x_all));
F_fake =  my_const*(xc-x_fake).^my_exp;

plot(ax_collapse,x_fake,F_fake,'Color','k','MarkerFaceColor',myColor,'LineWidth',1);

if xc ~= 0
    plot(ax_xc_x,xc-x_fake,F_fake,'Color','k','MarkerFaceColor',myColor,'LineWidth',1);
end


c1 = colorbar(ax_collapse);
if colorBy == 1
    caxis(ax_collapse,[0 100]);
    c1.Ticks = [0,5,10,20,40,60,80,100];
elseif colorBy == 2
    caxis(ax_collapse,[minPhi maxPhi]);
    c1.Ticks = phi_list;
elseif colorBy == 4
    % TODO what are these numbers? lol
    caxis(ax_collapse,[1.6988,6])
end

if xc ~= 0
    c2 = colorbar(ax_xc_x);

    if colorBy == 1
        caxis(ax_xc_x,[0 100]);
        c2.Ticks = [0,5,10,20,40,60,80,100];
    elseif colorBy == 2
        caxis(ax_xc_x,[minPhi maxPhi]);
        c2.Ticks = phi_list;
    elseif colorBy == 4
        % TODO what are these numbers? lol
        caxis(ax_xc_x,[1.6988,6])
    end

end


