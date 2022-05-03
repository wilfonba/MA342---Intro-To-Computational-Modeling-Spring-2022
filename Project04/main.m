% MA342 
% Project 4 Main

clc;clear;close all;
%% Read Data
[sigma,r,C,stonks,prices] = readStonksHistory(12,[],'1d','Mean',"stonks.csv");
prices = flipud(prices);
save("prices","prices");
save("stonks","stonks");
%% Optimize
clc;clear;close all;
load("prices.mat");
[sigma,r,C,prices] = updateStonksHistory(prices,[]);
alpha = 0.3969;
N = size(sigma,1);
doPlots = ones(N,6);
N2 = size(prices,1);
[w,optVal] = quadprog((1-alpha)*2*C, -alpha*r,[],[],ones(1,N),[1],0*ones(N,1),ones(N,1));
for i = 1:length(w)
   if w(i) < 1e-5
       w(i) = 0;
   end
end
risk(1) = w'*C*w;
ret(1) = r'*w;

dt = 0.0001;
mu = r;
NewData = zeros(22001,N);
P0 = prices(1,:);
for j = 1:6 
    NewData(1,:) = prices(1,:);
    for i = 1:22000
        NewData(i+1,:) = stonks_prediction(dt,NewData(i,:),sigma,mu);
    end
    returns(j) = w'*((NewData(end,:)-P0)./(P0))';
    [sigma,mu,C,prices] = updateStonksHistory(prices,flipud(NewData([1001:1000:end],:)));
    [w,optVal] = quadprog((1-alpha)*2*C, -alpha*r,[],[],ones(1,N),[1],0*ones(N,1),ones(N,1));
    for i = 1:length(w)
       if w(i) < 1e-5
           w(i) = 0;
           doPlots(i,j) = 0;
       end
    end
    risk(j) = w'*C*w;
    ret(j) = r'*w;
end

% Test plot of stonks prediction
figure(3);hold on;
days = 1:132;
for j = 1:6
    for i = 1:59
        if doPlots(i,j) == 1
            if j == 6
                plot([0,days(end-22*(j)+1:end-22*(j-1))],[P0(i);flipud(prices((22*(j-1)+1):22*j,i))]./P0(i));
            else
                plot(days(end-22*(j)+1:end-22*(j-1)),[flipud(prices((22*(j-1)+1):22*j,i))]./P0(i));
            end
        end
    end
    xline(j*22,'k-','linewidth',1);
end

xlabel('Prediction')
ylabel('Stock Price')
returns