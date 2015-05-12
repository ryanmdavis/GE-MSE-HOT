function isclosed = isContourClosed(obj)
    num_points = size(obj.row_points,1);
    if (((obj.row_points(1)-obj.row_points(num_points))^2+(obj.col_points(1) - obj.col_points(num_points))^2)^.5) <= 2^.5
        isclosed = boolean(1);
    else
        isclosed = boolean(0);
    end
end
        