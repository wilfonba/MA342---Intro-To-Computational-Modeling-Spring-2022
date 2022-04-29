% MA342 
% Project 4 Main

clc;clear;close all;
%% Read Data
[sigma,r,C,stonks,prices] = readStonksHistory(3,[],'1d','Mean',"stonks.csv");

%% Optimize
alpha = [0:0.01:1].^2;
N = size(sigma,1);
for i = 1:length(alpha)
    [w,optVal] = quadprog((1-alpha(i))*2*C, -alpha(i)*r,[],[],ones(1,N),[1],0.01*ones(N,1),0.2*ones(N,1));
    risk(i) = w'*C*w;
    ret(i) = r'*w;
end

figure(1)
plot(risk,ret);
xlabel('Risk')
ylabel('Expected Return')

% Test plot of stonks history
figure(2)
plot(prices(:,4:10))
xlabel('Past Days')
ylabel('Stock Price')

%% Future Stock Prediction

start_pred = 60;
stop_pred = 80;
dt = 1;
prices_pred = prices;
mu = r;
for i = start_pred:dt:stop_pred
    Newdata = stonks_prediction(i,dt,prices_pred,sigma,mu);
    [sigma,mu,C,prices_pred] = updateStonksHistory(prices_pred,Newdata);
end

% Test plot of stonks prediction
figure(3)
plot(prices_pred(:,4:10))
xlabel('Past Days')
ylabel('Stock Price')