figure; hold on;

cmap = viridis(256); 
phiMin = 0.4;
phiMax = 0.6;
myColor = @(phi) cmap(round(1+255*(phi-phiMin)/(phiMax-phiMin)),:);

getStressSweep(phi44.sweep1,true,myColor(0.44));
getStressSweep(phi44.low1,true,myColor(0.44));

getStressSweep(phi48.lowsweep1,true,myColor(0.48));
getStressSweep(phi48.sweep1,true,myColor(0.48));

getStressSweep(phi52.sweep1,true,myColor(0.52));
getStressSweep(phi52.lowsweep1,true,myColor(0.52));

getStressSweep(phi56.lowsweep1,true,myColor(0.56));
getStressSweep(phi56.sweep1,true,myColor(0.56));

getStressSweep(phi59.sweep1,true,myColor(0.59));
getStressSweep(phi59.lowsweep1,true,myColor(0.59));