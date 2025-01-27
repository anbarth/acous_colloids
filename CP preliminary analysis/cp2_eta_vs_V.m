my_vol_frac_markers = ['>','s','o','d','h'];


%bookmarkRange = 8:14; % 44%
%bookmarkRange = 22:29; % 48%
%bookmarkRange = 35:44; % 50%
%bookmarkRange = 50:60; % 54% -- cutting off 160 Pa due to slip

show_vol_fracs = [.54];
show_stress_min = 0.3;
show_stress_max = 160;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cmap = viridis(256); 
cmap = plasma(256);

legendList = cell(0);

stressTable = sortrows(cp_data_01_18,[1,3]);
bookmarkIndex = 1;
myIter = 0;

figure; hold on; colormap(cmap);
ax1 = gca;
%ax1.XScale = 'log';
ax1.YScale = 'log';

while bookmarkIndex <= size(stressTable,1)
    myIter = myIter+1;
    
    phi = stressTable(bookmarkIndex,1);
    sigma_rheo = stressTable(bookmarkIndex,3);
    sigma = CSS*sigma_rheo;
    
    
    % find the range of this table at this stress
    newBookmarkIndex = bookmarkIndex;
    while newBookmarkIndex <= size(stressTable,1) && stressTable(newBookmarkIndex,3) == sigma_rheo && stressTable(newBookmarkIndex,1) == phi
        newBookmarkIndex = newBookmarkIndex+1;
    end
    
    eta = CSV/1000*stressTable(bookmarkIndex:newBookmarkIndex-1,5);
    V = stressTable(bookmarkIndex:newBookmarkIndex-1,2);
    shearRate = sigma ./ eta;
    %Vnorm = V.^2 ./ shearRate;
    %Vnorm = V ./ shearRate;
    Vnorm = V;
    %Vnorm = V.^2 / sigma / shearRate(1);

    %if any(bookmarkRange==myIter)
    if any(show_vol_fracs==phi) && sigma_rheo >= show_stress_min && sigma_rheo <= show_stress_max
        %myColor = cmap(round(1+255* (log(sigma_rheo)-log(0.03))/(log(160)-log(0.03)) ),:);
        myColor = cmap(round(1+255* (log(sigma_rheo)-log(0.3))/(log(20)-log(0.3)) ),:);
        plot(Vnorm,eta,'-*','Color',myColor,'LineWidth',1.5,'MarkerSize',5); hold on;
        legendList{end+1} = strcat("\phi=",num2str(phi),", \sigma=",num2str(sigma_rheo));
    end
    
    bookmarkIndex = newBookmarkIndex;
end
legend(legendList);
xlabel('Acoustic voltage (V)')
ylabel('\eta (Pa s)')

cbh = colorbar ; %Create Colorbar
cbh.Ticks = linspace(log(5),log(700),3);
cbh.TickLabels = exp(linspace(log(5),log(700),3));
caxis([log(sigma(2)) log(sigma(end))]);