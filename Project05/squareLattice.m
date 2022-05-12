clc;clear;close;

N = 30;

A = squareLatticeAdjacency(N);

nEquilib = 200;
nSim = 300;
J = -1;
H = 0;
Tmin = 1;
Tmax = 4;

nTotal = nEquilib + nSim;
E = zeros(nTotal,1);
dT = (Tmax - Tmin)/nTotal;
dT = 0;
T = Tmin;

sigma = zeros(N^2,nTotal);
for i = 1:N^2
   a = randn(1,1);
   if a < 0
       sigma(i,1) = -1;
   else
       sigma(i,1) = 1;
   end
end




for i = 2:nTotal
    for j = 1:size(A,1)
       E(i) = E(i) - J*sigma(A(j,1),i-1)*sigma(A(j,2),i-1);
    end
    for j = 1:N^2
        E(i) = E(i) - H*sigma(j);
    end
    E(i) = E(i)/N^2;
    
    for j = 1:size(sigma,1)
        sigmaSum = 0;
        for k = 1:size(A,1)
            if (A(k,1) == j)
                sigmaSum = sigmaSum + sigma(A(k,2),i-1);
            elseif (A(k,2) == j)
                sigmaSum = sigmaSum + sigma(A(k,1),i-1);
            end
        end
        
        Ediff = -2*sigma(j,i-1)*sigmaSum;
        if Ediff > 1
            Pswap = 1;
        else
            Pswap = exp(Ediff/T);
        end
        
        if (Pswap > randn(1))
            sigma(j,i) = -1*sigma(j,i-1);
        else
            sigma(j,i) = sigma(j,i-1);
        end
    end
    T = T + dT;
    surf(reshape(sigma(:,i),30,30));
    view(0,90);
    drawnow;
end
