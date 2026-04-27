function data = read_shimadzu_csv(fname)

myCells = readcell(fname);
% remove header
myDataCells = myCells(4:end,:);
data = cell2mat(myDataCells);

end