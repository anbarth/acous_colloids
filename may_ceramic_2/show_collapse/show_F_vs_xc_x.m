function show_F_vs_xc_x(stressTable, paramsVector, modelHandle, varargin)

my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">"];

phi_list = unique(stressTable(:,1));
vol_frac_plotting_range = length(phi_list):-1:1;
volt_plotting_range = 1:7;
highlight_stress = 0;
colorBy = 1; % 1 for V, 2 for phi, 3 for E0, 4 for stress
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

xc=1;

minPhi = min(phi_list);
maxPhi = max(phi_list);
volt_list = [0,5,10,20,40,60,80];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if colorBy == 2
    cmap = viridis(256); 
elseif colorBy == 4
    cmap = winter(256);
else
    cmap = plasma(256);
end

fig_xc_x = figure;
ax_xc_x = axes('Parent', fig_xc_x,'XScale','log','YScale','log');
hold(ax_xc_x,'on');
ax_xc_x.XLabel.String = "x_c-x";
ax_xc_x.YLabel.String = "F";
colormap(ax_xc_x,cmap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x_all,F_all,delta_F_all,F_hat_all,~,~,~] = modelHandle(stressTable, paramsVector);

if colorBy==3
    logMinE0 = log(acoustic_energy_density(5));
    logMaxE0 = log(acoustic_energy_density(80));
end

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
        elseif colorBy == 3  
            E0 = acoustic_energy_density(voltage);
            if E0==0
                myColor = [0 0 0];
            else
                myColor = cmap(round(1+255*(log(E0)-logMinE0)/( logMaxE0-logMinE0 )),:);
            end
        elseif colorBy == 4
            myColor = log(sigma);
        end
        

        % sort in order of ascending x
        [x,sortIdx] = sort(x,'ascend');
        F = F(sortIdx);
        delta_F = delta_F(sortIdx);
        myMarker = my_vol_frac_markers(ii);
        if colorBy <= 3
           if showLines
               myMarker = strcat(myMarker,'-');
           end
           if showErrorBars
               errorbar(ax_xc_x,xc-x,F,delta_F,myMarker,'Color',myColor,'MarkerFaceColor',myColor);
           else
                plot(ax_xc_x,xc-x,F,myMarker,'Color',myColor,'MarkerFaceColor',myColor);
           end
        else
            scatter(ax_xc_x,xc-x,F,[],myColor,'filled',myMarker);
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
            
            scatter(ax_xc_x,xc-xHighlight,FHighlight,'red','filled',myMarker);
            
        end
    end
end


if showInterpolatingFunction
    [x_all,sortIdx] = sort(x_all,'ascend');
    F_hat_all = F_hat_all(sortIdx);
    plot(ax_xc_x,xc-x_all,F_hat_all,'-r','LineWidth',2)

end



c2 = colorbar(ax_xc_x);
if colorBy == 1
    caxis(ax_xc_x,[0 80]);
    c2.Ticks = [0,5,10,20,40,60,80];
elseif colorBy == 2
    caxis(ax_xc_x,[minPhi maxPhi]);
    %c2.Ticks = phi_list;
    c2.Ticks = round(100*phi_list)/100;
elseif colorBy ==3
    clim(ax_xc_x,[log(acoustic_energy_density(5)) log(acoustic_energy_density(80))])
    c2.Ticks = log(acoustic_energy_density([5 10 20 40 60 80]));
    c2.TickLabels = num2cell( round(acoustic_energy_density([5 10 20 40 60 80])*100)/100 );
elseif colorBy == 4
    % TODO what are these numbers? lol
    caxis(ax_xc_x,[1.6988,6])
end


end