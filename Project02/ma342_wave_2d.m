%% Problem 3 (Wave equation on a unit disk)

clc; close all; clear variables;


norm = 2;
Nxy = 128;
Tmax = 5; %Maximum time
dx = 1/(Nxy-1);
dt = 0.95*1/4*dx^2;
Time = unique([0:dt:Tmax,Tmax]);
frameSteps = floor(0.005/dt);


[PosX, PosY, NTA] = waveEquationMesh(Nxy, norm, 0);
dx = max(PosX(2:end) - PosX(1:end-1));
dy = max(PosY(2:end) - PosY(1:end-1));
Sol_disk = zeros(length(PosX), length(PosY), 3);
[X,Y] = meshgrid(PosX,PosY);
Y = flipud(Y);

%Apply BC
Sol_disk(:,:,1) = (X.^norm + Y.^norm)/10;
for i = 1:Nxy
    for j = 1:Nxy
        if NTA(i,j) == 0
            Sol_disk(i,j) = NaN;
        elseif NTA(i,j) == 2
            Sol_disk(i,j) = 0.1;
        end
    end
end
Sol_disk(:,:,2) = Sol_disk(:,:,1) + dt.*zeros(Nxy);
Sol_disk(:,:,3) = NaN;

f = waitbar(0,'solution progress');
fig = figure();
fig.Visible = "off";

writerObj = VideoWriter('WaveEquationVideosAndData/WaveEquation','MPEG-4');
open(writerObj);

x = 1;y = 2;z = 3;
idxs = [1 2 3];

image_count = 0;
for j = 3:length(Time)
    for indxX = 1:Nxy
        for indxY = 1:Nxy
            if NTA(indxX,indxY) == 3
                Sol_disk(indxX,indxY,z) = 2*dt^2/dx^2 * (Sol_disk(indxX+1,indxY,y) - ...
                    2*Sol_disk(indxX,indxY,y) + Sol_disk(indxX-1,indxY,y)) + ...
                    2*dt^2/dy^2 * (2*Sol_disk(indxX,indxY+1,y) - 2*Sol_disk(indxX,indxY,y)) + ...
                    2*Sol_disk(indxX,indxY,y) - Sol_disk(indxX,indxY,x);                              %Corrected for symmetry only in x dir
            elseif NTA(indxX,indxY) == 4
                Sol_disk(indxX,indxY,z) = 2*dt^2/dx^2 * (Sol_disk(indxX-1,indxY,y) - ...
                    2*Sol_disk(indxX,indxY,y) + Sol_disk(indxX-1,indxY,y)) + ...
                    2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,y) - 2*Sol_disk(indxX,indxY,y) + ...
                    Sol_disk(indxX,indxY-1,y)) + 2*Sol_disk(indxX,indxY,y) - ...
                    Sol_disk(indxX,indxY,x);                              %Corrected for symmetry only in y dir
            elseif NTA(indxX,indxY) == 5
                Sol_disk(indxX,indxY,z) = 2*dt^2/dx^2 * (Sol_disk(indxX-1,indxY,y) - ...
                    2*Sol_disk(indxX,indxY,y) + Sol_disk(indxX-1,indxY,y)) + ...
                    2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,y) - 2*Sol_disk(indxX,indxY,y) + ...
                    Sol_disk(indxX,indxY+1,y)) + 2*Sol_disk(indxX,indxY,y) - ...
                    Sol_disk(indxX,indxY,x);                              %Corrected for symmetry in x and y dir
            elseif NTA(indxX,indxY) == 1
                Sol_disk(indxX,indxY,z) = 2*dt^2/dx^2 * (Sol_disk(indxX+1,indxY,y) - ...
                    2*Sol_disk(indxX,indxY,y) + Sol_disk(indxX-1,indxY,y)) + ...
                    2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,y) - 2*Sol_disk(indxX,indxY,y) + ...
                    Sol_disk(indxX,indxY-1,y)) + 2*Sol_disk(indxX,indxY,y) - ...
                    Sol_disk(indxX,indxY,x);
            elseif NTA(indxX,indxY) == 0
                Sol_disk(indxX,indxY,z) = NaN;
            else
                Sol_disk(indxX,indxY,z) = 0.1;
            end
        end
    end
    
    idxs = circshift(idxs,-1);
    x = idxs(1);
    y = idxs(2);
    z = idxs(3);
    
    if image_count > frameSteps
        cla;
        surf(X,Y,Sol_disk(:,:,z),'EdgeColor','none');hold on;
        surf(-X,Y,Sol_disk(:,:,z),'EdgeColor','none')
        surf(-X,-Y,Sol_disk(:,:,z),'EdgeColor','none')
        surf(X,-Y,Sol_disk(:,:,z),'EdgeColor','none')
        colormap("default")
        axis([-1, 1, -1, 1, -0.05, 0.25])
        hold off;
        image_count = 0;
        writeVideo(writerObj,getframe(gcf)); 
    end
    waitbar(j/length(Time),f,"solution progress");
    image_count = image_count + 1;
end

close(f);
close(writerObj);

% %For Loop values
% indxX = 2:length(PosX)-1;
% indxY = 2:length(PosY)-1;
% image_count = 0;
% 
% %Solve the problem
% for j = 3:length(Time)
% 
%     Sol_disk(indxX,indxY,j) = 2*dt^2/dx^2 * (Sol_disk(indxX+1,indxY,j-1) - ...
%         2*Sol_disk(indxX,indxY,j-1) + Sol_disk(indxX-1,indxY,j-1)) + ...
%         2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,j-1) - 2*Sol_disk(indxX,indxY,j-1) + ...
%         Sol_disk(indxX,indxY-1,j-1)) + 2*Sol_disk(indxX,indxY,j-1) - ...
%         Sol_disk(indxX,indxY,j-2);
% 
% 
%     image_count = image_count + 1;
% end