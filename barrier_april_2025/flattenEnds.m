function pp = flattenEnds(pp)

xstart = pp.breaks(1);
xend = pp.breaks(end);
ystart = ppval(pp,xstart);
yend = ppval(pp,xend);
polystart = [0 0 0 ystart];
polyend = [0 0 0 yend];

xstartnew = xstart-0.01;
xendnew = xend+0.01;

pp.breaks = [xstartnew pp.breaks xendnew];
pp.coefs = [polystart; pp.coefs; polyend];
pp.pieces = size(pp.coefs,1);

end