%% Problem 3 (Wave equation on a unit disk)

clc; close all; clear variables;

r = 1;                        %x^2 + y^2 result or r^2
Tmax = 20;                              %Maximum time
dt = 0.2;
dx = 0.05;
dy = 0.05;
PosX = unique([-sqrt(r):dx:sqrt(r),sqrt(r)]);
PosY = unique([-sqrt(r):dy:sqrt(r),sqrt(r)]);
Time = unique([0:dt:Tmax,Tmax]);
Sol_disk = zeros(length(PosX), length(PosY), length(Time));

%Apply BC
Sol_disk(:,:,1) = sqrt(r)/10;

%For Loop values
indxX = 2:length(PosX)-1;
indxY = 2:length(PosY)-1;
image_count = 0;

%Solve the problem
for j = 3:length(Time)

    Sol_disk(indxX,indxY,j) = 2*dt^2/dx^2 * (Sol_disk(indxX+1,indxY,j-1) - ...
        2*Sol_disk(indxX,indxY,j-1) + Sol_disk(indxX-1,indxY,j-1)) + ...
        2*dt^2/dy^2 * (Sol_disk(indxX,indxY+1,j-1) - 2*Sol_disk(indxX,indxY,j-1) + ...
        Sol_disk(indxX,indxY-1,j-1)) + 2*Sol_disk(indxX,indxY,j-1) - ...
        Sol_disk(indxX,indxY,j-2);


    image_count = image_count + 1;
end