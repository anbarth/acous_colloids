function gapVsT(myStruct)

figure; hold on;
plot(getTime(myStruct),getGap(myStruct),'LineWidth',1);


ylabel(strcat( 'gap (mm)' ));
xlabel('t (s)');
title(myStruct.name);

end