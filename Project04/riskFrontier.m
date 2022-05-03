clc;clear;close all;
%% Read Data
[sigma,r,C,stonks,prices] = readStonksHistory(12,[],'1d','Mean',"stonks.csv");

%% Optimize
alpha = [0:0.001:1].^2;
N = size(sigma,1);
for i = 1:length(alpha)
    [w,optVal] = quadprog((1-alpha(i))*2*C, -alpha(i)*r,[],[],ones(1,N),[1],0.01*ones(N,1),0.2*ones(N,1));
    risk(i,1) = w'*C*w;
    ret(i,1) = r'*w;
end

for i = 1:length(alpha)
    [w,optVal] = quadprog((1-alpha(i))*2*C, -alpha(i)*r,[],[],ones(1,N),[1],0*ones(N,1),ones(N,1));
    risk(i,2) = w'*C*w;
    ret(i,2) = r'*w;
end

plot(risk(:,1),ret(:,1),'r-','linewidth',2);hold on;
plot(risk(:,2),ret(:,2),'b-','linewidth',2);
legend("Restricted","Unrestricted");
xlabel("Risk");
ylabel("Expected Return");