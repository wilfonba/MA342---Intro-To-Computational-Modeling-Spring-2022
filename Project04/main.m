clc;clear;close all;
%% Read Data
alpha = 0.5;
[sigma,r,C,stonks] = readStonksHistory(3,[],'1d','Mean',"stonks.csv");

%% Optimize
N = size(sigma,1);
[w,optVal] = quadprog((1-alpha)*2*C, -alpha*r,[],[],ones(1,N),[1],0.01*ones(N,1),0.2*ones(N,1));
