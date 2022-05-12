% MA342 
% Project 4 Main

clc;clear;close all;
%% Read Data
[~,~,~,stonks,prices] = readStonksHistory(12,[],'1d','Mean',"stonks.csv");
prices = flipud(prices);
save("prices","prices");
save("stonks","stonks");
%% Optimize
%rng(05282022);
clc;clear;close all;
months=6;
correlation = 1;
transactionFee = 0;
alpha = 0.1;
%alpha = 0.6675; 

colors = DefineColor();
colors(19:21,:) = [];
colors(13:15,:) = [];
colors = repmat(colors,4,1);
% Ntrials = 2000;
% f = waitbar(0,"Running");
% allReturns = zeros(Ntrials,6);
% for trial = 1:Ntrials
   clear prices
   clear returns
    load("prices.mat");
    load("stonks");
    [sigma,r,C,prices] = updateStonksHistory(prices,[]);
    N = size(sigma,1);
    doPlots = ones(N,months);
    N2 = size(prices,1);
    [w,optVal] = quadprog((1-alpha)*2*C, -alpha*r,[],[],ones(1,N),[1],0.*ones(N,1),0.2.*ones(N,1));
    for i = 1:length(w)
       if w(i) < 1e-5
           w(i) = 0;
       end
    end
    risk(1) = w'*C*w;
    ret(1) = r'*w;

    dt = 0.001;
    mu = r;
    NewData = zeros(2201,N);
    P0 = prices(1,:);
    oldW = w;
    salesCosts = zeros(1,months);
    for j = 1:months
        NewData(1,:) = prices(1,:);
        C = corrcov(C);
        %[U,D] = eig(C);
        %A = U*sqrt(D);
        A = chol(C,'lower');
        for i = 1:2200
            NewData(i+1,:) = stonks_prediction(dt,NewData(i,:),sigma,mu,correlation,A);
        end
        returns(j) = w'*((NewData(end,:)-P0)./(P0))';
        [sigma,mu,C,prices] = updateStonksHistory(prices,flipud(NewData([101:100:end],:)));
        [w,optVal] = quadprog((1-alpha)*2*C, -alpha*r,[],[],ones(1,N),[1],0.*ones(N,1),0.2.*ones(N,1));
        for i = 1:length(w)
           if w(i) < 1e-5
               w(i) = 0;
               doPlots(i,j) = 0;
           end
        end
        if j > 1 && transactionFee
            idxs = find(w < oldW);
            salesCosts(j) = sum(0.05.*(oldW(idxs)-w(idxs)));
            returns(j:end) = returns(j:end) - salesCosts(j);
        end
        risk(j) = w'*C*w;
        ret(j) = r'*w;
        oldW = w;
    end
%    allReturns(trial,:) = returns;
%    waitbar(trial/Ntrials,f,"Running");
% end
% mean(allReturns(:,end))
% std(allReturns(:,end))
% close(f);


% Test plot of stonks prediction
figure('position',[50 50 1200 500]);hold on;
days = 1:months*22;
for j = 1:months
    for i = 1:60
        if doPlots(i,j) == 1
            if j == months
                p = plot([0,days(end-22*(j)+1:end-22*(j-1))],[P0(i);flipud(prices((22*(j-1)+1):22*j,i))]./P0(i),'color',colors(i,:));
                row = dataTipTextRow("Stonk",stonks{i});
                p.DataTipTemplate.DataTipRows(end+1) = row.Value;
            elseif j == 1
                p = plot(days(end-22*(j):end),[flipud(prices((22*(j-1)+1):22*j+1,i))]./P0(i),'color',colors(i,:));
                row = dataTipTextRow("Stonk",stonks{i});
                p.DataTipTemplate.DataTipRows(end+1) = row.Value;
            else
                p = plot(days(end-22*(j):end-22*(j-1)),[flipud(prices((22*(j-1))+1:22*j+1,i))]./P0(i),'color',colors(i,:));
                row = dataTipTextRow("Stonk",stonks{i});
                p.DataTipTemplate.DataTipRows(end+1) = row.Value;
            end
        end
    end
    xline(j*22,'k-','linewidth',1);
end
xline(0,'k-','linewidth',1)
ylabel('Return (dollars/dollar)')
%yyaxis 'right'
%ylabel('Protfolio Return');
%plot([0,(1:months).*22],[0,returns],'k','linewidth',1)
xlabel('Prediction (days)')
xlim([0 132])
xticks([0:22:132])
grid
returns(end) = returns(end) - sum(salesCosts);
returns
salesCosts;