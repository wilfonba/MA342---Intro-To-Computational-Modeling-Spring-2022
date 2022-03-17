clc;clear;close all;

V = 76;

xs = 0.005:0.001:0.995;
figure("position",[50 50 1050 600]);hold on;

j = 1;
for jj = 0.1:0.1:1
    k = 1;
    Length = jj;
    T = 30*pi/180;
    points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;(3 + Length*cos(T)) (-1-Length*sin(T))];
    
%     plot(points(:,1),points(:,2),'ko-');axis equal;
%     pause;
    
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
    plot(xs,L(1,:));hold on;
end


ylim([0 2e4])
legend(["0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0"],"location","southoutside","orientation","horizontal")