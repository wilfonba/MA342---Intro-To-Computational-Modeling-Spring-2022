clc;clear;close all;

tau1  = 0.995;
tau2  = 0;
hist = @(t) exp(t);
tspan = [0 10];

lags = [tau1,tau2];

sol = ddesd(@laNinoLaNina,lags,hist,tspan);

ts = linspace(-tau1,0,1000);
plot(sol.x,sol.y,'k-');hold on;
plot(ts,hist(ts),'k--');
xlim([-max(abs(lags)) max(sol.x)]);