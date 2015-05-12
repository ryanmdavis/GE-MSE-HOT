function out_string = strcatspace(varargin)
if nargin < 2
    error('requires at least two input strings');
end

out_string_cell={''};
for input_num=1:nargin
    out_string_cell=strcat(out_string_cell,varargin(input_num));
end

out_string=out_string_cell{1};