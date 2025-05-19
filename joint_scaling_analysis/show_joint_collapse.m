optimize_collapse;

show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',1:3); prettyplot;
show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',1:3); prettyplot;


s = ["cornstarch","silica","ceramic"];

for mm=1:3
    showLines = true;
    show_F_vs_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',mm,'ShowLines',showLines); prettyplot;
    title(s(mm))
    show_F_vs_xc_x_joint(dataTable,y,myModelHandle,'ShowInterpolatingFunction',true,'MaterialRange',mm,'ShowLines',showLines); prettyplot;
    title(s(mm))
end