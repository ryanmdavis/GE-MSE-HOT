%this function makes a 2D fermi function for filtering k-space data
% inputs:
%   center: the center of kspace that this Fermi Function will filter.
%   kT: a 1x2 giving the kT of row and column
%   Ef: the fermi energy, in this case it is the row/col where the function
%       begins to "activate". 1x2 vector.

function f_surf_norm = makeFermiSurface(mat_size,Ef,kT,center)

rows = zeros(mat_size);
cols = zeros(mat_size);

for row = 1:mat_size(1)
    rows(row,:) = row;
end
for col = 1:mat_size(2)
    cols(:,col) = col;
end

rows = abs(rows - center(1)) - Ef(1);
cols = abs(cols - center(2)) - Ef(2);

fermi_row = 1./(exp(rows/kT(1)) + 1);
fermi_col = 1./(exp(cols/kT(2)) + 1);

f_surf_norm = fermi_row.*fermi_col;

