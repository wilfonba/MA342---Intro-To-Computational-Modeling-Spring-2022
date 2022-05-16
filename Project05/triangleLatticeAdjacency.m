function [A] = triangleLatticeAdjacency(N)
% Records the adjacency of top, bottom, left, right, top left, and bottom
% right of each node

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

b = [];
for i = 1:N
   c = zeros(N-1,2);
   for j = 1:N-1
       c(j,:) = [(i-1)*N+j,(i-1)*N + j + 1];
   end
   b = [b;c];
end
d = [1:N:N^2,N:N:N^2];
d = reshape(d,N,2);

A = [a;b;d;e;f;g];

end