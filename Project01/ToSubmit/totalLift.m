function [F] = totalLift(input,V)

    angle = input(1);
    length = input(2);
    collectionPoint = input(3);

    xs = 0:0.001:1;
    
    T = angle*pi/180;
    points = [3 -1;2 0;0 1;-3 0.4;-3.2 0;-3 -0.4;0 -0.5;3 -1;(3 + length*cos(T)) (-1-length*sin(T))];
    [ds,thetas,normals] = OrientSurfaces(points);
    b = -1.*(normals(:,:)*V);
    b(end) = [];
    
    k = 1;
    for i = 0:0.001:1
        A = calcA(ds.*2,thetas,normals,points,i,collectionPoint);
        A(:,1) = A(:,1) + A(:,end);
        A(:,end-1) = A(:,end-1) - A(:,end);
        A(:,end) = [];

        mu = A\b;

        GAMMA(k) = -(mu(end) - mu(1));
        L(k) = norm(V)*1.225*GAMMA(k);
        k = k + 1;
    end
    sXs = [2:10:450,580:10:830,1000];
    zSpline = CubicSpline(xs(sXs),L(sXs),xs);
    [~,idx] = max(zSpline);
    fprintf("%0.3f\n",xs(idx));
    F = -L(idx);

end