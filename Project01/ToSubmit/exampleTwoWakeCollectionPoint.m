clc;clear;close all;

V = 76;

points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;3.8289 -1.478566];
[ds,thetas,normals] = OrientSurfaces(points);
b = -1.*V.*(normals(:,:)*[1;0]);
b(end) = [];

figure("position",[50 50 1050 600]);hold on;
xs = 0:0.001:1;

j = 1;
for jj = 0.5:0.1:0.9
    k = 1;
    for i = 0:0.001:1
        A = calcA(ds.*2,thetas,normals,points,i,jj);
        A(:,1) = A(:,1) + A(:,end);
        A(:,end-1) = A(:,end-1) - A(:,end);
        A(:,end) = [];

        mu = A\b;

        GAMMA(j,k) = -(mu(end) - mu(1));
        L(j,k) = norm(V)*1.225*GAMMA(j,k);
        k = k + 1;
    end
    
    if j == 1
        sXs = [2:10:450,580:10:830,1000];
    else
        sXs = [2:10:450,580:10:1000];
    end
    zSpline = CubicSpline(xs(sXs),L(j,sXs),xs);
    plot(xs,zSpline,'linewidth',1);
    [~,idx] = max(zSpline);
    fprintf("%1.2f | %2.2f | %1.3f\n",jj,L(j,idx)/1000,xs(idx));
    F(j) = L(j,idx);
    CP(j) = xs(idx);
    %plot(xs,L(j,:),'linewidth',1);
    ylim([-1e4 2e4]);
    j = j + 1;
end

grid;
legend(["0.5","0.6","0.7","0.8","0.9"],"location","southoutside","orientation","horizontal")