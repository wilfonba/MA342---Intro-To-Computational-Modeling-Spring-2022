n = 30;
T = 3.5;
p = .6;
sims = 500;

sigmas = simspins(n, T, p, sims);
energy = zeros(1, size(sigmas, 3));

for i = 1:size(sigmas, 3)
    energy(i) = calcenergyofstate(sigmas(:, :, i)) / n^2;
end

scatter(0:sims, energy, 10);
xlabel("Iteration")
ylabel("Lattice Energy E/N")