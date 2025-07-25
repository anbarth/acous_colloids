%optimize_collapse;
close all
mypos = [1360,305,406,468];
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyPlot; ylim([0.5 1e3]); xlim([1e-110 1.5]); 
f1 = gcf; f1.Position=mypos; xticks([1e-100 1])
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyPlot; ylim([1e-1 20]); xlim([1e-6 10])
f1 = gcf; f1.Position=[683,611,337,346]; 
show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyPlot; ylim([0.5 1e3]);
f1 = gcf; f1.Position=mypos;
%show_collapse_helper_joint(3,dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',1:3,'Alpha',0.05); prettyPlot; 
%f1 = gcf; f1.Position=[100,100,616,665];
%close all
%return


% get cbars
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1); prettyPlot; f1 = gcf; f1.Position=mypos;
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',2); prettyPlot; f1 = gcf; f1.Position=mypos;
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',3); prettyPlot; f1 = gcf; f1.Position=mypos;


s = ["cornstarch","silica","ceramic"];
for mm=3
    showLines = true;
    interp = false;
    show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',interp,'MaterialRange',mm,'ShowLines',showLines); prettyPlot;
    f1 = gcf; f1.Position=[1398,305,368,468];
    title(s(mm))
    
    show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',mm,'ShowLines',showLines); prettyPlot; ylim([1e-1 20]); xlim([1e-6 10])
    f1 = gcf; f1.Position=[683,611,300,346]; 
    title(s(mm))
    
    show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',interp,'MaterialRange',mm,'ShowLines',showLines); prettyPlot;
    f1 = gcf; f1.Position=[1051,51,469,468];
    title(s(mm))
    %show_collapse_helper_joint(2,dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',mm,'Alpha',1); prettyPlot; 
    %f1 = gcf; f1.Position=[100,-9,493,650];
    %title(s(mm))
end
