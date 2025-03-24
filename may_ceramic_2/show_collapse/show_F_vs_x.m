function show_F_vs_x(stressTable,paramsVector,modelHandle,varargin)

my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">"];

phi_list = unique(stressTable(:,1));
%phi_list = [0.1999 0.2503 0.2997 0.3500 0.4009 0.4396 0.4604 0.4811 0.5193 0.5398 0.5607 0.5898 0.6101]';
vol_frac_plotting_range = length(phi_list):-1:1;
volt_plotting_range = 1:7;
highlight_stress = 0;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;
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
        elseif strcmp(fieldName,'ShowLines')
            showLines = varargin{ii+1};
        elseif strcmp(fieldName,'ShowInterpolatingFunction')
            showInterpolatingFunction = varargin{ii+1};
        elseif strcmp(fieldName,'ShowErrorBars')
            showErrorBars = varargin{ii+1};
        elseif strcmp(fieldName,'HighlightStress')
            highlight_stress = varargin{ii+1};
        end
    end
end

minPhi = min(phi_list);
maxPhi = max(phi_list);
volt_list = [0,5,10,20,40,60,80];

%%%%%%%%%%%%%%%%%% make the figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if colorBy == 2
    cmap = viridis(256); 
elseif colorBy == 4
    cmap = winter(256);
else
    cmap = plasma(256);
end

fig_collapse = figure;
ax_collapse = axes('Parent', fig_collapse,'XScale','log','YScale','log');
hold(ax_collapse,'on');
ax_collapse.XLabel.String = "x";
ax_collapse.YLabel.String = "F";

if showMeera
    meeraMultiplier_X = 1/13.8;
    meeraMultiplier_Y = 3;
    [meeraX,meeraY]=stealMeerasData();
    scatter(ax_collapse,meeraX*meeraMultiplier_X,meeraY*meeraMultiplier_Y,[],[0.5 0.5 0.5]);
end
%ax_collapse.XLim = [10^-3, 1.5];
%ax_collapse.XLim = [10^-8, 1.5];
%ax_collapse.YLim = [0.4,110];
colormap(ax_collapse,cmap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_all,F_all,delta_F_all,F_hat_all,~,~,~] = modelHandle(stressTable, paramsVector);

for ii = vol_frac_plotting_range
    for jj = volt_plotting_range

        voltage = volt_list(jj);
        phi = phi_list(ii);

        myData = stressTable(:,1)==phi & stressTable(:,3)==voltage;
        x = x_all(myData);
        F = F_all(myData);
        delta_F = delta_F_all(myData);


        if colorBy == 1
            myColor = cmap(round(1+255*voltage/80),:);
        elseif colorBy == 2
            myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
        elseif colorBy == 4
            myColor = log(sigma);
        end        

        % sort in order of ascending x
        [x,sortIdx] = sort(x,'ascend');
        F = F(sortIdx);
        delta_F = delta_F(sortIdx);
        myMarker = my_vol_frac_markers(ii);
        if colorBy < 3
           if showLines
               myMarker = strcat(myMarker,'-');
           end
           if showErrorBars
               errorbar(ax_collapse,x,F,delta_F,myMarker,'Color',myColor,'MarkerFaceColor',myColor);
           else
                plot(ax_collapse,x,F,myMarker,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
           end
        else
            scatter(ax_collapse,x,F,[],myColor,'filled',myMarker);
        end

        if highlight_stress
            myDataHighlight = stressTable(:,1)==phi & stressTable(:,3)==voltage & stressTable(:,2)==highlight_stress;
            xHighlight = x_all(myDataHighlight);
            FHighlight = F_all(myDataHighlight);
            s=scatter(ax_collapse,xHighlight,FHighlight,'red','filled',myMarker);
            uistack(s,'bottom')
        end

    end
end

if highlight_stress
    for ii = vol_frac_plotting_range
        for jj = volt_plotting_range
    
            voltage = volt_list(jj);
            phi = phi_list(ii);
            
    
            myDataHighlight = stressTable(:,1)==phi & stressTable(:,3)==voltage & stressTable(:,2)==highlight_stress;
            xHighlight = x_all(myDataHighlight);
            FHighlight = F_all(myDataHighlight);
    
            myMarker = my_vol_frac_markers(ii);
            
            scatter(ax_collapse,xHighlight,FHighlight,'red','filled',myMarker);
            
        end
    end
end


if showInterpolatingFunction
    [x_all,sortIdx] = sort(x_all,'ascend');
    F_hat_all = F_hat_all(sortIdx);
    plot(ax_collapse,x_all,F_hat_all,'-r','LineWidth',2)
end

c1 = colorbar(ax_collapse);
if colorBy == 1
    clim(ax_collapse,[0 80]);
    c1.Ticks = [0,5,10,20,40,60,80];
elseif colorBy == 2
    clim(ax_collapse,[minPhi maxPhi]);
    %c1.Ticks = phi_list;
    c1.Ticks = round(phi_list*100)/100;
end


end