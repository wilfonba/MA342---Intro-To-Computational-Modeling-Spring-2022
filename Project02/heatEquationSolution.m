%% Initializing
clc;clear;close all;

material = 'Diamond';
k   = 2.0e3;
rho = 3.5e3;
c   = 2.0e3;

zRange = [59.95 60.05];
frameDt = 0.005;

makeMovie = 1;

[xs,ys,NTA] = heatEquationMesh(256,0);

Nx = length(xs);
Ny = length(ys);

% T(x,y,0);
T = 60.*ones(Ny,Nx);
T(:,:,2) = zeros(Ny,Nx);

h = xs(2)-xs(1);
dt = 0.45*(c*rho*h^4)/(k*2*h^2);
if dt > 0.001
    dt = 0.001;
end

filename = strcat('HeatEquationVideosAndData/HeatEquation',material,'.mp4');
if exist(filename, 'file')
    i = 1;
    while (true)
        filename = strcat('HeatEquationVideosAndData/HeatEquation',material,'(',num2str(i),').mp4');
        if exist(filename,'file')
            i = i + 1;
        else
            filename = strcat('HeatEquationVideosAndData/HeatEquation',material,'(',num2str(i),')');
            break;
        end
    end
else
  filename = strcat('HeatEquationVideosAndData/HeatEquation',material);
end

writerObj = VideoWriter(filename,'MPEG-4');
open(writerObj);

%% Timesteping
n = 1;
m = 2;
const = k*dt/(c*rho*h^2);

[X,Y] = meshgrid(xs,ys);
Y = flipud(Y);

% prevents surface plots from plotting in loop
fig = figure("position",[50 50 1000 800]);
fig.Visible = 'off';

 N = ceil(2/dt);
% N = 10000;
stepsPerFrame = floor(frameDt/dt);
% stepsPerFrame = 100;
%N = 10;

fprintf("Dt = %1.5e, N = %1.5e \n",dt,N);

cla;
surf(X,Y,T(:,:,1),'edgecolor','none');hold on;
surf(-X,Y,T(:,:,1),'edgecolor','none');
surf(-X,-Y,T(:,:,1),'edgecolor','none');
surf(X,-Y,T(:,:,1),'edgecolor','none');
colormap(jet);
zlim([59.95 60])
pbaspect([1 0.5 0.75])
titleString = strcat("Time = ",num2str(0.000,'%1.2f')," s");
title(titleString);
drawnow;
if makeMovie
    writeVideo(writerObj,getframe(gcf)); 
end

% set up progress bar
wBar = waitbar(0,"Solution Progress");

for i = 1:N
    tic;
    T = updateT(NTA,T,Ny,Nx,const,h,n,m,length(ys),xs,ys);
%     for j = 1:Ny
%         for k = 1:Nx
%             if NTA(j,k) == 3
%                 T(j,k,m) = T(j,k,n) + const*(T(j+1,k,n) - 2*T(j,k,n) + T(j-1,k,n)) + ...
%                     const*(T(j,k+1,n) - 2*T(j,k,n) + T(j,k-1,n));
%             elseif NTA(j,k) == 4
%                 T(j,k,m) = T(j,k,n) + const*(T(j+1,k,n) - 2*T(j,k,n) + T(j-1,k,n)) + ...
%                     const*(2*T(j,k+1,n) - 2*T(j,k,n));
%             elseif NTA(j,k) == 5
%                 T(j,k,m) = T(j,k,n) + const*(2*T(j-1,k,n) - 2*T(j,k,n)) + ...
%                     const*(T(j,k+1,n) - 2*T(j,k,n) + T(j,k-1,n));
%             elseif NTA(j,k) == 1
%                 R = [xs(k)-0.05,ys(end-j+1)];
%                 R = R./norm(R,2);
%                 T(j,k,m) = ((3*R(1)+3*R(2))/(2*h))^(-1)*...
%                     (-1 + R(1)/(2*h)*(4*T(j,k-1,n) - T(j,k-2,n)) + R(2)/(2*h)*(-T(j+2,k,n)+4*T(j+1,k,n)));
%             elseif NTA(j,k) == 2
%                 T(j,k,m) = 60;
%             elseif NTA(j,k) == 0
%                 T(j,k,m) = NaN;
%             elseif NTA(j,k) == 7
%                 R = [xs(k)-0.05,ys(end-j+1)];
%                 R = R./norm(R,2);
%                 T(j,k,m) = ((3*R(1)+4*R(2))/(2*h))^(-1)*(-1 + R(1)/(2*h)*...
%                     (4*T(j,k-1,n) - T(j,k-2,n)) + 2*R(2)/(h)*T(j+1,k,n));
%             elseif NTA(j,k) == 8
%                 T(j,k,m) = -2*h/3 + (4/3)*T(j,k-1,n) - (1/3)*T(j,k-2,n);
%             else              %6
%                 T(j,k,m) = T(j,k,n) + const*(2*T(j-1,k,n) - 2*T(j,k,n)) + ...
%                     const*(2*T(j,k+1,n) - 2*T(j,k,n));
%             end
%         end
%     end

    if (mod(i,stepsPerFrame) == 0)
        fprintf("Frame: %i\n",i/stepsPerFrame);
        cla;
        surf(X,Y,T(:,:,m),'edgecolor','none');hold on;
        surf(-X,Y,T(:,:,m),'edgecolor','none');
        surf(-X,-Y,T(:,:,m),'edgecolor','none');
        surf(X,-Y,T(:,:,m),'edgecolor','none');
        colormap(jet);
        zlim(zRange)
        pbaspect([1 0.5 0.75])
        titleString = strcat("Time = ",num2str(i*dt,'%1.2f')," s");
        title(titleString);
        drawnow;
        if makeMovie
            writeVideo(writerObj,getframe(gcf)); 
        end
    end
    [m,n] = deal(n,m);
    waitbar(i/N,wBar,"Solution Progress");
end

cla;
surf(X,Y,T(:,:,m),'edgecolor','none');hold on;
surf(-X,Y,T(:,:,m),'edgecolor','none');
surf(-X,-Y,T(:,:,m),'edgecolor','none');
surf(X,-Y,T(:,:,m),'edgecolor','none');
colormap(jet);
zlim(zRange)
pbaspect([1 0.5 0.75])
titleString = strcat("Time = ",num2str(2.000,'%1.2f')," s");
title(titleString);
drawnow;
if makeMovie
    writeVideo(writerObj,getframe(gcf)); 
end

close(wBar);
close(writerObj);

save(filename,'T');