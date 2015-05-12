function istrue = is2dim(obj)
[row,col] = find(obj.pixelwise_contour);  %returns indicies of nonzero elements
if (abs(max(row)-min(row))>1 && abs(max(col)-min(col)) > 1)
    istrue = 1;
else
    istrue = 0;
end