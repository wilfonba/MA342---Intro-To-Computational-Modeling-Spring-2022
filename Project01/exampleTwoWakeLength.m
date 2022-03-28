clc;clear;close all;

V = 76;

xs = 0:0.001:1;
figure("position",[50 50 1050 600]);hold on;

j = 1;
for jj = 0.2:0.2:2
    k = 1;
    Length = jj;
    T = 30*pi/180;
    points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;(3 + Length*cos(T)) (-1-Length*sin(T))];
    
%     plot(points(:,1),points(:,2),'ko-');axis equal;
%     pause;
    
    [ds,thetas,normals] = OrientSurfaces(points);
    b = -1.*V.*(normals(:,:)*[1;0]);
    b(end) = [];

    for i = 0:0.001:1
        A = calcA(ds.*2,thetas,normals,points,i,0.5);
        A(:,1) = A(:,1) + A(:,end);
        A(:,end-1) = A(:,end-1) - A(:,end);
        A(:,end) = [];

        mu = A\b;

        GAMMA(j,k) = -(mu(end) - mu(1));
        L(j,k) = norm(V)*1.225*GAMMA(j,k);
        k = k + 1;
    end
    sXs = [2:10:450,580:10:830,1000];
    zSpline = CubicSpline_soln(xs(sXs),L(j,sXs),xs);
    plot(xs,zSpline,'linewidth',1, 'color', [rand(1), rand(1), rand(1)]);
    [~,idx] = max(zSpline);
    fprintf("%1.2f | %2.2f | %1.3f\n",jj,L(j,idx)/1000,xs(idx));
    F(j) = L(j,idx);
    %xline(xs(idx),'k--')
    %plot(xs,L(j,:),'linewidth',1);
    ylim([-1e4 2e4]);
    j = j + 1;
end


grid;
legend(["0.2","0.4","0.6","0.8","1.0","1.2","1.4","1.6","1.8","2.0"],"location","southoutside","orientation","horizontal")
xlabel("\theta")
ylabel("Lift (N/m)")