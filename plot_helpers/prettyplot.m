box on;
ax = gca;
ax.FontName = 'Cambria Math';
ax.FontSize = 12;
ax.LabelFontSizeMultiplier = 1.2;
%set(gcf, 'Position',  [50, 50, 250, 350])
fig=gcf;
set(fig,'Color',[1 1 1]);

% function prettyplot(name,xlab,ylab)
% %Makes plots look less shitty
%     ax=gca;
%     fig=gcf;
%     title(name,'Interpreter','Latex');
%     xlabel(xlab,'Interpreter','Latex');
%     ylabel(ylab,'Interpreter','Latex');
%     set(ax,'FontSize',10);
%     set(ax,'TitleFontSizeMultiplier',2);
%     set(ax,'LabelFontSizeMultiplier',1.5);
%     set(ax,'TickLabelInterpreter','Latex');
%     set(fig,'Color',[1 1 1]);
%     colororder(ax,{'#bf2206','#d96004','#cf9415','#338f11','#18ab90','#1667a1','#2e0d82','#901eb3','#e046cc','#000000','#999999','#66422f'});
%     %colororder(ax,{'#000000','#a30f0f','#261eb3','#b59826','#7D7D7D'});
%     set(fig,'DefaultLineLineWidth',1);
%     lines = findobj(ax, 'Type', 'line');% Via Matlab answers user "Image Analyst"
%     L=size(lines,1);
%     for i=1:L
%         lines(i).LineWidth=2;
%     end
%     
% end