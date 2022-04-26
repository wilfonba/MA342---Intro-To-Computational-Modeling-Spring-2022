clc;clear;close all;

alpha = 0.5;
[sigma,r,C,stonks] = readStonksHistory("1-Jul-2014","31-Dec-2014",'1d','Mean',"exampleStonks.csv");


N = size(sigma,1);
[w,optVal] = quadprog((1-alpha)*2*C - alpha*r,[],[],ones(1,N),[1],zeros(N,1),ones(N,1));
