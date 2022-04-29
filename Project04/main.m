% MA342 
% Project 4 Main

clc;clear;close all;
%% Read Data
[sigma,r,C,stonks,prices] = readStonksHistory(3,[],'1d','Mean',"stonks.csv");
prices = flipud(prices);
%% Optimize
alpha = 0.75;
N = size(sigma,1);
N2 = size(prices,1);
[w,optVal] = quadprog((1-alpha)*2*C, -alpha*r,[],[],ones(1,N),[1],0.01*ones(N,1),0.2*ones(N,1));
risk = w'*C*w;
ret = r'*w;

% Test plot of stonks history
% figure(2)
% plot(prices(:,4:10))
% xlabel('Past Days')
% ylabel('Stock Price')

%% Future Stock Prediction
dt = 1;
mu = r;
NewData = zeros(20,N);
for j = 1:6 
    NewData(1,:) = prices(1,:);
    for i = 1:20
        NewData(i+1,:) = stonks_prediction(dt,NewData(i,:),sigma,mu);
    end
    [sigma,mu,C,prices] = updateStonksHistory(prices,flipud(NewData(2:end,:)));
end

% Test plot of stonks prediction
figure(3);hold on;
for i = 1:5
    plot(flipud(prices(1:end-N2-1,i)));
end
xlabel('Prediction')
ylabel('Stock Price')