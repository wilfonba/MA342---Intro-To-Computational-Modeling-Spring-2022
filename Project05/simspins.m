function out = simspins(n, T, candprop, iters)
% n - size of the lattice - an nxn matrix
% T - temperature
% candprop - proportion of the places to consider, between 0 and 1
% iters - iterations of the spin lattice to calculate

out = zeros(n, n, iters+1);

out(1:n, 1:n, 1) = 2*randi([0 1], n)-1;

for k=1:iters
    cands = randperm(n^2);
    sigma = out(1:n, 1:n, k);
    sigmanew = sigma;
    % This assumes a torus as its topology and only calculates the impact
    % of the nearest four neighbors, like in the book
    for j = cands(1:floor(candprop*n^2))
        ediff = -2*sigma(j)* ...
                (sigma(mod(j-2, n) + n*floor((j-1)/n) + 1) + ...
                sigma(mod(j, n) + n*floor((j-1)/n) + 1) + ...
                sigma(mod(j - n - 1, n^2) + 1) + ...
                sigma(mod(j + n - 1, n^2) + 1) ...
                );
        P = exp(ediff/T);
        sigmanew(j) = sigma(j)*(2*(P < rand(1)) - 1);
    end
    out(:, :, k+1) = sigmanew;
end
end
