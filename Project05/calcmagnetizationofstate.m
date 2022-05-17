function M = calcmagnetizationofstate(sigma, nu)

if nargin < 2
    nu = 1;
end

M = abs(nu * sum(sigma, 'all'));