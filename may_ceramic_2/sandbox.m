figure; hold on;
ax1=gca;
ax1.YScale='log';

theta = pi/4;
R = [cos(theta), -sin(theta); sin(theta), cos(theta)];

x1=1;
x2=3;
y1=1;
y2=3;
x = [x1, x2, x2, x1, x1];
y = [y1, y1, y2, y2, y1];
xy = [x;y];
xy = R*xy;
plot(xy(1,:), xy(2,:), 'b-', 'LineWidth', 3);
xlim([-5 5])
ylim([1 8])