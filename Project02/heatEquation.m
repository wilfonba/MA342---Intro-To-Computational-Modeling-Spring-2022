%% Initialize Things
clc;clear;close all;

d = 0.10;

Ny = 41;
Nx = 2*Ny-1;

h = (d/2)/(Ny-1);

xs = 0:h:d;
ys = 0:h:d/2;

theta = linspace(0,pi/2,1000);

%% Generate and Plot Mesh
clc;
figure("position",[50 50 1250 700]);hold on;axis equal;axis([-0.01 0.11 -0.01 0.06])
for i = 1:Nx
   plot([xs(i),xs(i)],[0 d/2],'k-'); 
end
for i = 1:Ny
   plot([0 d],[ys(i),ys(i)],'k-'); 
end

plot([0 d/2],[d/2 d/2],'k-','linewidth',2);
plot([0 0],[0 d/2],'k--','linewidth',1);
plot([0 d],[0 0],'k--','linewidth',1);
plot([d/2 + d/2.*cos(theta)],[d/2.*sin(theta)],'k-','linewidth',2)
plot([d/2 d],[d/2 d/2],'k--','linewidth',1)
plot([d d],[0 d/2],'k--','linewidth',1);

%% Find and Plot Circle Approximation
clc;

xpoints = zeros(Ny);

% Search in y-direction
for i = floor(Nx/2)+1:Nx
    dMin = 987654321;
    cY = sqrt((d/2)^2-(xs(i)-d/2)^2);
    for j = 1:Ny
        cX = sqrt((d/2)^2-ys(j)^2)+d/2;
        %plot(xs(i),ys(j),'ko');
        D = sqrt((cY - ys(j))^2 + (cX - xs(i))^2);
        %pause;
        if D < dMin
            dMin = D;
            idx = j;
        end
    end
    xpoints(i-floor(Nx/2)) = idx;
end

% Account for repeats
jj = 1;
for i = 1:Ny-1
    xpts(jj) = xpoints(i);
    if (xpoints(i) - xpoints(i+1) > 1)
        k = 1;
        while(xpoints(i+1) < xpts(jj) - 1)
            jj = jj + 1;
            xpts(jj) = xpoints(i)-k;
            k = k + 1;
        end
    end
    jj = jj + 1;
end
xpts = [xpts (xpts(end)-1:-1:1)];

plot(xs(floor(Nx/2)+fliplr(xpts)),ys(xpts),'k.','markersize',20);