%optimize_collapse;

%prettyplot font size 20
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyplot; ylim([0.5 1e3]); xlim([1e-110 1.5]); 
f1 = gcf; f1.Position=[100,50,616,665]; xticks([1e-100 1])
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyplot; ylim([1e-1 1e3]); xlim([1e-6 10])
f1 = gcf; f1.Position=[100,100,616,665]; 
show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyplot; ylim([0.5 1e3]);
f1 = gcf; f1.Position=[100,100,616,665];
close all
%return

s = ["cornstarch","silica","ceramic"];

for mm=3
    showLines = true;
    interp = false;
    show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',interp,'MaterialRange',mm,'ShowLines',showLines); prettyplot;
    f1 = gcf; f1.Position=[100,-9,493,650];
    title(s(mm))
    show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',interp,'MaterialRange',mm,'ShowLines',showLines); prettyplot;
    f1 = gcf; f1.Position=[100,-9,493,650];
    title(s(mm))
end