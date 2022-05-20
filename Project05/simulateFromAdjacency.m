clc;clear;close all;

N = 50;

A = triangleLatticeAdjacency(N);

nEquilib = 1000;
nSim = 800;
Temps = 1:0.05:6;
nTemps = length(Temps);
nTotal = nEquilib + nSim*nTemps;

J = 1;
H = 0;
p = 0.6;

sigma = zeros(N^2,nTotal);
for i = 1:N^2
   a = randn(1,1);
   if a < 0
       sigma(i,1) = -1;
   else
       sigma(i,1) = 1;
   end
end

T = 3.5;
eEquilib = zeros(nEquilib,1);
w = waitbar(0,"Equilibrating");
for i = 1:nEquilib
    waitbar(i/nEquilib,w,"Equilibrating");
    sigma(:,i+1) = updateSigma(sigma(:,i),A,T,p);
    eEquilib(i) = calculateEnergy(sigma(:,i),A,J,H);
    
%     cla;
%     surf(reshape(sigma(:,i),30,30));
%     view(0,90);
%     drawnow;
end
close(w);

%%

k = nEquilib;
eTemp = zeros(nTemps,1);
mTemp = zeros(nTemps,1);
cTemp = zeros(nTemps,1);
chiTemp = zeros(nTemps,1);
w = waitbar(0,"Temp Stepping");
for i = 1:nTemps
    T = Temps(i);
    eSim = zeros(nSim-10,1);
    mSim = zeros(nSim-10,1);
    for j = 1:nSim
        waitbarText = strcat("Temp Stepping ",num2str(i),"/",num2str(nTemps));
        waitbar(j/nSim,w,waitbarText);
        sigma(:,k+1) = updateSigma(sigma(:,k),A,T,p);
        if j > 50
            eSim(j,1) = calculateEnergy(sigma(:,k),A,J,H);
            mSim(j,1) = sum(sigma(:,k));
        end
        k = k + 1;
    end
    eTemp(i,1) = mean(eSim)/N^2;
    mTemp(i,1) = mean(mSim)/N^2;
    Ns = nSim - 10;
    cTemp(i,1) = (mean((eSim./N^2).^2) - mean(eSim./N^2)^2)/(T^2);
    chiTemp(i,1) = (mean((mSim./N^2).^2) - mean(mSim./N^2)^2)/(T);
end
close(w);

%%
subplot(2,2,1);
plot(Temps,eTemp,'g-');hold on;
plot(Temps,eTemp,'b.');
title("\langle E_T\rangle/T")


subplot(2,2,2);
plot(Temps,cTemp,'g-');hold on;
plot(Temps,cTemp,'b.');
title("C_T/N")

subplot(2,2,3);
plot(Temps,abs(mTemp),'g-');hold on;
plot(Temps,abs(mTemp),'b.');
title("\langle |M_T|\rangle/N");

subplot(2,2,4);
plot(Temps,chiTemp,'g-');hold on;
plot(Temps,chiTemp,'b.');
title("\chi_T/N");