clc;clear;close all;

V = 76;
N = 13;

points = nPoints("wing_cross_section.png",N,45,100);
points = fliplr(points);
points(:,2) = -1.*points(:,2);
points = points./1000;
[ds,thetas,normals] = OrientSurfaces(points);

k = 1;
for i = 0:0.001:1
    %points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;3.85 -1.44]
    A = calcA(ds.*2,thetas,normals,points,0.75,i);
    A(:,1) = A(:,1) - A(:,end);
    A(:,end-1) = A(:,end-1) + A(:,end);
    A(:,end) = [];

    b = -1.*V.*(normals(:,:)*[1;0]);
    b(end) = [];

    mu = A\b;

    GAMMA(k) = mu(end) - mu(1);
    L(k) = abs(V)*1.225*GAMMA(k);
    k = k + 1;
end

xs = 0:0.001:1;
plot(xs,L)