%optimize_collapse;

%prettyplot font size 20
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyplot; ylim([0.5 1e3]); xlim([1e-110 1.5]); 
f1 = gcf; f1.Position=[1340,514,616,665]; xticks([1e-100 1])
show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyplot; ylim([1e-1 1e3]); xlim([1e-6 10])
f1 = gcf; f1.Position=[1340,514,616,665]; 
show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',1:3); prettyplot; ylim([0.5 1e3]);
f1 = gcf; f1.Position=[1340,514,616,665];

%return

s = ["cornstarch","silica","ceramic"];

for mm=1:3
    showLines = false;
    show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',mm,'ShowLines',showLines); prettyplot;
    title(s(mm))
    show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',false,'MaterialRange',mm,'ShowLines',showLines); prettyplot;
    title(s(mm))
end