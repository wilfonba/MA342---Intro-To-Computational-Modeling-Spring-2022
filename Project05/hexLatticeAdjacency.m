function [A] = hexLatticeAdjacency(N)
% Records the adjacency top, bottom, and left or right depending on the
% node's position

a = [(1:N^2-N)',(N+1:N^2)'];
e = [1:1:N,N^2-N+1:1:N^2]';
e = reshape(e,N,2);
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
for index = length(b):-2:2
    b(index,:) = [];
end
for index = length(d)-1:-2:1
    d(index,:) = [];
end
h = [b;d];

A = [a;e;h];

end