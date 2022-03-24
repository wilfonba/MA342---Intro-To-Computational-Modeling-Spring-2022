%MA342 
%Project 2
%Theodore Guetig

clc; close all; clear variables;

%% Problem 2 (Adding a damping term to the example)

%Problem setup
kappa = 0.35;                                %Selected values of kappa to sees the effects of a damper

L = 2;                                      %Overall length of the wire
T = 30;                                     %Maximum time
alpha = 0.1;                                %H/rho 
dt = 0.028;                                 %delta t
dx = 0.01;                                  %delta x
PosX = unique([0:dx:L,L]);                  %Creates vector for position and removes repeated values
Time = unique([0:dt:T,T]);                  %Creates vector for time and removes repeated values
Sol = zeros(length(PosX), length(Time));    %Creates empty matrix to fill with for loop and applies IC for u(x,t=0)
Sol_damped = zeros(length(PosX), length(Time));    %Creates empty matrix to fill with for loop and applies IC for u(x,t=0)

%Apply BC
Sol(:,2) = (exp(-10*(PosX-(L/2)).^2) ...
    - exp(-10*(L/2).^2))*dt;                    %Applies the initial condition for du/dt(x,t=0)
Sol_damped(:,2) = (exp(-10*(PosX-(L/2)).^2) ...
    - exp(-10*(L/2).^2))*dt;                    %Applies the initial condition for du/dt(x,t=0)

%For Loop values
r = alpha*dt^2 / dx^2;                      %Represented constant H/rho * (delta t)^2/(delta x)^2
indx = 2:length(PosX)-1;                    %Covers all columns (spatial components) of the solution matrix in the for loop from 2 to 200
image_count = 0;                            %Sets a counter variables for for loop for animation

%Solve the problem
for j = 3:length(Time)                      %Covers all the rows (time components) of the solution matrix with a for loop
    
    if dt >= dx*sqrt(alpha^(-1))
        fprintf('Please adjust your step size for stable solution \n');
        break
    end

    Sol(indx,j) = 2*Sol(indx,j-1) - ...
        Sol(indx,j-2) + r*(Sol(indx+1,j-1) - ...
        2*Sol(indx,j-1) + Sol(indx-1,j-1));

    Sol_damped(indx,j) = r*(-2*Sol_damped(indx,j-1) + ...
        Sol_damped(indx-1,j-1) + Sol_damped(indx+1,j-1))/(kappa*dt+1) + ...
        kappa*dt*Sol_damped(indx,j-1)/(kappa*dt+1) + ...
        (2*Sol_damped(indx,j-1) - Sol_damped(indx,j-2))/(kappa*dt+1);     %Fills the solution matrix for all time and positions
    
    if image_count >= 10000                     %Once counter reaches limit, update animation
        figure(1)
        subplot(2,1,2)
        plot(Sol_damped(indx,j),'r-')
        xlabel('x(position)')
        ylabel('u(displacement)')
        axis([0,L*100,-1,1])

        subplot(2,1,1)
        plot(Sol(indx,j),'k--')
        xlabel('x(position)')
        ylabel('u(displacement)')
        axis([0,L*100,-1,1])

        pause(0.1)

        image_count = 0;
    end

    image_count = image_count + 1;          %Increment the counter variable
end

%% Problem 3 (Wave equation on a unit disk)

circle_size = 1;                        %x^2 + y^2 result
Tmax = 20;                              %Maximum time
dt = 0.05;
dx = 0.01;
dy = 0.01;
PosX = unique([0:dx:sqrt(circle_size),sqrt(circle_size)]);
PosY = unique([0:dx:sqrt(circle_size),sqrt(circle_size)]);
Time = unique([0:dt:Tmax,Tmax]);
Sol_disk = zeros(length(PosX), length(PosY), length(Time));

%Apply BC
Sol_disk(:,:,1) = sqrt(circle_size)/10;

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