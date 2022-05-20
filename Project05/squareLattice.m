clc;clear;close;

N = 60;

A = squareLatticeAdjacency(N);

nEquilib = 800;
nSim = 200;
nTotal = nEquilib + nSim*100;
J = 1;
H = 0;
Tmin = 1;
Tmax = 4;
Temps = linspace(Tmin,Tmax,nSim);

E = zeros(nTotal,1);

sigma = zeros(N^2,nTotal);

for i = 1:N^2
   a = randn(1,1);
   if a < 0
       sigma(i,1) = -1;
   else
       sigma(i,1) = 1;
   end
end

fig = figure("position",[50 50 600 600]);
%fig.Visible = false;

%%
T = 1;
w = waitbar(0,"Running");
for i = 2:nEquilib
    w = waitbar(i/nTotal,w,"Running");
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
%     axis equal
%     
%     surf(reshape(sigma(:,i),N,N),'edgecolor','none');
%     title("Equilibrating");
%     view(0,90);
%     drawnow;
%     axis off
end
plot(E)
%%

M = zeros(nSim,1);
C = zeros(nSim,1);
Chi = zeros(nSim,1);
E = zeros(nSim,1);
Esamp = zeros(100,1);

for i = nEquilib+1:nTotal
    T = Temps(idx);
    w = waitbar(i/nTotal,w,"Running");
    for idx = 1:100
        for j = 1:size(A,1)
           Esamp(idx) = Esamp(idx) - J*sigma(A(j,1),i-1)*sigma(A(j,2),i-1);
        end
        for j = 1:N^2
            Esamp(idx) = Esamp(idx) - H*sigma(j,i-1);
        end
        Esamp(idx) = Esamp(idx)/N^2;

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
        M(idx) = sum(sigma(:,i))/N^2;
    end
end


%%
figure();
subplot(1,2,1)
plot(Temps,E(nEquilib+1:end));

subplot(1,2,2)
plot(Temps,abs(M));