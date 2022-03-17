clc;clear;close all;

V = 76;

points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;3.85 -1.44];
[ds,thetas,normals] = OrientSurfaces(points);
b = -1.*V.*(normals(:,:)*[1;0]);
b(end) = [];

j = 1;
for jj = 0.15:0.15:0.9
    k = 1;
    for i = 0.005:0.001:0.995
        A = calcA(ds.*2,thetas,normals,points,i,jj);
        A(:,1) = A(:,1) + A(:,end);
        A(:,end-1) = A(:,end-1) - A(:,end);
        A(:,end) = [];

        mu = A\b;

        GAMMA(j,k) = -(mu(end) - mu(1));
        L(j,k) = norm(V)*1.225*GAMMA(k);
        k = k + 1;
    end
    j = j + 1;
end

xs = 0.005:0.001:0.995;
figure("position",[50 50 1050 600]);hold on;
for i = 1:6
    plot(xs,L(i,:),'linewidth',1)
end
ylim([0 2e4])
legend(["0.15","0.30","0.45","0.60","0.75","0.90"],"location","southoutside","orientation","horizontal")