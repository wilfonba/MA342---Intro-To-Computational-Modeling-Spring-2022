function E = calcenergyofstate(sigma, J)

if nargin < 2
    J = 1;
end

% This assumes a torus as its topology and only calculates the impact
% of the nearest four neighbors, like in the book

n = size(sigma, 1);
E = 0;
% Only computes top and left neighbors to avoid double-counting
for j = 1:n^2
 E = E - sigma(j)* ...
                (sigma(mod(j-2, n) + n*floor((j-1)/n) + 1) + ...
                sigma(mod(j - n - 1, n^2) + 1));
end

end