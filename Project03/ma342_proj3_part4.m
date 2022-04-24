% MA342 
% Project 3
% El Nino La Nina

clc; close all; clear variables;

tau = 0.5;
N = 100;
end_time = 10;
tspan = [0, end_time];

sol = ddensd(@ddefun,@(t,y)dely(t,y,tau),@(t,y)delyp(t,y,tau),@history,tspan);

x_hist = linspace(-end_time/4,0,N);
y_hist = history(x_hist);

figure(1)
hold on
plot(x_hist,y_hist(1,:),'b--',x_hist,y_hist(2,:),'r--',x_hist,y_hist(3,:),'k--')
p2 = plot(sol.x,sol.y(1,:),'b-',sol.x,sol.y(2,:),'r-',sol.x,sol.y(3,:),'k-');
xlabel('Time(t)')
ylabel('y(t)')
%title(sprintf(' \tau = %f',tau))
%legend([p2(1), p2(2), p2(3)],'h(t)=sin(t)','h(t)=sin(2t)','h(t)=sin(3t)')
axis([-end_time/4 end_time -1.2 1.2])

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