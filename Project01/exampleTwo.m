clc;clear;close all;

V = 76;
N = 20;

%points = nPoints("ma342_dae11_c1m.PNG",N,11.25,250,1);
%points = fliplr(points);
%points(:,2) = -1.*points(:,2);
%points = points./1000; 
points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;3.85 -1.44];
%points = [3 -1/2;0 1;-1 0];
%points = [3 -1/2;0 1;-1 0;3 -1/2;4.5 -1];
[ds,thetas,normals] = OrientSurfaces(points);
%normals(end,:) = -1.*normals(end,:);

j = 1;
for jj = 10:10:50
    k = 1;
    Length = sqrt(0.9161);
    T = jj*pi/180;
    points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;(3 + Length*cos(T)) (-1-Length*sin(T))];
    [ds,thetas,normals] = OrientSurfaces(points);
    b = -1.*V.*(normals(:,:)*[1;0]);
    b(end) = [];
    for i = 0.005:0.001:0.995
        A = calcA(ds.*2,thetas,normals,points,i,0.5);
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
for i = 1:5
    plot(xs,L(i,:),'linewidth',1)
end
ylim([0 2e4])
legend(["10","20","30","40","50"],"location","southoutside","orientation","horizontal")