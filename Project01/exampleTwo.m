clc;clear;

V = 76;

points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;3.85 -1.44];
[ds,thetas,normals] = OrientSurfaces(points);
A = calcA(ds.*2,thetas,normals,points,0.5);
A(:,1) = A(:,1) - A(:,end);
A(:,end-1) = A(:,end-1) + A(:,end);
A(:,end) = [];

b = -1.*V.*(normals(:,:)*[1;0]);
b(end) = [];

mu = A\b;

GAMMA = mu(end) - mu(1)