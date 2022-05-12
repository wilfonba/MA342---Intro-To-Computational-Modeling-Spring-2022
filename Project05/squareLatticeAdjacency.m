function A = squareLatticeAdjacency(N)
    a = [(1:N^2-N)',(N+1:N^2)'];
    b = [];
    for i = 1:N
       c = zeros(N-1,2);
       for j = 1:N-1
           c(j,:) = [(i-1)*N+(j-1)+1,(i-1)*N + j + 1];
       end
       b = [b;c];
    end
    d = [1:N:N^2,N:N:N^2];
    d = reshape(d,N,2);
    e = [1:1:N,N^2-N+1:1:N^2]';
    e = reshape(e,N,2);
    A = [a;b;d;e];
end