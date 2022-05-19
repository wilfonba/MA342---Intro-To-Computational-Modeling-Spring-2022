sims = 1000;
ignore = 750;
temps = 1:0.05:4;
n = 50;
p = .60;

meanenergy = zeros(1, length(temps));
meanmag = zeros(1, length(temps));
Cs = zeros(1, length(temps));
chis = zeros(1, length(temps));
tic
for i=1:length(temps)
    temp = temps(i)
    sigmas = simspins(n, temp, p, sims);
    energy = zeros(1, size(sigmas, 3));
    mag = zeros(1, size(sigmas, 3));
    for j = ignore:size(sigmas, 3)
        energy(j) = calcenergyofstate(sigmas(:, :, j));
        mag(j) = calcmagnetizationofstate(sigmas(:, :, j));
    end
    meanenergy(i) = sum(energy)/(n^2 * (sims-ignore));
    meanmag(i) = sum(mag)/(n^2 * (sims-ignore));

    Cs(i) = (sum(energy.^2) - sum(energy)^2/(sims-ignore))/((temp^2)*n^2 * (sims-ignore));
    chis(i) = (sum(mag.^2) - sum(mag)^2/(sims-ignore))/(temp*n^2 * (sims-ignore));
end
toc

plot(temps, meanenergy, '-o', color='g', MarkerSize=3, MarkerEdgeColor='b', MarkerFaceColor='b')
ylabel("Lattice Energy E_T/N")
xlabel("Temperature (T)")
figure()
plot(temps, meanmag, '-o', color='g', MarkerSize=3, MarkerEdgeColor='b', MarkerFaceColor='b')
ylabel("Magnetization M_T/N")
xlabel("Temperature (T)")
figure()

plot(temps, Cs, '-o', color='g', MarkerSize=3, MarkerEdgeColor='b', MarkerFaceColor='b')
ylabel("Heat Capacity C_T/N")
xlabel("Temperature (T)")
figure()
plot(temps, chis, '-o', color='g', MarkerSize=3, MarkerEdgeColor='b', MarkerFaceColor='b')
ylabel("Susceptibility \chi_T/N")
xlabel("Temperature (T)")


