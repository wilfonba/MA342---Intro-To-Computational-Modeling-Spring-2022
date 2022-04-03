%MA342 
%Project 2

clc; close all; clear variables;

%% Problem 2 (Adding a damping term to the example)

movietime = 1;
writerObj = VideoWriter('WaveEquation_1D_video','MPEG-4');
open(writerObj);

%Problem setup
kappa = 0.9758;                                %Selected values of kappa to sees the effects of a damper

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
Tdip = zeros(30,1);
r = alpha*dt^2 / dx^2;                      %Represented constant H/rho * (delta t)^2/(delta x)^2
indx = 2:length(PosX)-1;                    %Covers all columns (spatial components) of the solution matrix in the for loop from 2 to 200
image_count = 0;                            %Sets a counter variables for for loop for animation
counter = 1;

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
    
    if Sol_damped(indx,j) < 0 
        if counter == 1
            Tdip(counter) = Time(j);
            fprintf('Our string dips below zero at %f sec \n',Tdip(counter));
            counter = counter + 1;
        end
    end


    
    if image_count >= 1                     %Once counter reaches limit, update animation
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

        if movietime
            writeVideo(writerObj,getframe(gcf)); 
        end
        image_count = 0;
    end
    image_count = image_count + 1;          %Increment the counter variable
end
close(writerObj);

kappa_vec = [0.35 0.4 0.5 0.75 0.96 0.97 0.975 0.9755 0.97555 0.97558 0.9757 0.9758 0.1 0.05 ...
    0.15 0.2 0.25 0.01 0.3 0.45 0.55 0.6 0.65 0.7 0.8 0.85 0.9 0.95];
time_stop = [8.008 8.12 8.344 9.996 22.96 26.824 28.812 29.82 29.848 29.876 29.932 29.988 7.28 ... 
    7 7.476 7.644 7.756 6.496 7.896 8.232 8.456 8.596 8.736 9.128 10.836 12.796 14.896 21.784];

figure(2)
plot(time_stop,kappa_vec,'r*',[0 30],[1 1],'k--')           
xlabel('Occurrence of Negative Solution (sec)')
ylabel('\kappa')
legend('Search Results','Presumed Asymptote')
axis([0 30 0 1.1])
