function pp = replaceSectionWithLine(pp,xstart,xend)

ystart = ppval(pp,xstart);
yend = ppval(pp,xend);
p1=0;
p2=0;
p3=(yend-ystart)/(xend-xstart);
p4=p3*xstart+ystart;

% remove polynomials in regions to be covered by line
for ii=size(pp.coefs,1):-1:1
    if pp.breaks(ii) < xend && pp.breaks(ii) > xstart && pp.breaks(ii+1) < xend && pp.breaks(ii+1) > xstart
        pp.coefs(ii,:) = [];
    end
end

% remove breaks in region to be covered by line
for ii=length(pp.breaks):-1:1
    if pp.breaks(ii) < xend && pp.breaks(ii) > xstart
        pp.breaks(ii) = [];
    end
end

for ii=1:size(pp.coefs,1)
    if pp.breaks(ii) < xstart && pp.breaks(ii+1) > xend
        pp.breaks = [pp.breaks(1:ii) xstart xend pp.breaks(ii+1:end)];
        pp.coefs = [pp.coefs(1:ii,:); p1 p2 p3 p4; pp.coefs(ii+1:end,:)];
    end
end


pp.pieces = size(pp.coefs,1);

end