%% Problem 3 (Wave equation on a unit disk)

clc; close all; clear variables;

Nxy = 24;
Tmax = 1; %Maximum time
dx = 1/(Nxy-1);
dt = 1/12*dx^2;
Time = unique([0:dt:Tmax,Tmax]);
frameSteps = floor(0.005/dt);


[PosX, PosY, NTA] = waveEquationMesh(Nxy, 3, 0);
dx = max(PosX(2:end) - PosX(1:end-1));
dy = max(PosY(2:end) - PosY(1:end-1));
Sol_disk = zeros(length(PosX), length(PosY), length(Time));
[X,Y] = meshgrid(PosX,PosY);
Y = flipud(Y);

%Apply BC
Sol_disk(:,:,1) = (PosX.^0 + flip(PosY).^2)/10 .* ones(Nxy);
Sol_disk(:,:,2) = zeros(Nxy);

f = waitbar(0,'solution progress');
fig = figure();
fig.Visible = "off";

writerObj = VideoWriter('WaveEquationVideosAndData/WaveEquation','MPEG-4');
open(writerObj);


image_count = 0;
for j = 3:length(Time)
    for indxX = 1:Nxy
        for indxY = 1:Nxy
            if NTA(indxX,indxY) == 3
                Sol_disk(indxX,indxY,j) = 2*dt^2/dx^2 * (Sol_disk(indxX+1,indxY,j-1) - ...
                    2*Sol_disk(indxX,indxY,j-1) + Sol_disk(indxX-1,indxY,j-1)) + ...
                    2*dt^2/dy^2 * (2*Sol_disk(indxX,indxY+1,j-1) - 2*Sol_disk(indxX,indxY,j-1)) + ...
                    2*Sol_disk(indxX,indxY,j-1) - Sol_disk(indxX,indxY,j-2);                              %Corrected for symmetry only in x dir
            elseif NTA(indxX,indxY) == 4
                Sol_disk(indxX,indxY,j) = 2*dt^2/dx^2 * (Sol_disk(indxX-1,indxY,j-1) - ...
                    2*Sol_disk(indxX,indxY,j-1) + Sol_disk(indxX-1,indxY,j-1)) + ...
                    2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,j-1) - 2*Sol_disk(indxX,indxY,j-1) + ...
                    Sol_disk(indxX,indxY-1,j-1)) + 2*Sol_disk(indxX,indxY,j-1) - ...
                    Sol_disk(indxX,indxY,j-2);                              %Corrected for symmetry only in y dir
            elseif NTA(indxX,indxY) == 5
                Sol_disk(indxX,indxY,j) = 2*dt^2/dx^2 * (Sol_disk(indxX-1,indxY,j-1) - ...
                    2*Sol_disk(indxX,indxY,j-1) + Sol_disk(indxX-1,indxY,j-1)) + ...
                    2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,j-1) - 2*Sol_disk(indxX,indxY,j-1) + ...
                    Sol_disk(indxX,indxY+1,j-1)) + 2*Sol_disk(indxX,indxY,j-1) - ...
                    Sol_disk(indxX,indxY,j-2);                              %Corrected for symmetry in x and y dir
            elseif NTA(indxX,indxY) == 1
                Sol_disk(indxX,indxY,j) = 2*dt^2/dx^2 * (Sol_disk(indxX+1,indxY,j-1) - ...
                    2*Sol_disk(indxX,indxY,j-1) + Sol_disk(indxX-1,indxY,j-1)) + ...
                    2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,j-1) - 2*Sol_disk(indxX,indxY,j-1) + ...
                    Sol_disk(indxX,indxY-1,j-1)) + 2*Sol_disk(indxX,indxY,j-1) - ...
                    Sol_disk(indxX,indxY,j-2);
            elseif NTA(indxX,indxY) == 0
                Sol_disk(indxX,indxY,j) = NaN;
            else
                Sol_disk(indxX,indxY,j) = max((PosX.^2 + flip(PosY).^2)/10);
            end
        end
    end
    
    if image_count > 2
        cla;
        surf(X,Y,Sol_disk(:,:,j),'EdgeColor','none');hold on;
        surf(-X,Y,Sol_disk(:,:,j),'EdgeColor','none')
        surf(-X,-Y,Sol_disk(:,:,j),'EdgeColor','none')
        surf(X,-Y,Sol_disk(:,:,j),'EdgeColor','none')
        colormap("default")
        axis([-1, 1, -1, 1, -2, 2])
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