clc;clear;close all;
%% Initialize Constants
tau1  = 10;
tau2  = 0.1;
hist = @(t) exp(t);
tspan = [0 30];

lags = [tau1];

%% Read and organize data files
clc;
T = load("laNinoLaNinaData.csv");
% remove years from T
years = T(:,1);
T(:,1) = [];

% reshape for cubic splines
years = years - years(end,1);
tHist = (years(1):(1/12):years(end)+11/12)-1;
tHist = tHist';
Ts = zeros(length(tHist),1);
for i = 1:length(years)
    Ts((i-1)*12+1:i*12,1) = T(i,:)';
end
tHist = [tHist; 0];
Ts = [Ts;Ts(end)];



%% Solve and Plot
poly = spline(tHist,Ts);
sol = ddesd(@laNinoLaNina,lags,@(t) ppval(poly,t),tspan);

ts = linspace(-tau1,0,1000);
plot(sol.x,sol.y,'k-');hold on;
plot(tHist,Ts,'k--');
xlim([-max(abs(lags)) max(sol.x)]);