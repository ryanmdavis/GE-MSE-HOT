%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% takes a matrix and returns the row and column corresponding to largest
% value in matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [row,col] = maxRowColIndex(m)
m=abs(m);
[y_max_of_each_col,i_max_of_each_col] = max(m);
[y_max_of_entire_m,i_max_of_entire_m] = max(y_max_of_each_col);

col = i_max_of_entire_m;
row = i_max_of_each_col(col);