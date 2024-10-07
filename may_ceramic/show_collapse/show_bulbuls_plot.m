function show_bulbuls_plot(stressTable, paramsVector, varargin)
%alpha = 3; xc=950;
alpha = 1; xc=11.5;
%alpha = 0.5; xc=3.15;
%alpha = 0.25; xc=1.77;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(paramsVector,13); fxnType = 2;
f = @(sigma,jj) sigma ./ (sigma+sigmastar(jj));

vol_frac_plotting_range = 13:-1:1;
volt_plotting_range = 1:7;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showMeera = false;
showInterpolatingFunction = false;
showErrorBars = false;

for ii=1:2:length(varargin)
    if isa(varargin{ii},'char')
        fieldName = varargin{ii};
        if strcmp(fieldName,'PhiRange')
            vol_frac_plotting_range = varargin{ii+1};
        elseif strcmp(fieldName,'VoltRange')
            volt_plotting_range = varargin{ii+1};
        elseif strcmp(fieldName,'ColorBy')
            colorBy = varargin{ii+1};
        elseif strcmp(fieldName,'ShowInterpolatingFunction')
            showInterpolatingFunction = varargin{ii+1};
        elseif strcmp(fieldName,'ShowErrorBars')
            showErrorBars = varargin{ii+1};
        end
    end
end



phi_list = unique(stressTable(:,1));
minPhi = 0.17;
maxPhi = 0.62;
volt_list = [0,5,10,20,40,60,80];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if colorBy == 2
    cmap = viridis(256); 
elseif colorBy == 4
    cmap = winter(256);
else
    cmap = plasma(256);
end

fig_cardy = figure;
ax_cardy = axes('Parent', fig_cardy,'XScale','log','YScale','log');
hold(ax_cardy,'on');
ax_cardy.XLabel.String = "f/(\phi_0-\phi)^\alpha";
ax_cardy.YLabel.String = "\eta (\phi_0-\phi)^2";
%ax_cardy.XLabel.String = "f^{-1/\alpha}(\phi_0-\phi)-x_c^{-1/\alpha}";
%ax_cardy.YLabel.String = "\eta f^{2/\alpha}";
colormap(ax_cardy,cmap);
if showMeera
    scatter(ax_cardy,meeraHX,meeraHY*0.2,[],[0.7 0.7 0.7]);
end
%ax_cardy.XLim = [10^-2, 10^4];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii);
        my_phi_fudge = phi_fudge(ii);

        myData = stressTable(:,1)==phi & stressTable(:,3)==voltage;
        sigma = stressTable(myData,2);
        eta = stressTable(myData,4);

        %x_axis_variable = f(sigma,jj)/(phi0-phi)^alpha;
        %y_axis_variable = eta * (phi0-phi).^2;
        y_axis_variable = eta .* f(sigma,jj).^(2/alpha);
        x_axis_variable = (f(sigma,jj)/(phi0-phi)^alpha).^(-1/alpha) - xc^(-1/alpha);
        

        if colorBy == 1
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi+my_phi_fudge-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 3
            P_color = P;
            P_color(P_color==0) = minP;
            P_color(P_color>maxP) = maxP;
            myColor = cmap(round(1+255*(log(P_color)-log(minP))/(log(maxP)-log(minP))),:);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        myMarker = my_vol_frac_markers(ii);


        scatter(ax_cardy, x_axis_variable,y_axis_variable,[],myColor,'filled',myMarker);

        

    end
end


end