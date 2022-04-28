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

plot(risk,ret);