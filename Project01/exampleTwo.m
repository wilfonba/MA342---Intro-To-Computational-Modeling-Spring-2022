clc;clear;

points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;3.85 -1.44];
[ds,thetas,normals] = OrientSurfaces(points);
100.*calcA(ds.*2,thetas,normals,points,0.5)