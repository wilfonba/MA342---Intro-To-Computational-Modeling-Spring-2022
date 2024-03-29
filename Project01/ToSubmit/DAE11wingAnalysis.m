clc;clear;close all;

T = 5*pi/180;
V = [6.7*cos(T);6.7*sin(T)];
N = 10;

points = nPoints("ma342_dae11_c1m.PNG",N,35.9,348,0);
points = fliplr(points);
points(:,2) = -1.*points(:,2);
points = 2.5.*points./1045; 
[ds,thetas,normals] = OrientSurfaces(points);

b = -1.*(normals(:,:)*V);
b(end) = [];

k = 1;
for i = 0:0.001:1
    A = calcA(ds.*2,thetas,normals,points,i,0.5313);
    A(:,1) = A(:,1) + A(:,end);
    A(:,end-1) = A(:,end-1) - A(:,end);
    A(:,end) = [];

    mu = A\b;

    GAMMA(k) = -(mu(end) - mu(1));
    L(k) = norm(V)*1.225*GAMMA(k);
    k = k + 1;
end

xs = 0:0.001:1;
sXs = [2,10:10:350,450:10:490,510:10:750,1000];
zSpline = CubicSpline(xs(sXs),L(sXs),xs);
plot(xs,zSpline,'linewidth',1);hold on;
[~,idx] = max(zSpline);

%figure("position",[50 50 1050 600]);hold on;
%plot(xs,L,'linewidth',1)
%ylim([0 350])