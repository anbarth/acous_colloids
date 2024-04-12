my_vol_frac_markers = ['>','s','o','d','h','pentagram'];

collapse_params;

stressTable = march_data_table_04_04;
phi_list = [44,48,52,56,59];
minPhi = 0.4;
maxPhi = 0.6;
volt_list = [0,5,10,20,40,60,80,100];

colorBy = 2; % 1 for V, 2 for phi, 3 for P, 4 for sigma, 0 for nothing
phi_range = 1:5; % which volume fractions to include

xc=10;


%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = turbo;
%cmap = viridis(256); 
fig_uncollapsed = figure;
ax_uncollapsed = axes('Parent', fig_uncollapsed,'XScale','log','YScale','log');
ax_uncollapsed.XLabel.String = "x";
ax_uncollapsed.YLabel.String = "F";
ax_uncollapsed.XLim = [10^-5, 100];
colormap(ax_uncollapsed,cmap);
if xc ~= 0
    xline(ax_uncollapsed,xc);
end
hold(ax_uncollapsed,'on');

fig_collapsed = figure;
ax_collapsed = axes('Parent', fig_collapsed,'XScale','log','YScale','log');
ax_collapsed.XLabel.String = "x";
ax_collapsed.YLabel.String = "F";
ax_collapsed.XLim = [10^-5, 100];
colormap(ax_collapsed,cmap);
if xc ~= 0
    xline(ax_collapsed,xc);
end
hold(ax_collapsed,'on');

if xc~= 0
    fig_xc_collapsed = figure;
    ax_xc_collapsed = axes('Parent', fig_xc_collapsed,'XScale','log','YScale','log');
    ax_xc_collapsed.XLabel.String = "x_c-x";
    ax_xc_collapsed.YLabel.String = "F";
    colormap(ax_xc_collapsed,cmap);
    hold(ax_xc_collapsed,'on');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_all = zeros(0,1);
F_all = zeros(0,1);
Cv = zeros(0,3);
sigma_all = zeros(0,1);


for ii = phi_range
    phi = phi_list(ii)/100;
    myMarker = my_vol_frac_markers(ii);

    % first, plot 0V stuff
    myData_0V = stressTable(stressTable(:,1)==phi & stressTable(:,3)==0,:);
    sigma_0V = myData_0V(:,2);
    eta_0V = myData_0V(:,4);
    
    % it's important for myInterpolate that x_0V and F_0V be sorted
    % according to ascending stress order
    [sigma_0V,sortIdx] = sort(sigma_0V,'ascend');
    eta_0V = eta_0V(sortIdx);

    F_0V = eta_0V*(phi0-phi)^2;
    x_0V = C(ii)*f(sigma_0V) ./ (-1*phi+phi0);
    
    plot(ax_uncollapsed,x_0V,F_0V,strcat(myMarker,'-'),'Color',cmap(1,:),'MarkerFaceColor',cmap(1,:));
    plot(ax_collapsed,x_0V,F_0V,strcat(myMarker,'-'),'Color',cmap(1,:),'MarkerFaceColor',cmap(1,:));
    if xc~= 0
        plot(ax_xc_collapsed,xc-x_0V,F_0V,strcat(myMarker,'-'),'Color',cmap(1,:),'MarkerFaceColor',cmap(1,:));
    end


    % now look at everything else!
    myData = stressTable(stressTable(:,1)==phi,:);
    sigma = myData(:,2);
    eta = myData(:,4);
    voltage = myData(:,3);
    x = C(ii)*f(sigma) ./ (-1*phi+phi0);    
    F = eta*(phi0-phi)^2;

    % now find the shift for each point by interpolating onto 0V curve
    A = zeros(size(x));
    for jj=1:length(x)
        myX = x(jj);
        myF = F(jj);
        myX_target = myInterpolate(myF,x_0V,F_0V);
        A(jj) = myX_target/myX;
        if(isnan(A(jj)))
            A(jj)=1;
        end
    end

    x_new = A.*x;

    if colorBy == 1
        myColor = cmap(round(1+255*voltage/100),:);
    elseif colorBy == 2
        myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    elseif colorBy == 3
        myColor = log(P);
    elseif colorBy == 4
        myColor = log(sigma);
    elseif colorBy == 0
        myColor = [50, 168, 82]*1/256;
    end
    

    % plot collapsed and uncollapsed data
    scatter(ax_collapsed,x_new,F,[],myColor,'filled',myMarker);
    scatter(ax_collapsed,x,F,[],myColor,myMarker);
    scatter(ax_uncollapsed,x,F,[],myColor,'filled',myMarker);
    if xc~= 0
        scatter(ax_xc_collapsed,xc-x_new,F,[],myColor,'filled',myMarker);
        scatter(ax_xc_collapsed,xc-x,F,[],myColor,myMarker);
    end

    x_all(end+1:end+length(x)) = x;
    F_all(end+1:end+length(F)) = F;
    sigma_all(end+1:end+length(A)) = sigma;
    Cv(end+1:end+length(A),:) = [phi*ones(length(A),1), voltage, A];
end


% add colorbars to plots
c1 = colorbar(ax_uncollapsed);
if colorBy == 1
    caxis(ax_uncollapsed,[0 100]);
    c1.Ticks = [0,5,10,20,40,60,80,100];
    %caxis(ax_uncollapsed,[0 log10(110)-1])
    %c1.Ticks = log10([0,5,10,20,40,60,80,100]+10)-1;
    %c1.TickLabels = {0,5,10,20,40,60,80,100};
elseif colorBy == 2
    caxis(ax_uncollapsed,[minPhi maxPhi]);
    c1.Ticks = phi_list/100;
end







%close all
%close(fig_collapsed)
%close(fig_uncollapsed)
%close(fig_xc_collapsed)


