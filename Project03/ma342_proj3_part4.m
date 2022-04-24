% MA342 
% Project 3
% El Nino La Nina

clc; close all; clear variables;

tau = 5;
N = 100;
end_time = 10;
tspan = [0, end_time];

sol = ddensd(@ddefun,@(t,y)dely(t,y,tau),@(t,y)delyp(t,y,tau),@history,tspan);

x_hist = linspace(-tau/2,0,N);
y_hist = history(x_hist);

figure(1)
hold on
plot(x_hist,y_hist(1,:),'b--',x_hist,y_hist(2,:),'r--',x_hist,y_hist(3,:),'k--')
plot(sol.x,sol.y(1,:),'b-',sol.x,sol.y(2,:),'r-',sol.x,sol.y(3,:),'k-')
xlabel('Time(t)')
ylabel('y(t)')
axis([-tau/2 end_time -1.2 1.2])

function [yp] = ddefun(t,y,ydel,dydel)
L = 100*[-7 1 2; 3 -9 0; 1 2 -6];
M = 100*[1 0 -3; -1/2 -1/2 -1; -1/2 -3/2 0];
N = 1/72*[-1 5 2; 4 0 3; -2 4 1];

yp = L*y + M*ydel + N*dydel;
end
function [h] = history(t)
h = [sin(t); sin(2*t); sin(3*t)];
end
function dy = dely(t,y,tau)
dy = t - tau;
end
function dyp = delyp(t,y,tau)
dyp = t- tau;
end