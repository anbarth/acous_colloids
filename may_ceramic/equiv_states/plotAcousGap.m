function plotAcousGap(myStruct,tStart)

hold on;
plot(getTime(myStruct)-tStart,getGap(myStruct),'LineWidth',1);


ylabel(strcat( 'gap (mm)' ));
xlabel('t (s)');


end