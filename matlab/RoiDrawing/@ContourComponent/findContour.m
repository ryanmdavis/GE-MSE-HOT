function [row_points,col_points,component_start_position] = findContour(obj,contour,varargin)
invar = struct('outline_type','inline');
argin = varargin;
invar = generateArgin(invar,argin);

four_connectivity = [0 1 0;1 0 1;0 1 0];
four_connectivity_diag = [1 0 1;0 0 0;1 0 1];

num_points = sum(sum(obj.image_contour));
current_voxel = [0,0];
[current_voxel(1),current_voxel(2)] = find(obj.image_contour,1);
previous_line_start=[current_voxel(1) current_voxel(2)];
[row_lim,col_lim] = size(obj.image_contour);
component_start_position=0;
obj.image_contour(current_voxel)=0;


if strcmp(invar.outline_type,'inline');
    row_points = zeros(num_points,1);
    col_points = zeros(num_points,1);
    row_points(1)=current_voxel(1);
    col_points(1)=current_voxel(2);
    point_num=2;
    while point_num<num_points
        neighbors = obj.image_contour(max([current_voxel(1) - 1,1]):min([current_voxel(1) + 1, row_lim]),max([current_voxel(2) - 1,1]):min([current_voxel(2) + 1,col_lim]));
        if sum(sum(neighbors))==0
            row_points(point_num)=previous_line_start(1);
            col_points(point_num)=previous_line_start(2);
            [current_voxel(1),current_voxel(2)] = find(obj.image_contour,1);
            previous_line_start=[current_voxel(1) current_voxel(2)];
            neighbors = obj.image_contour(max([current_voxel(1) - 1,1]):min([current_voxel(1) + 1, row_lim]),max([current_voxel(2) - 1,1]):min([current_voxel(2) + 1,col_lim]));
            component_start_position(end+1)=point_num;
            num_points=num_points+2;
        else
            if (size(neighbors,1)*size(neighbors,2)) == 9 && sum(sum(neighbors.*four_connectivity)) == sum(sum(neighbors.*four_connectivity_diag))
                neighbors = neighbors .* four_connectivity;
            end  %this makes sure that the algorithm doesn't trap itself 
            [max_row_neighbor,max_col_neighbor]=maxRowColIndex(neighbors);
            max_row_ind=max_row_neighbor+current_voxel(1)-2;
            max_col_ind=max_col_neighbor+current_voxel(2)-2;
            row_points(point_num) = max_row_ind;
            col_points(point_num) = max_col_ind;
            current_voxel = [max_row_ind max_col_ind];
            obj.image_contour(max_row_ind,max_col_ind) = 0;
        end
        point_num=point_num+1;
    end
    row_points(point_num)=previous_line_start(1);
    col_points(point_num)=previous_line_start(2);
    component_start_position(end+1)=point_num;
elseif strcmp(invar.outline_type,'outline')
    row_points = zeros(num_points*4,1);
    col_points = zeros(num_points*4,1); %maximum number of points needed to describe an outline (think one point contour), truncate later
    four_connectivity = [0 1 0;1 0 1;0 1 0];
    mask_negative = ~obj.mask;
    point_num = 1;
    while sum(sum(contour)) > 1
        neighbors = mask_negative(max([current_voxel(1) - 1,1]):min([current_voxel(1) + 1, row_lim]),max([current_voxel(2) - 1,1]):min([current_voxel(2) + 1,col_lim]));
        outline_points = four_connectivity .* neighbors;
        if outline_points(1,2) == 1
            row_points(point_num) = current_voxel(1) - 0.5;
            col_points(point_num) = current_voxel(2);
            point_num = point_num + 1;
        end
        if outline_points(3,2) == 1
            row_points(point_num) = current_voxel(1) + 0.5;
            col_points(point_num) = current_voxel(2);
            point_num = point_num + 1;
        end
        if outline_points(2,1)
            row_points(point_num) = current_voxel(1);
            col_points(point_num) = current_voxel(2) - 0.5;
            point_num = point_num + 1;
        end
        if outline_points(2,3)
            row_points(point_num) = current_voxel(1);
            col_points(point_num) = current_voxel(2) + 0.5;
            point_num = point_num + 1;
        end
        contour(current_voxel(1),current_voxel(2)) = 0;
                [vals,index] = max(neighbors); %#ok
        [vals,max_col] = max(vals);
        max_col_ind = min(max(current_voxel(2) + max_col - 2,1),size(obj.image_contour,2));
        [vals,max_row] = max(neighbors(:,max_col));
        max_row_ind = min(max(current_voxel(1) + max_row - 2,1),size(obj.image_contour,1));
        current_voxel = [max_row_ind max_col_ind];
    end
end