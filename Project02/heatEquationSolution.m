%% Initializing
clc;clear;close all;

rho = 7.8;
c   = 0.11;
k   = 0.013;

[xs,ys,NTA] = heatEquationMesh(100,0);

Nx = length(xs);
Ny = length(ys);

% T(x,y,0);
T = 0.*ones(Ny,Nx);
T(:,:,2) = zeros(Ny,Nx);

h = xs(2)-xs(1);
dt = 0.45*(c*rho*h^4)/(k*2*h^2);

%% Timesteping
n = 1;
m = 2;
const = k*dt/(c*rho*h^2);

[X,Y] = meshgrid(xs,ys);

N = 2/dt;
for i = 1:N
    for j = 1:Ny
        for k = 1:Nx
            if NTA(j,k) == 3
                T(j,k,m) = T(j,k,n) + const*(T(j+1,k,n) - 2*T(j,k,n) + T(j-1,k,n)) + ...
                    const*(T(j,k+1,n) - 2*T(j,k,n) + T(j,k-1,n));
            elseif NTA(j,k) == 4
                T(j,k,m) = T(j,k,n) + const*(T(j+1,k,n) - 2*T(j,k,n) + T(j-1,k,n)) + ...
                    const*(2*T(j,k+1,n) - 2*T(j,k,n));
            elseif NTA(j,k) == 5
                T(j,k,m) = T(j,k,n) + const*(2*T(j-1,k,n) - 2*T(j,k,n)) + ...
                    const*(T(j,k+1,n) - 2*T(j,k,n) + T(j,k-1,n));
            elseif NTA(j,k) == 1
                R = [xs(k)-0.05,ys(end-j+1)];
                R = R./norm(R,2);
                T(j,k,m) = 0;
            elseif NTA(j,k) == 2
                T(j,k,m) = 60;
            elseif NTA(j,k) == 0
                T(j,k,m) = NaN;
            elseif NTA(j,k) == 7
                T(j,k,m) = 0;
            elseif NTA(j,k) == 8
                T(j,k,m) = 0;
            else
                T(j,k,m) = T(j,k,n) + const*(2*T(j-1,k,n) - 2*T(j,k,n)) + ...
                    const*(2*T(j,k+1,n) - 2*T(j,k,n));
            end
        end
    end
    [m,n] = deal(n,m);
    [X,Y] = meshgrid(xs,ys);
    surf(X,Y,T(:,:,m),'edgecolor','none');zlim([-2 60]);drawnow;
end