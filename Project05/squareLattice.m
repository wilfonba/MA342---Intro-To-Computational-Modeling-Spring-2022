clc;clear;close;

N = 50;

A = squareLatticeAdjacency(N);

nEquilib = 200;
nSim = 2000;
J = 1;
H = 0;
Tmin = 2;
Tmax = 10;

nTotal = nEquilib + nSim;
E = zeros(nTotal,1);
dT = (Tmax - Tmin)/nTotal;
%dT = 0;
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

[X,Y] = meshgrid(1:N,1:N);

figure;
for i = 2:nTotal
    for j = 1:size(A,1)
       E(i) = E(i) - J*sigma(A(j,1),i-1)*sigma(A(j,2),i-1);
    end
    for j = 1:N^2
        E(i) = E(i) - H*sigma(j,i-1);
    end
    E(i) = E(i)/N^2;
    
    samples = randsample(N^2,0.6*N^2);
    for j = 1:size(sigma,1)
        if ismember(j,samples)
            sigmaSum = 0;
            for k = 1:size(A,1)
                if (A(k,1) == j)
                    sigmaSum = sigmaSum + sigma(A(k,2),i-1);
                elseif (A(k,2) == j)
                    sigmaSum = sigmaSum + sigma(A(k,1),i-1);
                end
            end
            Ediff = -2*sigma(j,i-1)*sigmaSum;
            if Ediff > 0
                Pswap = 1;
            else
                Pswap = exp(Ediff/T);
            end

            if (Pswap > rand())
                sigma(j,i) = -1*sigma(j,i-1);
            else
                sigma(j,i) = sigma(j,i-1);
            end
            
        else
           sigma(j,i) = sigma(j,i-1); 
        end
    end
    T = T + dT;
    axis equal
    
%     sigmaR = reshape(sigma(:,i),N,N);
%     for j = 1:N^2
%             if sigmaR(j) == 1
%                 plot(X(j),Y(j),'r.');
%             else
%                 plot(X(j),Y(j),'b.');
%             end
%     end
%     drawnow;
    surf(reshape(sigma(:,i),N,N),'edgecolor','none');
    view(0,90);
    drawnow;
end

plot(E,'k.')