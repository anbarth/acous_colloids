my_vol_frac_markers = ['>','s','o','d','h','pentagram'];

vol_frac_plotting_range = 2:6;
volt_plotting_range = 1;
colorBy = 2; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = true;
showMeera = false;
%xc=0;
%xc = 7.9;
xc = 10;

collapse_params;
stressTable = ceramic_data_table_03_02;
phi_list = [40,44,48,52,56,59];
minPhi = 0.3;
maxPhi = 0.6;
volt_list = [0,5,10,20,40,60,80,100];

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cmap = turbo;
cmap = viridis(256); 
%cmap = plasma(256);



fig_xc_x = figure;
ax_xc_x = axes('Parent', fig_xc_x,'XScale','log','YScale','log');
hold(ax_xc_x,'on');
ax_xc_x.XLabel.String = "x_c-x";
ax_xc_x.YLabel.String = "F";
colormap(ax_xc_x,cmap);
    




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
        

        xWC = C(ii)*A(P).*f(sigma) ./ (-1*phi+phi0);
        FWC = eta*(phi0-phi)^2;

        myMarker = my_vol_frac_markers(ii);

        if showLines
            [xWC,sortIdx] = sort(xWC,'ascend');
            FWC = FWC(sortIdx);
            plot(ax_xc_x,xc-xWC,FWC,strcat(myMarker,'-'),'Color',myColor,'MarkerFaceColor',myColor);
        else
            scatter(ax_xc_x,xc-xWC,FWC,[],myColor,'filled',myMarker);
        end

        
        x_all(end+1:end+length(xWC)) = xWC;
        F_all(end+1:end+length(FWC)) = FWC;
    end
end

% trim out nan values
trim_me = ~isnan(F_all);
x_all = x_all(trim_me);
F_all = F_all(trim_me);
xc_x_all = xc - x_all;

% exclude low-stress region
keep_me = xc_x_all < 1;
x_all = x_all(keep_me);
F_all = F_all(keep_me);
xc_x_all = xc_x_all(keep_me);

% do a linear fit and plot it
p = polyfit(log(xc_x_all),log(F_all),1);
F_predicted = exp(p(1)*log(xc_x_all)+p(2));
plot(ax_xc_x,xc_x_all,F_predicted,'k','LineWidth',1)
disp(p(1))

% calculate R2
logF_avg = mean(log(F_all));
SSres = sum( (log(F_all)-log(F_predicted)).^2 );
SStot = sum( (log(F_all)-logF_avg).^2 );
R2 = 1-SSres/SStot;
disp(R2);


c2 = colorbar(ax_xc_x);
if colorBy == 1
    caxis(ax_xc_x,[0 100]);
    c2.Ticks = [0,5,10,20,40,60,80,100];
elseif colorBy == 2
    caxis(ax_xc_x,[minPhi maxPhi]);
    c2.Ticks = phi_list/100;
elseif colorBy == 4
    % TODO what are these numbers? lol
    caxis(ax_xc_x,[1.6988,6])
end
