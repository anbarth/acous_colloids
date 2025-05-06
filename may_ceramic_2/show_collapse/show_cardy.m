function show_cardy(stressTable, paramsVector, modelHandle, varargin)



my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">"];

phi_list = unique(stressTable(:,1));
vol_frac_plotting_range = length(phi_list):-1:1;
volt_plotting_range = 1:7;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showMeera = false;
showInterpolatingFunction = false;
showErrorBars = false;
showLines = false;
alpha = 1;


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
        elseif strcmp(fieldName,'alpha')
            alpha = varargin{ii+1};
        elseif strcmp(fieldName,'ShowLines')
            showLines = varargin{ii+1};
        end
    end
end

xc=1;
alpha_interpolate = alpha;
%alpha_interpolate = 1;


minPhi = min(phi_list);
maxPhi = max(phi_list);
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
ax_cardy.XLabel.String = "x^{-1/\alpha}-x_c^{-1/\alpha}";
ax_cardy.YLabel.String = "H";
colormap(ax_cardy,cmap);
if showMeera
    scatter(ax_cardy,meeraHX,meeraHY*0.2,[],[0.7 0.7 0.7]);
end
%ax_cardy.XLim = [10^-2, 10^4];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_all,F_all,delta_F_all,F_hat_all,~,~,~] = modelHandle(stressTable, paramsVector);

for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii);

        myData = stressTable(:,1)==phi & stressTable(:,3)==voltage;
        x = x_all(myData);
        F = F_all(myData);
        delta_F = delta_F_all(myData);
        H = F .* x.^(2/alpha);
        delta_H = delta_F .* x.^(2/alpha);
        x_axis_variable = x.^(-1/alpha)-xc^(-1/alpha);
        %x_axis_variable = x;

        if colorBy == 1
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 3
            P_color = P;
            P_color(P_color==0) = minP;
            P_color(P_color>maxP) = maxP;
            myColor = cmap(round(1+255*(log(P_color)-log(minP))/(log(maxP)-log(minP))),:);
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        % sort in order of ascending x
        [x_axis_variable,sortIdx] = sort(x_axis_variable,'ascend');
        H = H(sortIdx);
        delta_H = delta_H(sortIdx);
        myMarker = my_vol_frac_markers(ii);
        if colorBy < 3
           if showLines
               myMarker = strcat(myMarker,'-');
           end
           if showErrorBars
               errorbar(ax_cardy,x_axis_variable,H,delta_H,myMarker,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',0.5);
               % disp(x_axis_variable)
           else
                plot(ax_cardy,x_axis_variable,H,myMarker,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',0.5);
           end
        else
            scatter(ax_cardy,x_axis_variable,H,[],myColor,'filled',myMarker);
        end
        

    end
end




if showInterpolatingFunction
    [x_all,sortIdx] = sort(x_all,'ascend');
    F_hat_all = F_hat_all(sortIdx);

    xi_all = x_all.^(-1/alpha_interpolate)-1;
    plot(ax_cardy,xi_all,F_hat_all.*x_all.^(2/alpha_interpolate),'-r','LineWidth',2)
    eta0 = paramsVector(1);
    delta = paramsVector(3);
    A = paramsVector(4);
    plot(ax_cardy,xi_all,A*xi_all.^delta,'-k','LineWidth',1);
    plot(ax_cardy,xi_all,eta0*xi_all.^-2,'-k','LineWidth',1);
end



end