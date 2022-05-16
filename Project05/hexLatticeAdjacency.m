function A = hexLatticeAdjacency(N)

a = [(1:N^2-N)',(N+1:N^2)'];
f = [1:1:N,N^2-N+1:1:N^2]';
f = reshape(f,N,2);
f(1,:) = [1, N^2];
f(2:N,2) = f(2:N,2) - 1;
e = [1:1:N,N^2-N+1:1:N^2]';
e = reshape(e,N,2);
g = [(1:N^2-N)',(N+1:N^2)'];
g(:,2) = g(:,2) + 1;
g(end,:) = [N^2-N, N^2-N+1];
g(N:N:N^2-N-1,:) = [(N:N:N^2-N-1)', (N+1:N:N^2-N)'];

A = [a;f;g;e];

end